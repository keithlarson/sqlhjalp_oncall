<?php
/*
#################################################################################
#										#
# Copyright (c) 2013, SQLHJALP.com All rights reserved.			 	#
#										#
# This program is free software; you can redistribute it and/or modify		#
# it under the terms of the GNU General Public License as published by		#
# the Free Software Foundation; version 2 of the License.			#
#										#
# This program is distributed in the hope that it will be useful,		#
# but WITHOUT ANY WARRANTY; without even the implied warranty of		#
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the			#
# GNU General Public License for more details.					#
#										#
# You should have received a copy of the GNU General Public License		#
# along with this program; if not, write to the Free Software			#
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA	#
#										#
# Programmer	Keith Larson							#
# Description	PHP CLASS For SQLHJALP Monitor 					#
# https://github.com/keithlarson/sqlhjalp_oncall				#
#										#
# This class is broken out into different sections. 				#
# They are lists below								#
#        - DATABASE								#
#        - AJAX									#
#        - CURRENT PAGE								#
#        - PAGE									#
#        - HEADER & FOOTER							#
#################################################################################
*/
require_once("./config_parse_class.php");
$parse= new file_parse();

class sqlmot {

 	private $title;
	private $location;
        private $js_extra;

 	public $db_host;
 	public $db_user;
 	public $db_pass;
 	public $db_database;
	public $leith_on;
	public $Twilio_SID;    
	public $Twilio_TOKEN;
	public $Twilio_PHONE;
	public $db_key;
	public $db_iv;
	public $page;
	public $jquery;

        public function __construct(){ 
		# $_SESSION['parse']["SQLMOT_HTTPS"]==0
                if($_SERVER["HTTPS"]){
                        $this->SITEROOT="https://".$_SERVER["HTTP_HOST"];
                }else{ 
                        $this->SITEROOT="http://".$_SERVER["HTTP_HOST"];
                }

		$this->Twilio_SID=$_SESSION['parse']["ACCOUNTSID"];
		$this->Twilio_TOKEN=$_SESSION['parse']["AUTHTOKEN"];
		$this->Twilio_PHONE=$_SESSION['parse']["PHONE"];

		$this->db_host=$_SESSION['parse']["SQLMOT_DB_HOST"];
		$this->db_user=$_SESSION['parse']["SQLMOT_DB_USER"];
		$this->db_pass=$_SESSION['parse']["SQLMOT_DB_PASS"];
		$this->db_database=$_SESSION['parse']["SQLMOT_DB_DATABASE"];

		$this->leith_on=$_SESSION['parse']["LEITH"]; 
             

		$this->db_key=$_SESSION['parse']["SQLMOT_KEY"];
		$this->db_iv=$_SESSION['parse']["SQLMOT_IV"];
		$this->location=$this->SITEROOT.$_SESSION['parse']["SQLMOT_LOCATION_HTTP"];
		$this->title="SQLHJALP.com SYSTEM MONITOR";
    
		if($_POST['page']){$_GET['page'] = $_POST['page'];  }
		$this->page=$_GET[page];

		switch($this->page) {
                case "contacts_details";
               		$this->js_extra="scriptaculous"; 
                break;
                case "dashboard_details";
                        $this->js_extra="scriptaculous";
                break;
		case "cron_details";
                        $this->js_extra="scriptaculous";
                break;
		default:
    			$this->js_extra="OFF"; 
                break;

		}	

      }



	####################
	# DATABASE FUNCTIONS
	####################


	function jquery_api(){ 

	switch($this->jquery) {
		
                case "dashboard";
                      # DASHBOARD QUERY
                      $query="SELECT 
				d.cron_id , 
				c.cron_name as name,
				d.cron_status,
				CONCAT('<font color=',s.color,'>',s.status,'</font>') as status,
				c.threshold as threshold,
				d.date_recorded  as last_ran, 
				r.response
				FROM dashboard d
				INNER JOIN cron c ON c.cron_id = d.cron_id 
				LEFT JOIN cron_failed_response r ON r.cron_id = c.cron_id  AND d.date_recorded <= r.date_recorded 
				LEFT JOIN status s ON d.cron_status = s.status_id
				GROUP BY d.cron_id 
				ORDER BY d.date_recorded DESC
			";

                break;
		case "dashboard_details";
                      # DASHBOARD DETAILED QUERY
                      $query="SELECT 
                                d.cron_id , 
                                c.cron_name as name,
                                d.cron_status as status ,
                                c.threshold as threshold,
                                d.date_recorded as last_ran, 
                                r.response
                                FROM dashboard d
                                INNER JOIN cron c ON c.cron_id = d.cron_id 
                                LEFT JOIN cron_failed_response r ON r.cron_id = c.cron_id
				WHERE d.cron_id = '".$GET[cron_id]."' 	";
                break;
		case "cron_type";
		        $query="SELECT COLUMN_TYPE as type, COLUMN_TYPE as value FROM INFORMATION_SCHEMA.COLUMNS 
                	WHERE TABLE_SCHEMA = '".$this->db_database."' 
                	AND TABLE_NAME = 'cron' 
                	AND COLUMN_NAME = 'cron_type'";	
		break;
		case "crons";
			$query="SELECT cron_id , cron_name , time_recorded FROM cron ";
		break;
		case "cron_details";
                      # CRONS DETAILED QUERY
                      $query="SELECT c.cron_id , c.cron_name, c.cron_type, c.domain, INET_NTOA(c.ip_address) as ip_address , c.domain_ip,c.command, c.validate, c. threshold, c.threshold_ratio , c.runtime
                                FROM  cron c 
                                WHERE c.cron_id = '".$GET[cron_id]."'   ";
                break;
		case "history";
		$query="SELECT c.cron_id , c.cron_name as name, CONCAT('<font color=',s.color,'>',s.status,'</font>') as status , h.date_recorded  as last_ran 
		FROM cron_history h 
		INNER JOIN cron c ON h.cron_id = c.cron_id 
		INNER JOIN status s ON h.status_id = s.status_id 
		WHERE h.date_recorded > NOW() - interval 40 DAY
		ORDER BY h.date_recorded  DESC";

                break;	
		case "contacts";
                        $query="SELECT contact_id, email, first_name, last_name,  date_recorded  FROM contact  ";
                break;
                case "contacts_details";
                      # Contact DETAILED QUERY
                   	$query="SELECT contact_id,first_name, last_name, email,mobile_phone, mobile_domain , date_recorded  
				FROM contact  c   
                                WHERE c.contact_id = '".$GET[id]."'   ";
                break;
		case "threshold_ratio";
                        $query="SELECT COLUMN_TYPE as type, COLUMN_TYPE as value FROM INFORMATION_SCHEMA.COLUMNS 
                        WHERE TABLE_SCHEMA = '".$this->db_database."' 
                        AND TABLE_NAME = 'cron' 
                        AND COLUMN_NAME = 'threshold_ratio'";
                break;
		case "domain_ip";
                        $query="SELECT COLUMN_TYPE as type, COLUMN_TYPE as value FROM INFORMATION_SCHEMA.COLUMNS 
                        WHERE TABLE_SCHEMA = '".$this->db_database."' 
                        AND TABLE_NAME = 'cron' 
                        AND COLUMN_NAME = 'domain_ip'";
                break;
		case "mobile_domain";
                        $query="SELECT COLUMN_TYPE as type, COLUMN_TYPE as value FROM INFORMATION_SCHEMA.COLUMNS 
                        WHERE TABLE_SCHEMA = '".$this->db_database."' 
                        AND TABLE_NAME = 'contact' 
                        AND COLUMN_NAME = 'mobile_domain'";
                break;
		case "day_of_week";
			$query=" CALL day_of_week()  ";
		
		break;
		case "month";
                        $query=" CALL month() ";
	
                break;
		case "day_of_month";
                        $query=" CALL day_of_month() ";

                break;
		case "hour";
                        $query=" CALL hour() ";

                break;
		case "min";
                        $query=" CALL minutes() ";
                break;
		case "documentation";
			$query="select page_number , chapter, documentation_title , documentation_txt,date_recorded from documentation WHERE documentation_id ='".$_GET['id']."'";
		break;
		case "ps_95per";
                        $query="select query,full_scan,exec_count,err_count,warn_count,total_latency,max_latency,avg_latency,rows_sent,rows_sent_avg,rows_scanned from ps_helper.statements_with_runtimes_in_95th_percentile ORDER BY rows_scanned DESC ";
                break;
		case "ps_sfts";
                        $query="select query,exec_count,no_index_used_count,no_good_index_used_count,no_index_used_pct from ps_helper.statements_with_full_table_scans ORDER BY exec_count DESC limit 10; ";
                break;
		case "ps_tgcal";
                        $query="select * from ps_helper.top_global_consumers_by_avg_latency";
                break;
		case "ps_tgctl";
                        $query="select * from ps_helper.top_global_consumers_by_total_latency";
                break;
		case "ps_tgtl";
                        $query="select * from ps_helper.top_io_by_thread";
                break;
		case "notification";
			$query="SELECT n.cron_notifications_id , n.cron_id , c.cron_name , 
CASE
WHEN n.contact_id = 0 THEN 'ADMIN'
ELSE  ct.first_name
END as first_name, 
CASE
WHEN n.contact_id = 0 THEN 'CONTACT'
ELSE  ct.last_name
END as last_name, 
CONCAT('<font color=',s.color,'>',s.status,'</font>') as status
FROM cron_notifications n
INNER JOIN cron c ON c.cron_id = n.cron_id
LEFT JOIN contact ct ON ct.contact_id = n.contact_id
LEFT JOIN status s ON n.status_id = s.status_id
WHERE n.time_recorded > NOW() - interval 40 DAY ORDER BY n.time_recorded DESC";
		break;

	}
	
	# Option 3 will output json array data
        header('Content-type:application/json; charset=utf-8');
        $this->query_db($query,3);

        exit;

	}


        function query_db($query,$i=1,$response=""){

	$mysqli = new mysqli($this->db_host,$this->db_user,$this->db_pass,$this->db_database) or die("Connect failed: %s\n ". $mysqli->connect_error  );
	$docs=0;
 	if (preg_match("/FROM documentation/i",$query)) { $docs=1; }

#	if (preg_match("/ps_helper./i",$query)) {
#		# CHANGE mysqli connection for ps_helper user and information
#		$mysqli = new mysqli($this->db_leith_host,$this->db_leith_user,$this->db_leith_pass,'ps_helper') or die("Connect failed: %s\n ". $mysqli->connect_error  );
#	}

        $result = $mysqli->query($query) or die("Query Error $query");
        $_SESSION['last_query']=$query;

        /* numeric array */
        #       $row = $result->fetch_array(MYSQLI_NUM);
        #       printf ("%s (%s)\n", $row[0], $row[1]);

        /* associative array */
        #       $row = $result->fetch_array(MYSQLI_ASSOC);
        #       printf ("%s (%s)\n", $row["Name"], $row["CountryCode"]);


        if($i == 1){

        /* RETURNS associative and numeric array */
        $row = $result->fetch_array(MYSQLI_BOTH);
        #       printf ("%s (%s)\n", $row[0], $row["CountryCode"]);

        /* free result set */
        $result->free();

        }elseif($i == 2){

                /*RETURNS Last ID*/
                return $mysqli->insert_id;

        }elseif($i == 3){

        /* RETURNS Json results */

                $json_ar=array();
                $tmp_ar=array();
                while($row = $result->fetch_array(MYSQLI_BOTH) ){
			if (preg_match("/^enum/i", $row[0])) {
                
				$string = $this->between_string($row[0],"enum(", ")");
        			$array=$this->explodestring($string,",");
				foreach($array as $a ){
         			$aa=$this->stringreplace("'",'',$a);
                                $tmp_ar[]="['".$aa."', '".$aa."']";
			         }
	
 
			} else {			
				 if($docs==1){
					$row["documentation_txt"]=$this->stringreplace("\n",'<br>',$row["documentation_txt"]);
					$row["documentation_txt"]=$this->stringreplace("\t",'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',$row["documentation_txt"]);
					$row["documentation_txt"]=$this->stringreplace("[",'<b>',$row["documentation_txt"]);
        				$row["documentation_txt"]=$this->stringreplace("]",'</b>',$row["documentation_txt"]);
        				$row["documentation_txt"]=$this->stringreplace("The Tab:",'<i>The Tab:</i>',$row["documentation_txt"]);
        				$row["documentation_txt"]=$this->stringreplace("The Field:",'<i>The Field:</i>',$row["documentation_txt"]);

		 		}
                        	$json_ar[]=$row;
                        	$tmp_ar[]="['".$row[0]."', '".$row[1]."']";
			}
                }
              
                if($_GET['t']=='s'){ echo "[".implode(',',$tmp_ar)."]"; } else { echo json_encode($json_ar); }

        }elseif($i == 4){

         /*RETURNS ARRAY*/
                $results_array=array();
                while($row = $result->fetch_array(MYSQLI_ASSOC) ){
                        $results_array[]=$row;
                }

         } elseif($i == 5){
 		$results_array=array();
                 while($row = $result->fetch_array(MYSQLI_NUM) ){
                         $results_array[]=$row;
                 }
	}

        /* close connection */
        $mysqli->close();

        if($i == 4){ return $results_array; } elseif($i == 6){ echo $response;}else{return $row;}
        }  /* close query_db */


	function key_value(){
	 $query="SELECT RAND() as kv";

        $results_ar=$this->query_db($query,1);

        return $results_ar;
	}

	



	function sql_gather_enum($schema,$table,$column){
	/*
	Pass the schema name, table name and column name to return the parsed  
	*/
	$query="SELECT COLUMN_TYPE 
		FROM INFORMATION_SCHEMA.COLUMNS 
		WHERE TABLE_SCHEMA = '".$schema."' 
		AND TABLE_NAME = '".$table."'  
		AND COLUMN_NAME = '".$column."'";

		$results_ar=$this->query_db($query,4);

	return $results_ar;	
	}

	function add_new_cron($cron_name){
	$query=" INSERT INTO cron (`cron_name`) VALUES ( '$cron_name') ";

	$id=$this->query_db($query,2);

	# Instead of this I moved it to the crons trigger 
	#$query=" INSERT INTO cron_times (  `cron_id`) VALUES ( '$id') ";
        #$id=$this->query_db($query,2);

        return $id;
	}

	function add_new_contact($email){
        $query=" INSERT INTO contact (`email`) VALUES ( '$email') ";

        $id=$this->query_db($query,2);

        return $id;
        }

	function add_new_event($record){

      	if(isset($record['primary'])) { $primary=1; } else { $primary=0; }

	
	$s_array = $this->explodestring($record['start_date'],"/");
	$s_month=$s_array[0];
       	$s_day=$s_array[1];
        $s_year=$s_array[2];
        $record['start_date']=$s_year."-".$s_month."-".$s_day;

	$e_array = $this->explodestring($record['end_date'],"/");
        $e_month=$e_array[0];
        $e_day=$e_array[1];
        $e_year=$e_array[2];
        $record['end_date']=$e_year."-".$e_month."-".$e_day;

	

	$query="INSERT INTO events
	SELECT NULL , CONCAT( c.first_name , ' ', c.last_name  ) as events_name , c.contact_id , '".$record['start_date']."', '".$record['end_date']."', $primary 
	FROM contact c 
	WHERE c.contact_id =".$record['id'] ;

        $id=$this->query_db($query,2);

        return $id;
        }

	
       



	#################
	# AJAX FUNCTIONS 
	#################
	/* **************************
	$record['id']
	$record['display']
	$record['defaultvalue']
	$record['updatetable']
	$record['updatefield']
	$record['mode']
	$record['collection'][]
	$record['url']
	$record['page']
	$record['jquery']
	************************** */

	function ajax_display($record){

        $ajay_options="rows:2,cols:15,submitOnBlur: true, okButton: false, cancelLink:false,ajaxOptions:{method: 'post'}";
        $area_style=" style=\"height:30px;;width:120px;cursor:hand\" ";
        $id=$record['updatefield']."_".$record['id'];
        $collection=$record['collection'];  #explode($record['collection']);
        $value=$record['defaultvalue'];
        $attr = 1;
        if($record['mode']!="" ){$mode=$record['mode'];}
        if($record['display']!="" ){$original_display=$record['display'];}
        if($record['updatefield']!="" ){$field="&field=".$record['updatefield'];}
        if($record['updatetable']!="" ){$table="&table=".$record['updatetable'];}

        if(isset($record['loadtokens'])){ $loadtokens="&".$record['loadtokens'];}
        if(isset($record['passtokens'])){ $passtokens="&".$record['passtokens'];}

        $jquery=$record['jquery'];
        if( isset($record['w']) ){$w="&w=".$record['w'];}
        if( isset($record['j']) ){$j="&j=".$record['j'];}


      $ajay_options="rows:1,cols:15,submitOnBlur: true, okButton: false, cancelLink:false,ajaxOptions:{method: 'post'}";
        $area_style=" style=\"height:30px;;width:180px;cursor:hand\" ";

      $id=$field."_".$record['id'];
      $attr = 1;
      if( $mode=="list"):
         if($original_display==""):
            $original_display="[edit]";
         endif;
            $original_display ="<p ".$area_style." id=\"".$id."\">".$original_display."</p>";
            $original_display.="
                <script>
                        new Ajax.InPlaceEditor($('".$id."'), 'index.php?page=API&jquery=".$jquery.$table.$field.$w.$j.$loadtokens."',
                        {
                        callback: function(form, value) { return 'value=' + encodeURIComponent(value) +'&_method=PUT' },
                        rows:1,
                        cols:15,
                        submitOnBlur: true,
                        okButton: false,
                        cancelLink:false,
                        ajaxOptions:{method: 'post'}
                        }
                        );
                </script>";

      	endif;
      	return html_entity_decode($original_display);
    	} /* ajax_display  */

    function name_display($original_display,$record,$table,$field, $mode="")
    {
	if( ($field=="password") && ($original_display!="") ){ $original_display="********"; }
	if($record['type']=="textbox"){
		$rows=10;
		$cols=25;
		$height=30;
		$width=180;
	} else {
		$rows=1;
        	$cols=15;
		$height=30;
                $width=180;
	}
	$ajay_options="rows:".$rows.",cols:".$cols.",submitOnBlur: true, okButton: false, cancelLink:false,ajaxOptions:{method: 'post'}";
        $area_style=" style=\"height:".$height."px;;width:".$width."px;cursor:hand\" ";
      $id=$field."_".$record['id'];
      $attr = 1;
      if( $mode=="list"):
         if($original_display==""):
            #$original_display="[edit]";
         endif;
            $original_display ="<p ".$area_style." id=\"".$id."\">".$original_display."</p>";
            $original_display.="
                <script>
                        new Ajax.InPlaceEditor($('".$id."'), 'index.php?page=AJAX&enc_it=1&id=".(int)$record['id']."&field=".urlencode($field)."&table=".urlencode($table)."', 
                        {
                        callback: function(form, value) { return 'value=' + encodeURIComponent(value) +'&_method=PUT' },
                        rows:".$rows.",
                        cols:".$cols.",
                        submitOnBlur: true, 
                        okButton: false, 
                        cancelLink:false,
                        ajaxOptions:{method: 'post'}
                        } 
                        );
                </script>";

      endif;
      return html_entity_decode($original_display);
    } /* name_display  */


    function select_display($record){
        $ajay_options="rows:2,cols:15,submitOnBlur: true, okButton: false, cancelLink:false,ajaxOptions:{method: 'post'}";
        $area_style=" style=\"height:30px;;width:120px;cursor:hand\" ";
        $id=$record['updatefield']."_".$record['id'];
        $collection=$record['collection']; 
        $value=$record['defaultvalue'];
        $attr = 1;
        $mode=$record['mode'];
        $original_display=$record['display'];
        $field=$record['updatefield'];
        $table=$record['updatetable'];
        $jquery=$record['jquery'];
        $loadtokens=$record['loadtokens'];
        $passtokens=$record['passtokens'];
	if(isset($record['title'])){ $title=$record['title']."<br>"; } else { $title="";  }
      if( $mode=="list"):
         if($original_display==""):
            $original_display="[edit]";
         endif;
            $original_display ="<p ".$area_style." id=\"".$id."\"> ".$title." ".$original_display."</p>";
            $original_display.="
                <script>
                        new Ajax.InPlaceCollectionEditor(
                        $('".$id."'), 'index.php?page=AJAX&id=".$record['id']."&field=".urlencode($field)."&table=".urlencode($table).$passtokens."' ,
			{
                        loadCollectionURL: 'index.php?page=API&t=s&jquery=".$jquery.$loadtokens."',
                        value: '".$value."',
                        callback: function(form, value) { return 'value=' + encodeURIComponent(value) +'&_method=PUT' },
                        rows:2,
                        cols:15,
                        submitOnBlur: true,
                        okButton: true,
                        cancelLink:false,
                        ajaxOptions:{method: 'get'}
                        } );
                </script>"; /* original_display */
      endif;
      return html_entity_decode($original_display);

    } /* select_display  */

   function update_display(){

    /* set some vars */
   $id_name=urldecode($_GET['table']);
   $table=urldecode($_REQUEST['table']);
   $field=urldecode($_REQUEST['field']);
   $value=trim($_REQUEST['value']);
   $id=$_REQUEST['id'];
	if( $field=="password") {
		$db_value=base64_encode($value); # $this->crypt_e($value);
	}else{
   		$db_value=$value;
	}
   $db_value=html_entity_decode($db_value);

   if( $id_name == "cron_times"  ) { $id_name="cron"; } 
   if($field=="ip_address"){
	$query="UPDATE ".$table." SET ".$field."=  INET_ATON('".$db_value."')  WHERE ".$id_name."_id='$id'  ";
   } else {
   	$query="UPDATE ".$table." SET ".$field."='".$db_value."'  WHERE  ".$id_name."_id='$id'   ";
   }
	# mysql_real_escape_string()
   $this->query_db($query,6,$value);

   } /* update_display  */




	#####################
	# CURRENT PAGE SWITCH
	#####################
        function current_page(){

		switch($this->page) {

		case "API";
                        #API for jquery Page
                        $this->jquery_api();
                break;
                case "AJAX";
                        #AJAX UPDATE
                        $this->update_display();
                break;
		case "contacts";
                        # Contacts Overview 
                       	require('html_files/contacts.html'); 
                break;
		case "contacts_details";
                        # Contact Details 
                        require('html_files/contacts_details.html');
                break;
		case "crons";
                        # CRON JOBS 
                        require('html_files/crons.html');
                break;
                case "cron_details";
                        # CRON DETAIL
                        require('html_files/cron_details.html');
                break;
		case "dashboard";
	                #DASHBOARD
	               	require('html_files/dashboard.html'); 
	        break;
		case "dashboard_details";
                        #DASHBOARD DETAILS
                       	require('html_files/dashboard_details.html'); 
                break;
		case "database";
                        # Database Details 
                        require('html_files/database.html');
                break;
		case "docs";
                        # Documentation Details 
                        require('html_files/documentation.html');
                break;
		case "graph_details";
                        # Graphs Details 
                        require('html_files/graph_details.html');
                break;
		case "history";
                        #HISTORY OF ALERTS
                      	require('html_files/history.html');	
                break;
		case "schedule";
                        #HISTORY OF ALERTS
                        require('html_files/schedule.html');
                break;


		default:
       			require('html_files/dashboard.html');
                break;
	
		}
		
	}

        ################
        # PAGE FUNCTIONS  
        ################


	function php_gather_enum($schema,$table,$column){
	/*
        Pass the schema name, table name and column name to return the options for a select statement 
        */
	$value=$this->sql_gather_enum($schema,$table,$column);

	$string = $this->between_string($value[0]["COLUMN_TYPE"],"enum(", ")");
	$array = $this->explodestring($string,",");

	 foreach($array as $a ){
	 $aa=$this->stringreplace("'",'',$a);
         $html.=" <option value=".$a." label=".$a." > ".$aa."  </option> ";
         }
	echo $html; 
	}	


	function between_string($string, $start, $end){
	/*
	Taken From
	http://php.net/manual/en/ref.strings.php	
	administrador(ensaimada)sphoera(punt)com
	*/	
    	$string = " ".$string;
     	$ini = strpos($string,$start);
     	if ($ini == 0) return "";

     	$ini += strlen($start);     
     	$len = strpos($string,$end,$ini) - $ini;
     	return substr($string,$ini,$len);
	}


	function explodestring($string,$del){
	# Explodes a string. This is only here to allow a single point of edits if we need to adjust procedures. 	
	$e = explode($del, $string);
	return $e; 
	}

	function stringreplace($current,$new,$string){
	# I place this here so we can adjust in the future if needed 
	return str_replace($current, $new, $string);
	}

	function draw_single_select($record){

	if($record['required']==1){ $required="required"; } else { $required=" "; }
	if(isset($record['form_name'])){ $formname="form=".$record['form_name'];} else { $formname=""; }

   	if(!isset($default)) { $default = '--';} else { $default = $record['default'];  }

	 $query="SELECT ".$record['table']."_id , ".$record['field']." as field FROM ".$record['table']." ORDER BY field ASC  ";
	
	 $results_ar=$this->query_db($query,4);	


	$option_ar = array("<option value=''>".$default."</option>");
	foreach($results_ar as $list) {
	
	if($list[$record['table'].'_id']==$selected){ $sel_flag='SELECTED'; }else{ $sel_flag='';}
	array_push($option_ar,"<option value='".$list[$record['table'].'_id']."' $sel_flag> ".$list['field']." </option>");

	}
   
   	$select_html = "\n<SELECT $formname  name=".$record['name']." $required  >\n".implode("\n",$option_ar)."\n</SELECT>\n";

   	return $select_html;
	}

	function crypt_e($string){
	/*
		encrypt a PASSWORD	
	*/	
	return	openssl_encrypt($string, "aes-128-cbc", $this->db_key, true, $this->db_iv);
	
        }

	function crypt_d($string){
        /*
                decrypt a PASSWORD      
        */
        return  openssl_decrypt($string, "aes-128-cbc", $this->db_key, true, $this->db_iv);
        
        }	

	###########################
	# HEADER & FOOTER FUNCTIONS
	##########################
        function HEADERS() {
         echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
        ?>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN""http://www.w3.org/TR/html4/strict.dtd">
        <!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
	<!-- Navigation Graphics Originally created by Micha Hanson www.linkedin.com/in/michahanson/  -->
        <head>
        <title><?php echo $this->title; ?></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel='stylesheet' href='<?php echo $this->location; ?>css/cupertino_theme.css'>
	<link href='<?php echo $this->location; ?>css/fullcalendar.css' rel='stylesheet'>
	<link href='<?php echo $this->location; ?>css/fullcalendar.print.css' rel='stylesheet' media='print'>
        <LINK REL="stylesheet" HREF="<?php echo $this->location; ?>css/layout.css" TYPE="text/css">
        <LINK REL="stylesheet" HREF="<?php echo $this->location; ?>css/forms.css" TYPE="text/css">
	<LINK REL="stylesheet" HREF="<?php echo $this->location; ?>css/tab.webfx.css" TYPE="text/css">	
	<LINK REL="stylesheet" HREF="<?php echo $this->location; ?>css/jquery-ui.css" TYPE="text/css">
	
	<script src="./javascript/jquery-1.9.1.js" type="text/javascript"  ></script>
	<script src='./javascript/jquery-ui.min.js' type="text/javascript"   ></script>
	<script src="./javascript/tabpane.js" type="text/javascript"   ></script>
	<script src="./javascript/CalendarPopup.js" type="text/javascript"   ></script>	
	<script src='./javascript/fullcalendar.min.js' type="text/javascript" ></script>

       	<?php
	if($this->js_extra=="scriptaculous"){ 
	/* This will be turned on for inline editing of CRON and CONTACT Info only */
        ?> 
        	<script src="./javascript/scriptaculous/lib/prototype.js" type="text/javascript"></script>
        	<script src="./javascript/scriptaculous/src/scriptaculous.js" type="text/javascript"></script>
        	<script src="./javascript/scriptaculous/src/unittest.js" type="text/javascript"></script>
        	<script src='./javascript/jquery-ui.js' type="text/javascript"   ></script>
	<?php 
	}
	 if( ($this->page == "dashboard") || ($this->page == "")){
		echo " <meta http-equiv='refresh' content='900'>";
	}
	?> 
	<SCRIPT type="text/javascript" > 
	var cal = new CalendarPopup();
	</SCRIPT>

        </head>
        <body  >
        <div id="pageintro">

       <?php
                 $this->SMALLHEADER();
       } # End of HEADER 


	function FOOTERS() {
        ?>

        </div> <!--outtershell -->
	</body></html>

	<?php

        } # End of footers



	function SMALLHEADER(){
        ?>
        <div id="header"><!-- Header --> </div>

        <div id="centreposition">
                <div id="header_logo"><!--White  bar with logo on top --></div>
                <div id="header_blue_sm"><!-- Blue full header bar --></div>
                <div id="header_blue_end_sm">&nbsp;&nbsp;&nbsp; <!-- Blue end piece for full header bar --></div>
        </div>

        <div id="nosqlcity"><!-- city target image removed --></div>

        <div id="header_grey_top"><!-- Grey Space --><div>

        <div id="header_navigation_sm"><!-- Blue full header navigation bar --><?php $this->header_navigation(); ?>  </div>

        <div id="under_navigation_sm"><!-- grey under navigation bar --></div>

        <div id="outershell">
        <?php
        }


	function header_navigation(){
     	echo '   
                        <div class="bluebutton1"><a href="'.$this->location.'?page=crons">CRONS</a></div>
			<div class="bluebutton1"><a href="'.$this->location.'?page=contacts">CONTACTS</a></div>
			<div class="bluebutton1"><a href="'.$this->location.'?page=schedule">SCHEDULE</a></div>
                        <div class="bluebutton1"><a href="'.$this->location.'?page=dashboard">DASHBOARD</a></div>
			<div class="bluebutton1"><a href="'.$this->location.'?page=history">HISTORY</a></div>
			<div class="bluebutton1"><a href="'.$this->location.'?page=database">DATABASE</a></div>
			<div class="bluebutton1"><a href="'.$this->location.'?page=docs">DOCS</a></div>
	';
        }


	



} # END OF CLASS
?>

