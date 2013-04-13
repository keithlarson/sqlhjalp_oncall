<?php
date_default_timezone_set('UTC');
require_once ('3rd_party_software/jpgraph/src/jpgraph.php') ;
require_once ('3rd_party_software/jpgraph/src/jpgraph_line.php'); 
/*
 PASS DATA VIA THE GET
*/
// Some data
$ydata = explode('|', $_GET['ydata']);
  # array(15,11,3,8,12,5,1,9,13,5,7);

if($_GET['ydata2']){
$ydata2 = explode('|', $_GET['ydata2']);
}
$timer = new JpgTimer();
$timer->Push();

 
// Size of the overall graph
if($_GET['width']){ $width=$_GET['width'];  } else {  $width=350; }
if($_GET['height']){ $height=$_GET['height'];  } else {  $height=250; }

 
// Create the graph and set a scale.
// These two calls are always required
$graph = new Graph($width,$height);
$graph->SetScale('intlin');
 
// Setup margin and titles
$graph->SetMargin(70,20,20,60);
$graph->title->Set($_GET['title']);
$graph->subtitle->Set($_GET['sub_title']);
$graph->xaxis->title->Set($_GET['x_axis']);
if($_GET['HOURS']){
$hours = explode('|', $_GET['HOURS']);
$graph->xaxis->SetTickLabels($hours);
}
$graph->yaxis->title->Set($_GET['y_axis']);


$graph->footer->right->Set('Timer (ms): ');
$graph->footer->SetTimer($timer);

# $graph->legend->SetPos(0.5,0.98,'center','bottom');
 
// Create the linear plot
$lineplot=new LinePlot($ydata);
$lineplot->SetColor("blue");
$lineplot->SetWeight(2);
if($_GET['linetitle1']){ 
	$lineplot->SetLegend($_GET['linetitle1'] );
}
$graph->Add($lineplot);


if($_GET['ydata2']){
$lineplot2=new LinePlot($ydata2);
$lineplot2->SetColor("orange");
$lineplot2->SetWeight(2);
if($_GET['linetitle2']){  
        $lineplot2->SetLegend($_GET['linetitle2'] );
}
$graph->Add($lineplot2);
}

$graph->title->SetFont(FF_FONT1,FS_BOLD);
$graph->yaxis->title->SetFont(FF_FONT1,FS_BOLD);
$graph->xaxis->title->SetFont(FF_FONT1,FS_BOLD);
# $graph->yaxis->SetColor("red");
$graph->yaxis->SetWeight(2);


$graph->SetShadow();
 
// Display the graph
$graph->Stroke();

?>
