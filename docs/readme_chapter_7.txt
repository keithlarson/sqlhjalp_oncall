Chapter: 7
Page Number: 7.00
Title: PHP Overview
Content: 

The monitor dashboard and user interface is built with a couple of PHP classes, html files, CSS , Javascript and an index.php file. 

config_parse_class.php
graphs.php
index.php
sqlmot_class.php
sqlmot_pages_class.php

html_files/
contacts_details.html
contacts.html
cron_details.html
crons.html
dashboard_details.html
dashboard.html
database.html
documentation.html
history.html
schedule.html 

 Chapter: 7
Page Number: 7.01
Title: index.php
Content: 

The index.php handles all input from the site. 
This script engages the class files and handles POST information.. 




 Chapter: 7
Page Number: 7.03
Title: config_parse_class
Content: 

The config_parse_class.php parses the config.info file to set variables within the class files. 




 Chapter: 7
Page Number: 7.04
Title: sqlmot_class
Content: 

The sqlmot_class.php is the primary class file. This handles all the AJAX and API calls. 
The header and footer information as well as page case statement is within this. 
This file also contains the query_db function which organizes all database query interactions. 



 Chapter: 7
Page Number: 7.05
Title: sqlmot_pages_class
Content: 

The sqlmot_pages_class.php extends the sqlmot_class.php class for use within the HTML pages. 

MySQL queries can be found here that are related to the different specific html pages. 




 Chapter: 7
Page Number: 7.06
Title: graphs
Content: 

The graphs.php file uses the jpgraph  package from http://jpgraph.net. 
This package is downloaded at installation time and installed. 
Code and documentation is available via the http://jpgraph.net site. 
Their documentation is also available after download under your dashboard directory. 
Example - /dashboard/3rd_party_software/jpgraph/docs/



 
