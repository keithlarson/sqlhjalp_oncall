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


 if (!session_id()){
	session_start();      
	setcookie("PHPSESSID",session_id());
 }


require("sqlmot_class.php");
$sqlmot= new sqlmot();

if( isset($_SESSION['kv']) ){
#   	echo "  KV: ".$_SESSION['kv']."<hr>";
}else{
 	foreach($_POST as $p){ unset($p); }
 	foreach($_GET as $g){ unset($g); }	
 	foreach($_REQUEST as $r){ unset($r); }
        $kv =$sqlmot->key_value();
	$_SESSION['kv']=$kv[0];
} 


if($_POST){

switch($_POST['posted']) {
	case "cronnew";
		unset($_SESSION['lastnewcronid']);
		$_SESSION['lastnewcronid']=$sqlmot->add_new_cron($_POST['newcron']);
	break;
	case "newcontact";
                unset($_SESSION['lastnewcontactid']);
                $_SESSION['lastnewcontactid']=$sqlmot->add_new_contact($_POST['newcontactemail']);
        break;
	case "newevent";

                unset($_SESSION['lastneweventid']);
		$record=array();	
		$record['id']=$_POST['newuser'];
		$record['start_date']=$_POST['start_date'];
		$record['end_date']=$_POST['end_date'];
		$record['primary']=$_POST['primary'];
                $_SESSION['lastneweventid']=$sqlmot->add_new_event($record);
        break;
} 
	# var_dump($_POST);
}



if( ($_GET[page]!="API") && ($_GET[page]!="AJAX")  ){
	$sqlmot->HEADERS();
}
if($_GET[jquery]){$sqlmot->jquery=$_GET[jquery] ;}

$sqlmot->current_page();


if( ($_GET[page]!="API") && ($_GET[page]!="AJAX")  ){
	$sqlmot->FOOTERS();
}



?>
