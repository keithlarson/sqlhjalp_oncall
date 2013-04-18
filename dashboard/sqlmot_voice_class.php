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

class voice extends sqlmot{


        public function __construct(){

                $this->db_host=$_SESSION['parse']["SQLMOT_DB_HOST"];
                $this->db_user=$_SESSION['parse']["SQLMOT_DB_USER"];
                $this->db_pass=$_SESSION['parse']["SQLMOT_DB_PASS"];
                $this->db_database=$_SESSION['parse']["SQLMOT_DB_DATABASE"];

        }

	function acknowledge($cfri){
	$query="UPDATE cron_failed_response SET acknowledge=1 WHERE cron_failed_response_id=$cfri";
	$this->query_db($query,2);
	}       



	function update_notification_status($Vars,$digits){ #,$cron_id,$contact_id ){
	$contact_id=$Vars['CTID'];
	$cron_id=$Vars['CI'];
	$cron_failed_response_id=$Vars['CFRI'];

	$results=array();
	$query="SELECT 1 as valid FROM cron_notifications WHERE cron_failed_response_id=$cron_failed_response_id LIMIT 1";
	$results_ar=$this->query_db($query);
	if($results_ar[0]){
        	$query="UPDATE cron_notifications SET status_id=$digits WHERE cron_failed_response_id=$cron_failed_response_id AND contact_id=$contact_id AND cron_id=$cron_id ";
        	$results_ar=$this->query_db($query,2);
		if( $digits ==1){
       			$results['say']="Thank you for taking care of this alert"; 
			$this->acknowledge($cron_failed_response_id);
		} elseif( $digits ==2){
                        $results['say']="Thank you I will try someone else if available ";
		} else {
			 $results['say']="Thank you but that is an unknown status  ";
		}
	} else {
		$results['say']="Hello I am unable to update the status of this notification as it appears to be an invalid notification id ";		
	
	}
	return $results;
        }

} # End of class
