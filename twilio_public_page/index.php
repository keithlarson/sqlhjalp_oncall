<?php
header('Content-type: text/xml');
echo '<?xml version="1.0" encoding="UTF-8"?>';
echo '<Response>';
$digits = $_REQUEST['Digits'];
$cni=$_REQUEST['cni'];

$E = explode("000000",$cni);
$Vars=array();
foreach($E as $e ){
	$ee = explode("000",$e);
	$Vars[$ee[0]]=$ee[1];
}
#$contact_id=$Vars['CTID'];
#$cron_id=$Vars['CI'];
#$cron_failed_response_id=$Vars['CFRI'];

if (strlen($digits) == 1){
require("../dashboard/sqlmot_class.php");
require("../dashboard/sqlmot_voice_class.php");
$v= new voice();
$result=$v->update_notification_status($Vars,$digits);

if ($result){
	echo '<Say>'.$result['say'].'.</Say>';
}else {
	echo "<Say>Sorry, I couldn't find the required information.</Say>";
}

}else {
	echo "<Say>Sorry, that isn't valid information.</Say>";
}
echo '</Response>';
?>
