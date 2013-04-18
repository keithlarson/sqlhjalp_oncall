<?php
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
# Description   INDEX FILE FOR THE SQLHJALP Monitor                             #
# https://github.com/keithlarson/sqlhjalp_oncall                                #
#                                                                               #
#################################################################################
#DEFINE ("PARSE_PATH", "../../config/config.info")

foreach($_GET as $name => $value){  error_log("DEBUG LOOP --> $name = $value  " , 0);  }

if (!session_id()){
	session_start();      
	setcookie("PHPSESSID",session_id());
}
require("./sqlmot_class.php");
require("./sqlmot_events_class.php");
$events= new events();
$records=array();

if($_GET['EventName']>0){

	foreach($_GET as $name => $value){
	$records[$name]=$value; 
	// 	error_log("INSIDE LOOP --> $name = $value  " , 0);  
	}
	echo   $events->add_event($records);
}elseif($_GET['eventDrop'] ==1){

	foreach($_GET as $name => $value){
        $records[$name]=$value;
	error_log("eventDrop  LOOP --> $name = $value  " , 0);  
	}
	$events->eventDrop($records);

}elseif($_GET['dayDelta'] !=0){


	foreach($_GET as $name => $value){
        $records[$name]=$value;
	}
	$events->resize_event($records);

}elseif($_GET['update_contact'] ==1){


        foreach($_GET as $name => $value){
        $records[$name]=$value;
        }
        echo $events->update_contact($records);

}elseif($_GET['delete'] ==1){


        foreach($_GET as $name => $value){
        $records[$name]=$value;
        }
        $events->delete_event($records);



} else {


//header('Content-type:application/json; charset=utf-8');

$_GET['page']="API";
$events->page="API";
$events->jquery="get_events";
$events->current_page();

}
?>
