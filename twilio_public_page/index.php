<?php
if($_REQUEST['email']==1){}else{
header('Content-type: text/xml');
echo '<?xml version="1.0" encoding="UTF-8"?>';
}
echo '<Response>';
$digits = $_REQUEST['Digits'];
$cni=$_REQUEST['cni'];
$E = explode("___",$cni);
$Vars=array();
foreach($E as $e ){
	$ee = explode("---",$e);
	$Vars[$ee[0]]=$ee[1];
}


if (strlen($digits) == 1){
require("../dashboard/sqlmot_class.php");
require("../dashboard/sqlmot_voice_class.php");
$v= new voice();
$result=$v->update_notification_status($Vars,$digits);


if ($result){
	echo '<Say>'.$result['say'].'.</Say>';
}else {
	echo "<Say>Sorry, I couldn't find the required information. </Say>";
}

}else {
	echo "<Say>Sorry, that isn't valid information.</Say>";
}
echo '</Response>';
?>
