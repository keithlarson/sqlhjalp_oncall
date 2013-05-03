<?php
/*
#################################################################################
#                                                                               #
# Copyright (c) 2013, SQLHJALP.com All rights reserved.                         #
#                                                                               #
# This program is free software; you can redistribute it and/or modify          #
# it under the terms of the GNU General Public License as published by          #
# the Free Software Foundation; version 2 of the License.                       #
#                                                                               #
# This program is distributed in the hope that it will be useful,               #
# but WITHOUT ANY WARRANTY; without even the implied warranty of                #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                 #
# GNU General Public License for more details.                                  #
#                                                                               #
# You should have received a copy of the GNU General Public License             #
# along with this program; if not, write to the Free Software                   #
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA      #
#                                                                               #
# Programmer    Keith Larson                                                    #
# Description   PHP CLASS For SQLHJALP Monitor                                  #
# https://github.com/keithlarson/sqlhjalp_oncall                                #
#                                                                               #
# This class is broken out into different sections.                             #
# They are lists below                                                          #
#        - DATABASE                                                             #
#        - AJAX                                                                 #
#        - CURRENT PAGE                                                         #
#        - PAGE                                                                 #
#        - HEADER & FOOTER                                                      #
#################################################################################
*/

require_once("./config_parse_class.php");
$parse= new file_parse();


class pages extends sqlmot{



	public function __construct(){ 
              
                $this->db_host=$_SESSION['parse']["SQLMOT_DB_HOST"];
                $this->db_user=$_SESSION['parse']["SQLMOT_DB_USER"];
                $this->db_pass=$_SESSION['parse']["SQLMOT_DB_PASS"];
                $this->db_database=$_SESSION['parse']["SQLMOT_DB_DATABASE"];
		$this->leith_on=$_SESSION['parse']["LEITH"];
                $this->db_key=$_SESSION['parse']["SQLMOT_KEY"];
                $this->db_iv=$_SESSION['parse']["SQLMOT_IV"];
	}

	function sql_event_scheduler_check(){
	$query="show variables like 'event_scheduler'";
	$results_ar=$this->query_db($query);
	return $results_ar;
	}

	function sql_mysql_status(){
        $query="SHOW GLOBAL STATUS";
        $results_ar=$this->query_db($query,4);
	$v_array=array();
	$checked_variables=array('Threads_connected','Created_tmp_disk_tables','Created_tmp_table','Created_tmp_file','Handler_read_first','Innodb_buffer_pool_wait_free','Key_reads','Open_tables','Select_full_join','Slow_queries','Uptime','Max_used_connections','wait_timeout','Key_buffer_size','Table_cache','Table_open_cache_hits','Handler_read_rnd','Innodb_row_lock_time_avg','Innodb_available_undo_logs','Innodb_buffer_pool_read_requests','Handler_read_rnd','Handler_read_rnd_next','Slow_queries','Questions','Qcache_hits','Com_select','Qcache_free_memory','Qcache_lowmem_prunes','Uptime','Select_range_check','Select_full_join');

		foreach($results_ar as $v ){
                        if (in_array($v['Variable_name'] , $checked_variables)) {
				$v_array[$v["Variable_name"]]=$v["Value"];
                        }
                }

        return $v_array;
        }


	function sql_password_check(){
        $query="SELECT 1 "; # CONCAT(user, '\@', host) as userchecks  FROM mysql.user WHERE password = '' OR password IS NULL";
        $results_ar=$this->query_db($query,4);
        return $results_ar;
        }

	function sql_variables(){
        $query="SHOW GLOBAL VARIABLES "; 
        $results_ar=$this->query_db($query,4);
	$variables=array(0);
	$variables['vcheck']=0;

	$checked_variables=array('read_buffer_size','read_rnd_buffer_size','sort_buffer_size','thread_stack','join_buffer_size','record_buffer','record_rnd_buffer','sort_buffer','max_connections','tmp_table_size','max_heap_table_size','innodb_buffer_pool_size','innodb_additional_mem_pool_size','innodb_log_buffer_size','query_cache_size','query_cache_limit','key_buffer_size','auto_increment_increment','auto_increment_offset','innodb_flush_log_at_trx_commit','innodb_force_recovery','innodb_doublewrite','innodb_fast_shutdown','innodb_max_dirty_pages_pct','flush_time','large_pages','locked_in_memory','log_warnings','low_priority_updates','max_binlog_size','max_connect_errors','myisam_repair_threads','old_passwords','optimizer_prune_level','read_buffer_size','read_rnd_buffer_size','relay_log_space_limit','slave_net_timeout','sql_notes','sync_frm','tx_isolation','expire_log_days','innodb_flush_method','innodb_data_file_path','innodb_locks_unsafe_for_binlog','innodb_support_xa','log_bin','log_output','max_relay_log_size','myisam_recover_options','storage_engine','sync_binlog','tmp_table_size','connect_timeout','debug','delay_key_write','flush','flush_time','have_bdb','init_connect','init_file','thread_cache_size','innodb_checksums');
                foreach($results_ar as $v ){
                        if (in_array($v['Variable_name'] , $checked_variables)) {
                              	$key=$v['Variable_name'];
				$value=$v["Value"];
				$variables[$key]=$value; 
				if( $v["Variable_name"] == "read_buffer_size"){ $variables['vcheck']=1; }	
                        }
                }


        return $variables;
        }

	function sql_connection_history(){
        $query="SELECT @@max_connections as variable_value2 , variable_value FROM monitor_history WHERE variable_name = 'max_used_connections' AND time_recorded > NOW() - interval 24 HOUR";
        $results_ar=$this->query_db($query,4);
        return $results_ar;
        }


	function sql_variable_history($value){
#        $query="select variable_value from monitor_history WHERE variable_name = '$value' AND time_recorded > NOW() - interval 24 HOUR";
	$query="SELECT AVG(variable_value) as variable_value , DATE_FORMAT(time_recorded,'%H') as HOUR  , time_recorded
FROM monitor_history 
WHERE variable_name = '$value' AND time_recorded > NOW() - interval 24 HOUR 
GROUP BY HOUR
ORDER BY  time_recorded DESC
;";


        $results_ar=$this->query_db($query,4);
        return $results_ar;
        }


	function sql_enginestats(){
	# Inspired by High Performance MySQL Tuning Script
	# Download this script to easily evaluate this or other database systems fast and effectively.
	# Major Hayden - major@mhtx.net
	# For the latest updates, please visit http://mysqltuner.com/
	# Git repository available at http://github.com/rackerhacker/MySQLTuner-perl

        $query="SELECT ENGINE,SUM(DATA_LENGTH) as datalength,COUNT(ENGINE) as enginecount FROM information_schema.TABLES WHERE TABLE_SCHEMA NOT IN ('information_schema','mysql') AND ENGINE IS NOT NULL GROUP BY ENGINE ORDER BY ENGINE ASC ";
        $results_ar=$this->query_db($query,4);
        return $results_ar;
        }

	function sql_tableconcerns(){
        # Inspired by High Performance MySQL Tuning Script
        # Download this script to easily evaluate this or other database systems fast and effectively.
        # Major Hayden - major@mhtx.net
        # For the latest updates, please visit http://mysqltuner.com/
        # Git repository available at http://github.com/rackerhacker/MySQLTuner-perl

        $query="SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA NOT IN ('information_schema','mysql') AND Data_free > 0 AND NOT ENGINE='MEMORY' "; 
        $results_ar=$this->query_db($query,4);
        return $results_ar;
        }


	function sql_dashboard_details(){

        $query="SELECT
                d.cron_id, d.cron_status , s.status , d.date_recorded, 
                c.cron_name as name, c.cron_type , c.domain, INET_NTOA(c.ip_address) as ip_address, c.domain_ip, c.validate, c.threshold, c.threshold_ratio,
                r.response
                FROM dashboard d
                INNER JOIN cron c ON c.cron_id = d.cron_id 
                LEFT JOIN cron_failed_response r ON r.cron_id = c.cron_id
                LEFT JOIN status s ON d.cron_status = s.status_id
                WHERE d.cron_id = '".$_GET[cron_id]."'   ";



        $results_ar=$this->query_db($query);

        return $results_ar;
        }

	function sql_contact_details($id){
        $query="SELECT contact_id,first_name, last_name, email,mobile_phone, mobile_domain , date_recorded  
                FROM contact  c   
                WHERE c.contact_id = '".$id."'   ";
        $results_ar=$this->query_db($query);

        return $results_ar;
        }

	function sql_cron_details($cron_id){

        $query="SELECT
               c.cron_id , c.cron_name, c.cron_type, c.domain, INET_NTOA(c.ip_address) as ip_address , c.domain_ip, c.command, c.validate, c. threshold, c.threshold_ratio , c.username, c.password , t.min , t.hour, t.day_of_month, t.month, t.day_of_week
                FROM cron c 
                INNER JOIN cron_times t ON t.cron_id = c.cron_id
                WHERE c.cron_id = '".$cron_id."'   ";

        $results_ar=$this->query_db($query);

        return $results_ar;
        }

	function sql_innodb_log_file_size(){

        $query="SELECT MB_WL_HR , FORMAT( (  ( @@innodb_log_file_size / 1024 ) / 1024 ) ,3) as actual  FROM innodb_log_file_size WHERE time_recorded > CURDATE() ";

        $results_ar=$this->query_db($query,4);

        return $results_ar;
        }




        function sql_innodb_buffer_pool_size(){

        $query="SELECT size ,  FORMAT( ( (   @@innodb_buffer_pool_size / 1024 ) / 1024 ) ,0) as actual FROM innodb_buffer_pool_size WHERE time_recorded > CURDATE()";
        $results_ar=$this->query_db($query,4);

        return $results_ar;
        }

	function get_events(){
        $query=" SELECT events_id , events_name as title , date_format(start_date,'%Y') as s_year, date_format(start_date ,'%m') as s_month, date_format(start_date,'%d') as s_day, date_format(end_date,'%Y') as e_year, date_format(end_date,'%m') as e_month, date_format(end_date,'%d') as e_day 
FROM events    ";
        $results_ar=$this->query_db($query,4);

        return $results_ar;
        }

	function get_one_event($id){

	$query=" SELECT events_id , events_name as title , date_format(start_date,'%Y') as s_year, date_format(start_date ,'%m') as s_month, date_format(start_date,'%d') as s_day, date_format(end_date,'%Y') as e_year, date_format(end_date,'%m') as e_month, date_format(end_date,'%d') as e_day 
FROM events  WHERE events_id = $id  ";
        $results_ar=$this->query_db($query,4);

        return $results_ar;


	}

	
	function get_documentation_info(){
        	$query="select documentation_id , chapter *1 as chapter , documentation_title FROM documentation ORDER BY chapter , page_number ASC";
        	$results_ar=$this->query_db($query,4);
        return $results_ar;
        }
	function get_documentation($id){
	$query="select page_number , chapter, documentation_title , documentation_txt, date_recorded  from documentation WHERE documentation_id = $id ";
	$results_ar=$this->query_db($query,4);
	return $results_ar;
	}

	function gb_convert($int){
	return ( ( ($int /1024) /1024 ) / 1024)." GB";
	}

	function mb_convert($int){
        return  ( ($int /1024) /1024 )." MB";
        }

	function tf($int){
	# When True is a good thing
	if($int == 1) { return "<font color=green>True</font>"; } else { return "<font color=red>False</font>"; } 
		
	}

	function ft($int){
        # When True is a bad thing
        if($int == 0) { return "<font color=green>False</font>"; } else { return "<font color=red>True</font>"; }

        }

	function gb($val){
        if($val == 'ON') { return "<font color=green>ON</font>"; } else { return "<font color=red>OFF</font>"; }
        }

	function percentage($numerator,$denominator,$warn=0.90){
		$quotient=( $numerator / $denominator );
		if ( ($quotient > 1) || ($quotient == 0 ) ){ 
			return "<font color=red>".sprintf("%.2f%%", ( $quotient  ) * 100)."</font>";
		}elseif($quotient >= $warn){
			return "<font color=orange>".sprintf("%.2f%%", ( $quotient  ) * 100)."</font>";
		}else{
			return sprintf("%.2f%%", ( $quotient  ) * 100);
		}
	}

	function get_recomendations(){
     	$recs_array=array();
	$passcheck=$this->sql_password_check();    
	$status=$this->sql_mysql_status(); 
	$variables=$this->sql_variables();

		 if($variables['vcheck']==1){ 
			$per_thread_buffers=$variables['read_buffer_size'] + $variables['read_rnd_buffer_size'] + $variables['sort_buffer_size'] + $variables['thread_stack'] + $variables['join_buffer_size'];
		 } else {
			$per_thread_buffers=$variables['record_buffer'] + $variables['record_rnd_buffer'] + $variables['sort_buffer'] + $variables['thread_stack'] + $variables['join_buffer_size'];	
		 } 
		$i=0; 
		$recs_array[$i]['title']="Max Connections";
		$recs_array[$i]['value']=$variables['max_connections'];

		$i++;
                $recs_array[$i]['title']="Max Used Connections";
                $recs_array[$i]['value']=$status['Max_used_connections'];

		$i++;
                $recs_array[$i]['title']="% connections used";
                $recs_array[$i]['value']=$this->percentage($status['Max_used_connections'],$variables['max_connections']);

		$i++;
                $recs_array[$i]['title']='Innodb Buffer Pool Size';
                $recs_array[$i]['value']=$this->mb_convert($variables['innodb_buffer_pool_size']);

                $i++;
                $recs_array[$i]['title']='Innodb Log Buffer Size';
                if( $variables['innodb_log_buffer_size'] >  16777216){
                	$innodb_log_buffer_size_result="<font color=red> TO High-->".$this->mb_convert($variables['innodb_log_buffer_size'])."</font>";
                }else{
                	$innodb_log_buffer_size_result=$this->mb_convert($variables['innodb_log_buffer_size']);
                }
                $recs_array[$i]['value']=$innodb_log_buffer_size_result;

		$i++;
                $recs_array[$i]['title']='Query Cache Size';
                if( $variables['query_cache_size'] > 134217728){
                $query_cache_size="<font color=red> TO High-->".$this->mb_convert($variables['query_cache_size'])."</font>";
                }else{
                $query_cache_size=$this->mb_convert($variables['query_cache_size']);
                }
                $recs_array[$i]['value']=$query_cache_size;


                $i++;
                $recs_array[$i]['title']='Query Cache Efficiency';
                $query_cache_efficiency = $this->percentage($status['Qcache_hits'],$status['Com_select'] + $status['Qcache_hits']);
                $recs_array[$i]['value']=$query_cache_efficiency;

		$i++;
                $recs_array[$i]['title']="% Slow Queries";
                $recs_array[$i]['value']=$this->percentage($status['Slow_queries'],$status['Questions'],0.15);

		$i++;
                $recs_array[$i]['title']="# of Joins that need an index";
		$needs_join=($status['Select_range_check'] + $status['Select_full_join']);
                $recs_array[$i]['value']=$needs_join;

		$i++;
                $recs_array[$i]['title']="# of Joins that need an index today";
                $nj_denominator=( $status['Uptime']/86400  );
                $recs_array[$i]['value']=( $needs_join / $nj_denominator  ); 



		$i++;
		$recs_array[$i]['title']="Total per thread buffer";
		$total_per_thread_buffers=$per_thread_buffers * $variables['max_connections'];
		$recs_array[$i]['value']= $total_per_thread_buffers;

		$i++;
		$max_total_per_thread_buffers=$per_thread_buffers *$status['Max_used_connections'];
		$recs_array[$i]['title']="Max Total Per Thread Buffers";
                $recs_array[$i]['value']=$max_total_per_thread_buffers;

		$i++;
		$recs_array[$i]['title']="Max Tmp Table Size";
		if( $variables['tmp_table_size'] > $variables['max_heap_table_size'] ) { 
			$max_tmp_table_size=$variables['max_heap_table_size'];
		} else {
			$max_tmp_table_size=$variables['tmp_table_size'];
		}
                $recs_array[$i]['value']= $this->mb_convert($max_tmp_table_size);


		$i++;
                $recs_array[$i]['title']="Server Buffers";
		$server_buffers=$variables['key_buffer_size'] + $max_tmp_table_size;

		if($variables['innodb_buffer_pool_size'] >0 ){ $server_buffers=$server_buffers + $variables['innodb_buffer_pool_size'];  }
		if($variables['innodb_additional_mem_pool_size'] >0 ){ $server_buffers=$server_buffers + $variables['innodb_additional_mem_pool_size'];  }
		if($variables['innodb_log_buffer_size'] >0 ){ $server_buffers=$server_buffers + $variables['innodb_log_buffer_size'];  }
		if($variables['query_cache_size'] >0 ){ $server_buffers=$server_buffers + $variables['query_cache_size'];  }
                $recs_array[$i]['value']=$server_buffers;

		$i++;
                $recs_array[$i]['title']="Max Used Memory";
		$max_used_memory=$server_buffers + $max_total_per_thread_buffer;

                	$recs_array[$i]['value']= $this->mb_convert($max_used_memory);

		$i++;
                $recs_array[$i]['title']="Total Possible Used Memory";
		$total_possible_used_memory = $server_buffers + $total_per_thread_buffers;

                        $recs_array[$i]['value']= $this->mb_convert($total_possible_used_memory);
	
	
		

		if( $variables['auto_increment_increment'] > 1  ){
		$i++;
		$recs_array[$i]['title']="Auto Increment incrementation";
                $recs_array[$i]['value']="<font color=red>".$variables['auto_increment_increment']."</font>";
	 
   		}

		if( $variables['auto_increment_offset'] > 1  ){
                $i++;
                $recs_array[$i]['title']="Auto Increment Offset";
                $recs_array[$i]['value']="<font color=red>".$variables['auto_increment_offset']."</font>";
             
                }

		$i++;
                $recs_array[$i]['title']="Connect Timeout";
                $recs_array[$i]['value']=$variables['connect_timeout'];

		$i++;
                $recs_array[$i]['title']="Thread Cache Size";
                $recs_array[$i]['value']=$variables['thread_cache_size'];

		$i++;
                $recs_array[$i]['title']="Delay key write";
                $recs_array[$i]['value']=$this->gb($variables['delay_key_write']);

		if($variables['flush'] == 'ON'){
		$i++;
                $recs_array[$i]['title']="Flush";
                $recs_array[$i]['value']="<font color=red> ".$variables['flush']."</font>";

		$i++;
                $recs_array[$i]['title']="Flush time";
                $recs_array[$i]['value']=$variables['flush_time'];
		}


		$i++;
                $recs_array[$i]['title']='Read Buffer Size';
                if( $variables['read_buffer_size'] > 8388608){
                $read_buffer_size="<font color=red> TO High-->".$this->mb_convert($variables['read_buffer_size'])."</font>";
                }else{
                $read_buffer_size=$this->mb_convert($variables['read_buffer_size']);
                }
                $recs_array[$i]['value']=$read_buffer_size;

		$i++;
                $recs_array[$i]['title']='Read Rnd Buffer Size';
                if( $variables['read_buffer_size'] > 4194304){
                $read_rnd_buffer_size="<font color=red> TO High-->".$this->mb_convert($variables['read_rnd_buffer_size'])."</font>";
                }else{
                $read_rnd_buffer_size=$this->mb_convert($variables['read_rnd_buffer_size']);
                }
                $recs_array[$i]['value']=$read_rnd_buffer_size;
		
		$i++;
                $recs_array[$i]['title']='Relay log space limit';
                $recs_array[$i]['value']=$this->ft($variables['relay_log_space_limit']);
		$i++;
                $recs_array[$i]['title']="Innodb Checksums";
                $recs_array[$i]['value']=$this->gb($variables['innodb_checksums']);

		$i++;
                $recs_array[$i]['title']="innodb_doublewrite";
                $recs_array[$i]['value']=$this->gb($variables['innodb_doublewrite']);

		$i++;
                $recs_array[$i]['title']='Key Buffer Size';
		if( $variables['key_buffer_size'] <= 8388608){
		$key_buffer_size_result="<font color=red> TO LOW-->".$this->mb_convert($variables['key_buffer_size'])."</font>";
		}else{
		$key_buffer_size_result=$this->mb_convert($variables['key_buffer_size']);
		}
		$recs_array[$i]['value']=$key_buffer_size_result;
		
		$i++;
                $recs_array[$i]['title']='InnoDB Fast Shutdown';
                $recs_array[$i]['value']=$this->tf($variables['innodb_fast_shutdown']);

		$i++;
                $recs_array[$i]['title']='InnoDB configured in strictly ACID mode';
		$recs_array[$i]['value']=$this->tf($variables['innodb_flush_log_at_trx_commit']);

		$i++;
                $recs_array[$i]['title']='InnoDB In Force Recovery Mode';
                $recs_array[$i]['value']=$this->ft($variables['innodb_force_recovery']);

		$i++;
                $recs_array[$i]['title']='Slave Net Timeout';
                if( $variables['slave_net_timeout'] > 3600){
                $slave_net_timeout ="<font color=red> TO High-->".$variables['slave_net_timeout']."</font>";
                }else{
                $slave_net_timeout =$variables['slave_net_timeout'];
                }
                $recs_array[$i]['value']=$slave_net_timeout;

		$i++;
                $recs_array[$i]['title']='Slave Skip Errors';
                $recs_array[$i]['value']=$this->ft($variables['slave_skip_errors']);

		$i++;
                $recs_array[$i]['title']='Sort Buffer Size';
                if( $variables['read_buffer_size'] > 4194304){
                $sort_buffer_size="<font color=red> TO High-->".$this->mb_convert($variables['sort_buffer_size'])."</font>";
                }else{
                $sort_buffer_size=$this->mb_convert($variables['sort_buffer_size']);
                }
                $recs_array[$i]['value']=$sort_buffer_size;



		$i++;
                $recs_array[$i]['title']='Innodb additional mem pool size'; 
                if( $variables['key_buffer_size'] > 20971520){
                $innodb_log_buffer_size_result="<font color=red> TO High-->".$this->mb_convert($variables['innodb_additional_mem_pool_size'])."</font>";
                }else{
                $innodb_log_buffer_size_result=$this->mb_convert($variables['innodb_additional_mem_pool_size']);

                }
                $recs_array[$i]['value']=$innodb_log_buffer_size_result;
	


# 
        return $recs_array;
        }

	function format_documentation($id){
	$results_ar=$this->get_documentation($id);
	$result_txt;
	$result_txt.="<div id=tablecontainer>";
	foreach($results_ar as $d) {
	
	$d["documentation_txt"]=$this->stringreplace("\n",'<br>',$d["documentation_txt"]);
	$d["documentation_txt"]=$this->stringreplace("[",'<b>',$d["documentation_txt"]);
	$d["documentation_txt"]=$this->stringreplace("]",'</b>',$d["documentation_txt"]);
	$d["documentation_txt"]=$this->stringreplace("The Tab:",'<i>The Tab:</i>',$d["documentation_txt"]);
	$d["documentation_txt"]=$this->stringreplace("The Field:",'<i>The Field:</i>',$d["documentation_txt"]);	
	
	$result_txt.="
<div id=tablerow>
	<div id=tableleft><div class=column-in>Chapter:".$d['chapter']."</div></div>
	<div id=tablemiddle><div class=column-in>".$d['documentation_title']." &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  Last Updated:".$d['date_recorded']."</div></div>
	<div id=tableright><div class=column-in>Page Number: ".$d['page_number']."</div></div>
</div>
<div id=tablerow>
	<div id=tableleft><div class=column-in></div></div>
	<div id=tablemiddle><div class=column-in>".$d['documentation_txt']." </div></div>
	<div id=tableright><div class=column-in></div></div>
</div>";	
	
	}	
	$result_txt.="</div>";
	return $result_txt;
	}


	function graphs_innodb_buffer_pool_size(){
	
	$B=$this->sql_innodb_buffer_pool_size();
	$B_ar=array();
	$A_ar=array();
	$title="Innodb Buffer Pool Size";
	$subtitle=""; #"Trend of ~size for Current Day Only";
	$x_axis="Hours";
	$y_axis="Recommended MB Size";
	$linetitle1="Recommended";
	$linetitle2="Actual";
	if( sizeof($B) == 0  ){
        	$B_ar[]=0;
        	$B_ar[]=0;
		$subtitle="CURRENT RESULTS HAVE NULL RESULTS. Check Events Status";
	} else {
		if( sizeof($B) == 1 ){ $B_ar[]=0; }       
        	foreach($B as $l){
                	$B_ar[]=$l['size'];
			$A_ar[]=$l['actual'];
        	}
	}
	$ydata=implode("|",$B_ar);
	$ydata2=implode("|",$A_ar);
	echo "<img src=\"./graphs.php?ydata=".$ydata."&title=".$title."&sub_title=".$subtitle."&x_axis=".$x_axis."&y_axis=".$y_axis."&ydata2=".$ydata2."&linetitle1=$linetitle1&linetitle2=$linetitle2\"> ";
	}


	function graphs_innodb_log_file_size(){
	$L=$this->sql_innodb_log_file_size();
	$L_ar=array();
	$A_ar=array();
	$title="Innodb Log File Size";
	$subtitle="Trend of ~size for Current Day Only";
	$x_axis="Hours";
	$y_axis="MB Work Load By Hour";
	$linetitle1="Recommended";
        $linetitle2="Actual";
	if( sizeof($L) == 0  ){
        	$L_ar[]=0;
        	$L_ar[]=0;
        	$subtitle="CURRENT RESULTS HAVE NULL RESULTS. Check Events Status";
	} else {
		if( sizeof($L) == 1 ){ $L_ar[]=0;  }
        	foreach($L as $l){
                	$L_ar[]=$l['MB_WL_HR'];
			$A_ar[]=$l['actual'];
        	}
	}
	$ydata=implode("|",$L_ar);
	$ydata2=implode("|",$A_ar);
	echo "<img src=\"./graphs.php?ydata=".$ydata."&title=".$title."&sub_title=".$subtitle."&x_axis=".$x_axis."&y_axis=".$y_axis."&ydata2=".$ydata2."&linetitle1=$linetitle1&linetitle2=$linetitle2 \"> ";
	}

	function graph_connection_history(){
	$L=$this->sql_connection_history();
	$L_ar=array();
        $A_ar=array();
        $title="Connections History Last 24 Hours";
        $subtitle="Trend of Used connections ";
        $x_axis="Hours";
        $y_axis="";
        $linetitle1="Max Connections ";
        $linetitle2="Used";
	$trip=0;
        if( sizeof($L) == 0  ){
                $L_ar[]=0;
                $L_ar[]=0;
                $subtitle="CURRENT RESULTS HAVE NULL RESULTS. Check Events Status";
        } else {
                if( sizeof($L) == 1 ){ $L_ar[]=0;  }
                foreach($L as $l){
			if($trip==0){ $L_ar[]=$l['max']+1; $trip=1; } else { $L_ar[]=$l['max']; }
                        $A_ar[]=$l['used'];
                }
        }
        $ydata=implode("|",$L_ar);
        $ydata2=implode("|",$A_ar);
        echo "<img src=\"./graphs.php?ydata=".$ydata."&title=".$title."&sub_title=".$subtitle."&x_axis=".$x_axis."&y_axis=".$y_axis."&ydata2=".$ydata2."&linetitle1=$linetitle1&linetitle2=$linetitle2 \"> ";
	}



	function graph_variable_history($value,$x_axis,$y_axis,$linetitle1,$size=0){
	if($value=="MAX_USED_CONNECTIONS"){
		$L=$this->sql_connection_history();
		$linetitle2="Max";
	} else{
        	$L=$this->sql_variable_history($value);
	}
        $L_ar=array();
	$A_ar=array();
	$HOURS=array();
	$hour = array();
        $title=" $value History";
        $subtitle="Trend for Last 24 Hours Only";
        $trip=0;
        if( sizeof($L) == 0  ){
                $L_ar[]=0;
                $L_ar[]=0;
		$HOURS[]=0;
                $subtitle="CURRENT RESULTS HAVE NULL RESULTS. Check Events Status";
        } else {
                #if( sizeof($L) == 1 ){ $L_ar[]=0;  }
                foreach($L as $l){
      		 	$L_ar[]=$L_ar[]=$l['variable_value']; 
			if($trip==0){
		 		if($l['variable_value'] > 0) {$L_ar[]=$l['variable_value']+0.0001; $trip=1; }  ;
		 		if($l['variable_value2'] > 0) {$A_ar[]=$l['variable_value2']+0.001; $trip=1; };
				
			} else {
				$L_ar[]=$l['variable_value'];
				$A_ar[]=$l['variable_value2'];

			}
			if($l['HOUR']){
				$HOURS[]=$l['HOUR'];
			}
                }
        }

        $ydata=implode("|",$L_ar);
	$ydata2=implode("|",$A_ar);
	$hours_data=implode("|",$HOURS);

	if($size==1){
		$size_adjusted="&width=550&height=450";
	}
	$pass_line2="&ydata2=".$ydata2."&linetitle2=$linetitle2";
	$passtitles="&title=".$title."&sub_title=".$subtitle."&x_axis=".$x_axis."&y_axis=".$y_axis."&linetitle1=$linetitle1";
	$pass_ydata2="&ydata2=".$ydata2;
	$hours_data="&HOURS=".$hours_data;
        echo "<a href=\"./index.php?page=graph_details&VNAME=".$value."&VXT=".$x_axis."&VYT=".$y_axis."&VLT=".$linetitle1."\"><img src=\"./graphs.php?ydata=".$ydata.$pass_ydata2.$passtitles.$size_adjusted.$pass_line2.$hours_data." \"></a>";
        }


} # EOF
?> 

