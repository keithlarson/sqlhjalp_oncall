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

# Clear Screen and get started. 
system("clear");


# INTRODUCTION 
print "Welcome to the UNINSTALL SQLHAJLP.com Monitor script\n
Code is available at https://github.com/keithlarson/sqlhjalp_oncall \n 
This will remove the previous installation. \n
This will also open CRONTAB in VI for you to remove previous cron
Do you want to continue? (y|N): ";

my $start = <>;
chomp($start);
$start=uc($start);
if($start eq ""){ $start="N";}
if($start eq "Y"){
system("clear");

	print "What is the master database hostname? ";
        $host= <>;
        chomp($host);
        print "\n";


	print "Enter a current mysql account username, we will use it for the uninstall only? ";
	my $a_username= <>;
	chomp($a_username);
	print "\n";


	print "Removing all database accounts and schemas previously created \n ";
        print "You will be prompted for the $a_username password \n";
	print "mysql --host=$host --user=$a_username  -p < ./sql/cleanmysql.sql \n";
	system("mysql --host=$host --user=$a_username  -p < ./sql/cleanmysql.sql");
	print "Removing previous configuration file \n";
	system(" rm -Rf ./config/con*.info ");
	print "Removing previous javascript and css downloads \n";
	system(" rm -Rf ./dashboard/javascript/* ");
	system(" rm -Rf ./dashboard/3rd_party_software/* ");
	system(" rm -Rf ./dashboard/css/fullcalendar.css");
	system(" rm -Rf ./dashboard/css/fullcalendar.print.css");
	system(" rm -Rf ./dashboard/css/cupertino_theme.css");
	system(" rm -Rf ./dashboard/css/tab.webfx.css");
	
 	system(" rm -Rf ./sql/cleanmysql.sql ");
 	system("crontab -e ");

} else {
	print " Sorry to see you go. Maybe we work again in the future. \n ";
}



1;
