Chapter: 6
Page Number: 6.00
Title: Perl Scripts Overview
Content: 

The Perl scripts used by the SQLHJALP Monitor 

The Perl scripts include:

cron_director.pl
cron_monitor_ftp.pl
cron_monitor_http.pl
cron_monitor_https.pl
cron_monitor_mysql.pl
cron_monitor.pl
cron_monitor_shell.pl
cron_monitor_ssh.pl
crons_sql.pm
database_connection.pl
db_cron_error.pm
db_cron_update.pm
smtp_email.pm
twilio.pm



 Chapter: 6
Page Number: 6.01
Title: Cron Director 
Content: The Cron Director (cron_director.pl) file is executed via the system crontab. 

This script will review all of the active monitor application cron jobs. 
The script will then execute the related protocol script to evaluate for Pass or Failure based on job settings. 

The script will also then execute the cron_monitor.pl for notifications. 





 Chapter: 6
Page Number: 6.02
Title: Cron Monitor
Content: 
The Cron Monitor (cron_monitor.pl) evaluates the latest failed status within the given dynamic time ranges. 

If it finds that notifications are in order it will use the smtp_email.pm and twilio.pm for notifications. 

This script uses the Net::SMTP::SSL and WWW::Twilio::API



 Chapter: 6
Page Number: 6.03
Title: Cron FTP Checks 
Content: 

The cron_monitor_ftp.pl file will check ftp status of a given site. 
You can set additional settings via the following variables via the Command||Execute||SQL field:

PORT===21
PASSIVE===1
CWD===/home/foobar
DEBUG===1

This script uses the Net::FTP module



 Chapter: 6
Page Number: 6.04
Title: Cron HTTP Checks
Content: 
The cron_monitor_http.pl script takes given domain or ip address information to validate if the site is active. 

The entire URL string can be placed in either of those fields. 

Do not place http:// that is added. 

This script uses the LWP::UserAgent , LWP::RobotUA , HTML::LinkExtor and URI::URL modules. 




 Chapter: 6
Page Number: 6.05
Title: Cron HTTPS Checks
Content: 
The cron_monitor_https.pl script checks a url much like the cron_monitor_http.pl

Do not place https:// that is added. 

If a username and password is given the site will add this into the url. 

This script uses the LWP::Protocol::https , LWP::UserAgent , LWP::RobotUA , HTML::LinkExtor and URI::URL modules. 



 Chapter: 6
Page Number: 6.07
Title: Cron MySQL Checks 
Content: 

The cron_monitor_mysql.pl script is dependent on the additional options allowed via the Command||Execute||SQL field:

You can set override the PORT if needed
PORT===3306

Otherwise the database and query used is set via these options

DATABASE===test 
QUERY===SELECT 1

The host is set by the domain or ip fields. 

This script uses the DBI:mysql module.



 Chapter: 6
Page Number: 6.08
Title: Cron SSH Checks 
Content: 

The cron_monitor_ssh.pl will execute whatever command is given via the Command||Execute||SQL with the COMMAND variable on the given host.

Example COMMAND===/tmp/test.sh 

The username and password are required for this script unless ssh keys are already enabled. 

Override options allowed via the Command||Execute||SQL field:
DEBUG===1
PORT===

This script uses the Net::SSH::Perl Modules



 Chapter: 6
Page Number: 6.09
Title: Cron Shell Checks
Content: 

The cron_monitor_shell.pl will execute what ever command is in the  Command||Execute||SQL field on the localhost. 

This script uses the  Cwd module.



 Chapter: 6
Page Number: 6.10
Title: Crons SQL
Content: 

The crons_sql.pm is a subroutine query that is used across all or most of these perl scripts to gather cron jobs. 

MIME::Base64 is used for password decryption. 


 Chapter: 6
Page Number: 6.11
Title: DB Cron Update 
Content: 

The db_cron_update.pm is a subroutine that is used by many of the scripts and updates cron status in the sqlmot_cron_history and sqlmot_dashboard tables. 



 Chapter: 6
Page Number: 6.12
Title: DB Cron Error
Content: 

The db_cron_error.pm is a subroutine that is used by many of the scripts and updates cron status in the sqlmot_cron_failed_response , sqlmot_cron_history and sqlmot_dashboard tables.  



 Chapter: 6
Page Number: 6.13
Title: SMTP Email
Content: 

The smtp_email.pm is a subroutine that uses Net::SMTP::SSL to process mail notifications. 




 Chapter: 6
Page Number: 6.14
Title: Twilo
Content: 


The twilio.pm is a subroutine that uses the WWW::Twilio::API for notifications started via the cron_monitor.pl script. 





 Chapter: 6
Page Number: 6.15
Title: Database Connection
Content: 

The database_connection.pl script uses the DBI module for the MySQL Connections. 

All Database information ( HOST, USERNAME , PASSWORD ) is parsed from the config.info file.  



 
