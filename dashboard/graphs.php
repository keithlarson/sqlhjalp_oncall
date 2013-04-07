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
 
// Size of the overall graph
$width=350;
$height=250;
 
// Create the graph and set a scale.
// These two calls are always required
$graph = new Graph($width,$height);
$graph->SetScale('intlin');
 
// Setup margin and titles
$graph->SetMargin(38,20,20,40);
$graph->title->Set($_GET['title']);
$graph->subtitle->Set($_GET['sub_title']);
$graph->xaxis->title->Set($_GET['x_axis']);
$graph->yaxis->title->Set($_GET['y_axis']);
 
 
// Create the linear plot
$lineplot=new LinePlot($ydata);
 
// Add the plot to the graph
$graph->Add($lineplot);
 
// Display the graph
$graph->Stroke();

?>
