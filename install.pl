#!/usr/bin/perl
##################################################################################
#                                                                                #
#  Copyright (c) 2013, SQLHJALP.com All rights reserved.                         #
#                                                                                #
#  This program is free software; you can redistribute it and/or modify          #
#  it under the terms of the GNU General Public License as published by          #
#  the Free Software Foundation; version 2 of the License.                       #
#                                                                                #
#  This program is distributed in the hope that it will be useful,               #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of                #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                 #
#  GNU General Public License for more details.                                  #
#                                                                                #
#  You should have received a copy of the GNU General Public License             #
#  along with this program; if not, write to the Free Software                   #
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA      #
#                                                                                #
#  Programmer    Keith Larson                                                    #
#  Description   CRON JOB DIRECTOR FOR THE SQLHJALP MONITOR			 #
#  https://github.com/keithlarson/sqlhjalp_oncall                                #
#                                                                                #
#                                                                                # 
##################################################################################
use Cwd;
use Sys::Hostname;
use Net::Address::IP::Local;

# Get the local system's IP address that is "en route" to "the internet" I use this for mysql permissions later. 
my $ipaddress= Net::Address::IP::Local->public;
my $leith="Y";
my $hostname = hostname;
my $masterhost;
my $dbname;
my $dir = getcwd;
# Clear Screen and get started. 
system("clear");

# INTRODUCTION 
print "
Code is available from https://github.com/SQLHJALP/sqlhjalp_oncall \n 
This is a LAMP stack monitoring application. Alterations for web servers other than APACHE on LINUX are up to you.\n
This application is designed for an Intranet. If you would like to place this on the public web I would recommend HTTP Password protection.\n
This system currently uses email and txt and voice for notifications. \n
For fast and easy txt and voice we use www.twilio.com \n
You can create a free account at www.twilio.com for testing purposes.\n
Overall rather cheap but pricing can be found here https://www.twilio.com/voice/pricing \n
Other options for voice notifications are currently up to others to add. \n
\n
The application does the following:\n
--Schedules on call rotations for users.\n
--Notifications via email\n
--Notifications via a phone call\n
        --So you do not sleep through another txt message overnight\n
--Notifications via a txt message\n
--Allows dynamic cron creation for dynamic monitoring options.\n
--Monitor MySQL connections\n
--Monitor MySQL performance\n
--Monitor HTTP results\n
--Monitor HTTP results\n
--Monitor results via SSH command\n
--Monitor results via MySQL query\n
--Monitor results from shell command\n

\n
What user account this monitor is executed as is up to you. ie: root \n
The install.pl script is designed to install the application and database schema by asking you a few questions.  \n 
Installation is handled by this prebuilt Perl script.\n
\n
YOU WILL NEED THE FOLLOWING IN ORDER TO INSTALL:\n
-- wget install so I can gather some files.
------ ie: yum -y install wget
-- Permission for CPAN Installations
-- Master Database access with the ability for \n
------ user creation\n 
------ database creation\n 
------ procedures creation\n 
------ events creation\n 
\n

What MySQL username and password that is used for this monitor to execute as is up to you. I suggest a new user and password.\n 
This installation will attempt to grant a user for the required database(s). If you need additional database permissions that is up to you.\n
\n
Do you want to continue? (Y|n): ";


my $start=<>;
chomp($start);
$start=uc($start);
if($start eq ""){ $start="Y";}


if($start eq "Y"){
system("clear");



print "Great, then let us getstarted with the CPAN MODULES..... \n";
print "You will need Permission to install CPAN modules. Do you have permission and can we install the required CPAN MODULES ? (Y|n): ";

my $cpan = <>;
chomp($cpan);
$cpan=uc($cpan);
if($cpan eq ""){ $cpan="Y";}


# PERL MODULES
if($cpan eq "Y"){
	system("clear");

	print "\n";
	print "Installing WWW::Twilio::TwiML\n \n ";
	`perl -MCPAN -e 'install WWW::Twilio::TwiML'`;

	print "Installing WWW::Twilio::API\n \n ";
	`perl -MCPAN -e 'install WWW::Twilio::API'`;

	print "Installing MIME::Base64\n \n ";
	`perl -MCPAN -e 'install MIME::Base64'`;

	print "Installing MIME::Entity \n \n ";
	`perl -MCPAN -e 'install MIME::Entity'`;

	print "Installing DBI\n \n ";
	`perl -MCPAN -e 'install DBI'`;

	print "Installing Net::SMTP::SSL \n \n ";
	`perl -MCPAN -e 'install Net::SMTP::SSL'`;

	print "Installing Net::SSH::Perl \n \n ";
	`perl -MCPAN -e 'install Net::SSH::Perl'`;

	print "Installing Net::FTP \n \n ";
	`perl -MCPAN -e 'install Net::FTP'`;

	print "Installing Net::SFTP \n \n ";
        `perl -MCPAN -e 'install Net::SFTP'`;	

	print "Installing HTML::Entities \n \n ";
	`perl -MCPAN -e 'install HTML::Entities'`;

	print "Installing HTML::LinkExtor \n \n ";
	`perl -MCPAN -e 'install HTML::LinkExtor'`;
	
	print "Installing LWP::Protocol::https \n \n ";
	`perl -MCPAN -e 'install LWP::Protocol::https'`;

	print "Installing URI::URL \n \n ";
	`perl -MCPAN -e 'install URI::URL'`;

	print "Installing URI::Encode \n\n";
	`perl -MCPAN e 'install URI::Encode'`;

}
 
system("clear"); 
# CREATE CONFIG FILE 
print "Now we must ask you some questions to help build your configuration file. \n
If you do not know any of the required information yet, you can edit the config.info file at a later date.\n 
Are you ready to create the config file ? (Y|n): ";

my $config = <>;
chomp($config);

if($config eq ""){ $config="Y";}

if(uc($config) eq "Y"){

	print "OK now we will proceed in building out the config file now. \n ";
	print "This database host for this application expects to be the 'master' database database \n";	
	print "This application will monitor the database as well as all related cron job requested.\n";
	print "If access to this database fails notifications to the ADMIN contact will be sent. \n \n";

	# Create the config file
	open(FILE,'+>','./config/config.info') or die $!;
	print FILE ("# THIS IS A FILE THAT IS PARSED BY ALL SCRIPTS OF THE SQLHJALP ON-CALL MONITOR \n");
	print FILE ("# https://github.com/SQLHJALP/sqlhjalp_oncall \n");

	print "What is the emergency Admil email Account? ";
        my $admin_email= <>;
        chomp($admin_email);
        print "\n";
        print FILE ("SQLMOT_ADMIN_EMAIL===$admin_email \n");

        print "What is the emergency Admil phone number (used as a last resort)? (ie:13035551234) ";
        my $admin_phone= <>;
        chomp($admin_phone);
        print "\n";
        print FILE ("SQLMOT_ADMIN_PHONE===$admin_phone \n");

	print "The preferred method of running this application is via a subdomain. ie: http://oncalldemo.sqlhjalp.com/ \n";
        print "What is the url path in which this will be dashboard will be located? (ie: /sqlhojalp_monitor/dashboard/ or / for a subdomain ) \n";
	print "The default is / for a subdomain. Your path: ";
        my $loc= <>;
        chomp($loc);
        print "\n";
	if($loc eq ""){ $loc="/";}
        print FILE ("SQLMOT_LOCATION_HTTP===$loc \n");


	print "The application uses a key to encrypt password \n";

	my @chars = ("A".."Z", "a".."z");
	my $default_key;
	$default_key.= $chars[rand @chars] for 1..16;

	print "What is the key that you would like to use? [".$default_key."] \n";
	my $key= <>;
        chomp($key);

	if($key eq ""){ 
		$key=$default_key;
	}
	my $key_Length = length($key);

	my $random_number;
	my $i=1;
	
	while( $i <= $key_Length  ){
		$random_number .= int(rand(9));
		$i=$i+1;
	}


        print FILE ("# THE FOLLOWING KEY IS USED TO ENCRYPT passwords. \n");
        print FILE ("# Note that the IV must match the chosen cipher's blocksize bytes in length \n");
        print FILE ("SQLMOT_KEY===$key\n");
        print FILE ("SQLMOT_IV===$random_number\n");
        print FILE ("# SMTP SERVER INFO BELOW \n");

        print "Enter your SMTP server? ";
        my $smtp_server= <>;
        chomp($smtp_server);
        print "\n";
        print FILE ("SMTP_SERVER===$smtp_server \n");

        print "Enter a SMTP Server USER NAME for outgoing email: ";
        my $smtp_user= <>;
        chomp($smtp_user);
        print "\n";
        print FILE ("SMTP_USER===$smtp_user \n");

        print "Enter a the $smtp_server $smtp_user PASSWORD:  ";
        my $smtp_pass= <>;
        chomp($smtp_pass);
        print "\n";
        print FILE ("SMTP_PASS===$smtp_pass \n");


	# Clean up any previous installation attempts
	`rm -f /tmp/mysql.sql; rm -f ./sql/cleanmysql.sql;  `;	
	# This file is for user creation
        open(MYSQLFILE,'+>', '/tmp/mysql.sql') or die $!;
	# This file is for uninstall
	open(MYSQLRM,'+>', './sql/cleanmysql.sql') or die $!;

	print "What is the master database hostname ? [$hostname]";
	$masterhost= <>;
	chomp($masterhost);
	if($masterhost eq "" ){ $masterhost=$hostname; } 
	print "\n"; 
	print FILE ("SQLMOT_HOST===".$masterhost." \n");
       
	my $default_dbname="sqlhjalp_monitor";
	print "What is the master database/schema name? [$default_dbname]";
        $dbname= <>;
        chomp($dbname);
        if($dbname eq "" ){ $dbname=$default_dbname; }
	print FILE ("SQLMOT_DB_DATABASE===$dbname \n");

	my $default_username;
	$default_username.= $chars[rand @chars] for 1..16;
	print "Enter a new username to be used for this application:[$default_username] "; 
	my $username= <>;
	chomp($username);
	if($username eq "" ){$username= $default_username;}

	print "\n";
	print FILE ("SQLMOT_DB_USER===$username \n");

	print "Enter a password for the $username account: ";
	my $password= <>;
	chomp($password);
	print "\n";
	while( $password eq "" ){
		print "Sorry need a password: ";
		$password= <>;
		chomp($password);
	}
	print FILE ("SQLMOT_DB_PASS===$password \n");

	print MYSQLRM 	("SET GLOBAL event_scheduler=OFF;\n");
	print MYSQLRM   ("DROP DATABASE IF EXISTS $dbname ; \n");
		if($username ne "root"){
			print MYSQLRM   ("DROP USER '$username'\@'$hostname' ;  \n");
			print MYSQLRM   ("DROP USER '$username'\@'$masterhost' ;  \n");
		}
	print MYSQLRM   ("DROP DATABASE IF EXISTS ps_helper ; \n ");
                
	print MYSQLFILE ("SET GLOBAL event_scheduler=ON;\n");
        print MYSQLFILE ("CREATE DATABASE IF NOT EXISTS $dbname DEFAULT CHARACTER SET latin1;\n");
	print MYSQLFILE ("CREATE DATABASE IF NOT EXISTS ps_helper DEFAULT CHARACTER SET utf8;\n");
	print MYSQLFILE ("GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER 
	ON `".$dbname."`.* TO '$username'\@'$hostname' IDENTIFIED BY '$password'; \n ");
	print MYSQLFILE ("GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT,TRIGGER 
	ON `ps_helper`.* TO '$username'\@'$hostname' IDENTIFIED BY '$password';  \n");

	print MYSQLFILE ("GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER 
	ON `".$dbname."`.* TO '$username'\@'$masterhost' IDENTIFIED BY '$password';  \n");

	print MYSQLFILE ("GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT,TRIGGER 
	ON `ps_helper`.* TO '$username'\@'$masterhost' IDENTIFIED BY '$password';  \n");

		if($hostname ne 'localhost' ){
			if($username ne "root"){
				print MYSQLRM   ("DROP USER '$username'\@'localhost' ;  \n");
			}
			print MYSQLFILE ("GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER 
	ON `".$dbname."`.* TO '$username'\@'localhost' IDENTIFIED BY '$password'; \n ");
			print MYSQLFILE ("GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER 
	ON `ps_helper`.* TO '$username'\@'localhost' IDENTIFIED BY '$password';  \n");

                }
		print MYSQLFILE ("FLUSH PRIVILEGES;");
                print MYSQLRM ("FLUSH PRIVILEGES;");
        close (MYSQLRM);
        close (MYSQLFILE);
	
       
	print "Mark Leith's DB Performance procedures information can be found here http://www.markleith.co.uk/ps_helper/ \n";
	print "Would you like to install and enable Mark Leith's DB Performance procedures? (Y|n) ";
        $leith= <>;
	chomp($leith);
	if($leith eq "" ){$leith="Y";}

        if(uc($leith) eq 'Y'){
		print FILE ("LEITH===1 \n");
	} else { 
		$leith="N"; 
		print FILE ("LEITH===0 \n");
	}  # leith check


	print "Do you have a www.twilio.com Account? (Y|n) ";
	my $twilio= <>;
	chomp($twilio);
	if($twilio eq "" ){$twilio="Y";}
	print "\n";
	print FILE ("# #www.twilio.com Account info below \n");

	if(uc($twilio) eq 'Y'){

		print "Enter your www.twilio.com ACCOUNTSID: ";
		my $twilio_id= <>;
		chomp($twilio_id);
		print "\n";
		print FILE ("ACCOUNTSID===$twilio_id \n");

		print "Enter your www.twilio.com TOKEN: ";
		my $twilio_token= <>;
		chomp($twilio_token);
		print "\n";
 		print FILE ("AUTHTOKEN===$twilio_token \n");

		print "Enter your www.twilio.com PHONE NUMBER: (ie:13035551234) ";
		my $twilio_phone= <>;
		chomp($twilio_phone);
		print "\n";
		print FILE ("PHONE===$twilio_phone \n");

	} else {

		print FILE ("ACCOUNTSID===\n");
		print FILE ("AUTHTOKEN===\n");
		print FILE ("PHONE===\n");

	}


}# End of config file
 close (FILE);



 
system("clear");
# JAVASCRIPT MODULE
print "The following javascript packages are required for this application. \n
By allowing me to download for you, you agree to the license provided per package.\n
Feel free to review before continuing otherwise links to all packages are in the documentation\n
http://www.mattkruse.com/javascript/calendarpopup/combined-compact/CalendarPopup.js \n
http://arshaw.com/fullcalendar/downloads/fullcalendar-1.6.0.zip\n
http://anotherraid.googlecode.com/svn-history/r190/trunk/ar/tools/inplaceselect.js \n
http://code.jquery.com/jquery-1.9.1.js\n
http://builder.jquerytools.org/v1.2.7/jquery.tools.min.js \n
http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js \n
http://script.aculo.us/dist/scriptaculous-js-1.9.0.zip \n
http://reig-email-image-generator.googlecode.com/svn-history/r2/trunk/js/jquery.selectchain.js \n
http://webfx.eae.net/download/tabpane102.zip \n
http://jpgraph.net/download/download.php?p=5 \n
\n
Can I download, install and symlink .js & .css files for you? (Y|n) ";
my $js= <>;
chomp($js);
print "\n";
if($js eq "" ){$js="Y";}

if(uc($js) eq 'Y'){
	system("clear");

	my $location="dashboard/javascript";
	print "Downloading and unpacking the javascript files. \n";

	system("wget http://code.jquery.com/jquery-1.9.1.min.js --output-document=$location/jquery-1.9.1.min.js " );
	system("wget http://code.jquery.com/ui/1.10.2/jquery-ui.min.js --output-document=$location/jquery-ui.min.js");
	system("wget http://code.jquery.com/ui/1.10.2/jquery-ui.js --output-document=$location/jquery-ui.js");
	system("wget http://webfx.eae.net/download/tabpane102.zip --output-document=$location/tabpane102.zip ");
        system("cd $location/; unzip tabpane102.zip;  ln -s ./tabpane/js/tabpane.js tabpane.js;");
	system("wget http://www.mattkruse.com/javascript/calendarpopup/combined-compact/CalendarPopup.js --output-document=$location/CalendarPopup.js");
	system("wget http://arshaw.com/fullcalendar/downloads/fullcalendar-1.6.0.zip --output-document=$location/fullcalendar-1.6.0.zip");
        system("cd $location/; unzip fullcalendar-1.6.0.zip; ln -s ./fullcalendar-1.6.0/fullcalendar/fullcalendar.js fullcalendar.js; ln -s ./fullcalendar-1.6.0/fullcalendar/fullcalendar.min.js fullcalendar.min.js; ");
	system("wget http://script.aculo.us/dist/scriptaculous-js-1.9.0.zip  --output-document=$location/scriptaculous-js-1.9.0.zip");
        system("cd $location/; unzip scriptaculous-js-1.9.0.zip; ln -s scriptaculous-js-1.9.0 scriptaculous; ");

        
	system("wget http://code.jquery.com/jquery-1.9.1.js --output-document=$location/jquery-1.9.1.js");
        system("wget http://code.jquery.com/jquery-1.9.1.js --output-document=$location/jquery.js");
        system("wget http://builder.jquerytools.org/v1.2.7/jquery.tools.min.js  --output-document=$location/jquery.tools.min.js ");
        system("wget http://anotherraid.googlecode.com/svn-history/r190/trunk/ar/tools/inplaceselect.js --output-document=$location/inplaceselect.js ");
        system("wget http://reig-email-image-generator.googlecode.com/svn-history/r2/trunk/js/jquery.selectchain.js --output-document=$location/selectchain.js ");

	system("wget http://jpgraph.net/download/download.php?p=5 --output-document=dashboard/3rd_party_software/jpgraph-3.5.0b1.tar.gz");
	system("cd dashboard/3rd_party_software/; tar -vxzf jpgraph-3.5.0b1.tar.gz; ln -s jpgraph-3.5.0b1 jpgraph; ");

	system("wget http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css --output-document=./css/jquery-ui.css");
	system("cd dashboard/css; ln -s ../javascript/fullcalendar-1.6.0/fullcalendar/fullcalendar.css fullcalendar.css");
	system("cd dashboard/css; ln -s ../javascript/fullcalendar-1.6.0/fullcalendar/fullcalendar.print.css fullcalendar.print.css");
	system("cd dashboard/css; ln -s ../javascript/fullcalendar-1.6.0/demos/cupertino/theme.css cupertino_theme.css");
	system("cd dashboard/css; ln -s ../javascript/tabpane/css/tab.webfx.css tab.webfx.css");
	
}









system("clear");
# DATABASE MODULE
print "Can I create the database users and $dbname schema on $masterhost now? (Y|n) ";
 my $db_process= <>;
 chomp($db_process);
 if($db_process eq "" ){$db_process="Y";}
 if(uc($db_process) eq 'Y'){
	print "Are you using MySQL 5.6 ? (Y|n)  ";
        my $version= <>;
        chomp($version);
	if($version eq "" ){$version="Y";}


	print "Enter a current mysql account username, we will use it for this install only? ";
	my $a_username= <>;
	chomp($a_username);
	print "\n";

	print "Would you like to load demo data? (Y|n) ";
        my $demo= <>;
        chomp($demo);
        print "\n";
	if($demo eq "" ){$demo="Y";}
	my $val=4; 

	if(uc($db_process) eq 'Y'){
		$val=$val+1;	
	}

	if(uc($leith) eq 'Y'){
		$val=$val+1;
	print "Downloading the sql and building the ps_helper database .....\n";
        if(uc($version) eq 'Y'){
                system("wget http://www.markleith.co.uk/wp-content/uploads/2012/07/ps_helper_56.sql_.txt --output-document=/tmp/ps_helper.sql");
        } else{         
                system("wget http://www.markleith.co.uk/wp-content/uploads/2012/07/ps_helper_55.sql_.txt --output-document=/tmp/ps_helper.sql");
        }

	} # leith check
	print " Creating db accounts and adding the $dbname schema \n ";
        print "You will be prompted $val times for the $a_username password by the MySQL client. \n \n";

	print "ie: mysql --host=$masterhost --user=$a_username  -p < /tmp/mysql.sql \n";
	system("mysql --host=$masterhost --user=$a_username  -p < /tmp/mysql.sql");

	print "ie: mysql --host=$masterhost --user=$a_username  -p $dbname < ./sql/sqlhjalp_monitor.sql \n";
	system("mysql --host=$masterhost --user=$a_username  -p $dbname < ./sql/sqlhjalp_monitor.sql");

	print "mysql --host=$masterhost --user=$a_username  -p $dbname < ./sql/sqlhjalp_monitor.data.sql \n";
	system("mysql --host=$masterhost --user=$a_username  -p $dbname < ./sql/sqlhjalp_monitor.data.sql");
	if(uc($leith) eq 'Y'){

	print "mysql --host=$masterhost --user=$a_username  -p $dbname < /tmp/ps_helper.sql \n";
	system("mysql --host=$masterhost --user=$a_username  -p $dbname < /tmp/ps_helper.sql");
	}
	if(uc($db_process) eq 'Y'){     
		print "mysql --host=$masterhost --user=$a_username  -p  $dbname < ./sql/demo_data.sql \n";
       		system("mysql --host=$masterhost --user=$a_username  -p  $dbname < ./sql/demo_data.sql"); 
        }
     
    
   


 }



 
system("clear");
# CRONTAB MODULE
print "Can I create or add to you current cron file? (Y|n) ";
my $crontab= <>;
chomp($crontab);
if($crontab eq "" ){$crontab="Y";}
$crontab=uc($crontab);
if($crontab eq 'Y'){ 


	system("crontab -l > /tmp/crontab.file ; ");
	system("echo '* * * * * $dir/scripts/cron_director.pl > /dev/null 2>&1' >> /tmp/crontab.file;");
	system("crontab /tmp/crontab.file");

}


system("clear");
print "\n\nBased on the input given during this session the below is possible http conf file \n\n";

print "
#The Public XML ACCESS point for Twilo \n
<VirtualHost *:80>
     ServerAdmin $admin_email
     DocumentRoot $dir/dashboard/twilio_public_page/ 
     ServerName $hostname 
     ServerAlias www.$hostname 
     ErrorLog logs/sqlhjalp_oncall-error_log 
     CustomLog logs/sqlhjalp_oncall-access_log common
 </VirtualHost>

#The Secure location
<VirtualHost $ipaddress:443>
DocumentRoot $dir/dashboard/
ServerName oncall.$hostname

# Use separate log files: 
ErrorLog logs/sqlhjalp_oncall_ssl_error_log 
TransferLog logs/sqlhjalp_oncall_ssl_access_log
SSLEngine on 
SSLProtocol all -SSLv2 
SSLCipherSuite ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM:+LOW
SSLCertificateFile /etc/pki/tls/certs/localhost.crt 
SSLCertificateKeyFile /etc/pki/tls/private/localhost.key
#SSLCertificateChainFile /etc/pki/tls/certs/server-chain.crt 
#SSLCACertificateFile /etc/pki/tls/certs/ca-bundle.crt 
#SSLVerifyClient require 
#SSLVerifyDepth  10 

<Files ~ \"\.(cgi|shtml|phtml|php3?)$\">
    SSLOptions +StdEnvVars 
</Files> 

<Directory \"$dir/dashboard/\"> 
   AllowOverride All 
</Directory> 

</VirtualHost>";





} else {
	print " Sorry to see you go. Maybe we work again in the future. \n ";
}



system("rm -f /tmp/mysql.sql");
system("rm -f /tmp/create_leith.sql");
system("rm -f /tmp/ps_helper.sql");
system("rm -f /tmp/crontab.file");

1;
