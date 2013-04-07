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
#  https://code.launchpad.net/~klarson/+junk/sqlhjalp_monitor			 #
#                                                                                #
#                                                                                # 
##################################################################################

# Clear Screen and get started. 
system("clear");


# INTRODUCTION 
print "Welcome to the UNINSTALL SQLHAJLP.com Monitor script\n
Code is available at https://code.launchpad.net/~klarson/+junk/sqlhjalp_monitor \n 
This will remove the previous installation. \n
Do you want to continue? (Y|N): ";

my $start = <>;
chomp($start);
$start=uc($start);
if($start eq "Y"){
system("clear");

	my $leith;
	print "Would you like to uninstall Mark Leith's DB Performance procedures? (Y|N) ";
	$leith= <>;
	chomp($leith);
	print "\n";

	if(uc($leith) eq 'Y'){
		print "What database host did we install Mark Leith's DB Performance procedures onto? (ie: master database) ";
		my $leith_host= <>;
		chomp($leith_host);
		print "\n";

		print "What MySQL username, can we use to remove Mark Leith's DB Performance procedures? ";
		my $leith_username= <>;
		chomp($leith_username);
		print "\n";

	print "  Removing db accounts and schema \n ";
        print "You will be prompted for the $leith_username password \n";
        system("mysql --host=$leith_host --user=$leith_username  -p < ./sql/clean_leith.sql");

	} # End if Leith Removal  

	system("clear");
	print "Enter a current mysql account username, we will use it for the uninstall only? ";
	my $a_username= <>;
	chomp($a_username);
	print "\n";


	if($host eq ''){

		print "What database host did we use? ";
		$host= <>;
		chomp($host);
		print "\n";

 	}


	print "  Removing db accounts and add schema \n ";
        print "You will be prompted for the $a_username password \n";
	system("mysql --host=$host --user=$a_username  -p < ./sql/cleanmysql.sql");
	system(" rm -Rf ./config/con*.info ");
	system(" rm -Rf ./dashboard/javascript/* ");
	system(" rm -Rf ./dashboard/3rd_party_software/* ");
	system(" rm -Rf ./dashboard/css/fullcalendar.css");
	system(" rm -Rf ./dashboard/css/fullcalendar.print.css");
	system(" rm -Rf ./dashboard/css/cupertino_theme.css");
	system(" rm -Rf ./dashboard/css/tab.webfx.css");
	system(" rm -Rf ./sql/clean_leith.sql ");
	system(" rm -Rf ./sql/mysqlclean.sql ");
	system("crontab -e ");

} else {
	print " Sorry to see you go. Maybe we work again in the future. \n ";
}



1;
