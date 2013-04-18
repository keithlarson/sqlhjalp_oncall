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


class events extends sqlmot{

	private $debug;
        public function __construct(){

		$this->debug=0;
                $this->db_host=$_SESSION['parse']["SQLMOT_DB_HOST"];
                $this->db_user=$_SESSION['parse']["SQLMOT_DB_USER"];
                $this->db_pass=$_SESSION['parse']["SQLMOT_DB_PASS"];
                $this->db_database=$_SESSION['parse']["SQLMOT_DB_DATABASE"];
                $this->leith_on=$_SESSION['parse']["LEITH"];                
		$this->db_key=$_SESSION['parse']["SQLMOT_KEY"];
                $this->db_iv=$_SESSION['parse']["SQLMOT_IV"];
        }


	  function add_event($records){

		$start=$records['StartDate'];
		$end=$records['EndDate'];
 		$id=$records['EventName']; 
 		if(isset($records['primary'])){
 			$primary=$records['primary'];	
 		} else { 
			$primary=0;
		}


		$query="SELECT CONCAT(c.first_name,' ',last_name) as event_name FROM contact  c WHERE c.contact_id = $id  ";		
		       if($this->debug == 1 ) {error_log("QUERY --> $query  " , 0); }
		$v=$this->query_db($query,1);
		$value=$v[0];

		$query=" REPLACE INTO events SELECT NULL, CONCAT(c.first_name,' ',last_name) as event_name , c.contact_id, '".$start."', '".$end."' , $primary FROM contact  c WHERE c.contact_id = $id  "; 
			if($this->debug == 1 ) {error_log("QUERY --> $query  " , 0); }	
   		return $this->query_db($query,6,$value);

  	}	



	function resize_event($records){ 
	$id=$records['ID'];
	$delta=$records['dayDelta'];
	
	$query="UPDATE events e  INNER JOIN events c ON e.events_id = c.events_id SET e.end_date = c.end_date + INTERVAL $delta DAY WHERE c.events_id = $id ";
		if($this->debug == 1 ) {error_log("QUERY --> $query  " , 0); }	
  	$this->query_db($query,2);

	}


	function eventDrop($records){
        $id=$records['ID'];
        $delta=$records['dayDelta'];

	$query="UPDATE events e  INNER JOIN events c ON e.events_id = c.events_id SET e.start_date = c.start_date + INTERVAL $delta DAY WHERE c.events_id = $id ";
       		if($this->debug == 1 ) {error_log("QUERY --> $query  " , 0); } 
        $this->query_db($query,2);


        $query="UPDATE events e  INNER JOIN events c ON e.events_id = c.events_id SET e.end_date = c.end_date + INTERVAL $delta DAY WHERE c.events_id = $id ";
       		if($this->debug == 1 ) {error_log("QUERY --> $query  " , 0); } 
        $this->query_db($query,2);

        }


	function update_contact($records){
        $id=$records['ID'];
	$new_contact=$records['new_contact'];
	$current_contact=$records['current_contact'];
	if(isset($records['primary'])){
                        $primary=$records['primary'];
                } else {
                        $primary=0;
                }

	$query="SELECT CONCAT(c.first_name,' ',last_name) as event_name FROM contact  c WHERE c.contact_id = $new_contact  ";
               	if($this->debug == 1 ) {error_log("QUERY --> $query  " , 0); } 
                $v=$this->query_db($query,1);
                $value=$v[0];

        $query="UPDATE events SET contact_id = $new_contact WHERE events_id = $id ";
        error_log("QUERY --> $query  " , 0);
        $this->query_db($query,6,$value);

        }


	function delete_event($records){
        $id=$records['ID'];
       
        $query="DELETE FROM events WHERE events_id = $id";
       		if($this->debug == 1 ) {error_log("QUERY --> $query  " , 0); } 
         $this->query_db($query,2);

        }

}
