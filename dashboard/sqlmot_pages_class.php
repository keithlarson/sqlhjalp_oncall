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

                $this->db_leith_host=$_SESSION['parse']["LEITH_HOST"];
                $this->db_leith_user=$_SESSION['parse']["LEITH_USER"];
                $this->db_leith_pass=$_SESSION['parse']["LEITH_PASS"];

                $this->db_key=$_SESSION['parse']["SQLMOT_KEY"];
                $this->db_iv=$_SESSION['parse']["SQLMOT_IV"];
	}

	function sql_event_scheduler_check(){
	$query="show variables like 'event_scheduler'";
	$results_ar=$this->query_db($query);
	return $results_ar;
	}

	function sql_mysql_status(){
        $query="show status ";
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

        $query="SELECT MB_WL_HR FROM innodb_log_file_size WHERE time_recorded > CURDATE() ";

        $results_ar=$this->query_db($query,4);

        return $results_ar;
        }

        function sql_innodb_buffer_pool_size(){

        $query="SELECT size FROM innodb_buffer_pool_size WHERE time_recorded > CURDATE()";


        $results_ar=$this->query_db($query,4);

        return $results_ar;
        }

	function get_events(){
        $query=" SELECT events_id , events_name as title , date_format(start_date,'%Y') as s_year, date_format(start_date ,'%m') as s_month, date_format(start_date,'%d') as s_day, date_format(end_date,'%Y') as e_year, date_format(end_date,'%m') as e_month, date_format(end_date,'%d') as e_day 
FROM events    ";
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
	$title="Innodb Buffer Pool Size";
	$subtitle="Trend of ~size for Current Day Only";
	$x_axis="Hours";
	$y_axis="Recommended MB Size";
	if( sizeof($B) == 0  ){
        	$B_ar[]=0;
        	$B_ar[]=0;
		$subtitle="CURRENT RESULTS HAVE NULL RESULTS. Check Events Status";
	} else {
		if( sizeof($B) == 1 ){ $B_ar[]=0; }       
        	foreach($B as $l){
                	$B_ar[]=$l['size'];
        	}
	}
	$ydata=implode("|",$B_ar);
	echo "<img src=\"./graphs.php?ydata=".$ydata."&title=".$title."&sub_title=".$subtitle."&x_axis=".$x_axis."&y_axis=".$y_axis."\"> ";
	}


	function graphs_innodb_log_file_size(){
	$L=$this->sql_innodb_log_file_size();
	$L_ar=array();
	$title="Innodb Log File Size";
	$subtitle="Trend of ~size for Current Day Only";
	$x_axis="Hours";
	$y_axis="MB Work Load By Hour";
	if( sizeof($L) == 0  ){
        	$L_ar[]=0;
        	$L_ar[]=0;
        	$subtitle="CURRENT RESULTS HAVE NULL RESULTS. Check Events Status";
	} else {
		if( sizeof($L) == 1 ){ $L_ar[]=0;  }
        	foreach($L as $l){

                	$L_ar[]=$l['MB_WL_HR'];
        	}
	}
	$ydata=implode("|",$L_ar);

	echo "<img src=\"./graphs.php?ydata=".$ydata."&title=".$title."&sub_title=".$subtitle."&x_axis=".$x_axis."&y_axis=".$y_axis."\"> ";
	}

} # EOF
?> 

