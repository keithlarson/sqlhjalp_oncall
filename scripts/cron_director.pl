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
# MODULES 
use Cwd;

#use Proc::PID_File;
# die "Already running!" if Proc::PID::File->running();
# my $child1 = Proc::PID::File->new(name => "lock.1");

# REQUIREMENTS 
my $dir = getcwd;
require "$dir/database_connection.pl" or die $!;


# DEFINE VARIABLES
	my $database_handle = db();
 

#Gather Cron Bots 
	my %crons_ar = ();
	my $sth_crons = $database_handle->prepare("SELECT c.cron_id , c.cron_type  , 

CASE 
WHEN h.date_recorded IS NULL THEN NOW() 
ELSE h.date_recorded 
END as last_ran ,

CASE 
WHEN t.min = '*' THEN 'PASS' 
WHEN date_format(NOW(),'%i') = t.min  THEN 'PASS' 
ELSE 'FAIL' 
END as min ,

CASE 
WHEN t.hour = '*' THEN 'PASS' 
WHEN date_format(NOW(),'%H') = t.hour THEN 'PASS' 
ELSE 'FAIL' 
END as hour ,

CASE 
WHEN t.day_of_month = '*' THEN 'PASS' 
WHEN date_format(NOW(),'%e') = t.day_of_month THEN 'PASS' 
ELSE 'FAIL' 
END as day_of_month ,

CASE 
WHEN t.month = '*' THEN 'PASS' 
WHEN date_format(NOW(),'%m') = t.month THEN 'PASS' 
ELSE 'FAIL' 
END as month,

CASE 
WHEN t.day_of_week = '*' THEN 'PASS' 
WHEN date_format(NOW(),'%w') = t.day_of_week THEN 'PASS' 
ELSE 'FAIL' 
END as day_of_week

FROM sqlmot_cron  c
INNER JOIN sqlmot_cron_times t ON t.cron_id = c.cron_id 
LEFT JOIN sqlmot_cron_history h ON h.cron_id = c.cron_id 

WHERE c.cron_type != 'OFF' AND min = 'PASS' AND hour = 'PASS' AND day_of_month = 'PASS' AND month = 'PASS' AND day_of_week = 'PASS' 
ORDER BY c.cron_type  ");
	$sth_crons->execute() or die "database error, sth_crons";
	while(my $crons = $sth_crons->fetchrow_hashref){	
		$crons_ar{$crons->{cron_id}} = $crons->{cron_type};
#  print " cron_id ".$crons->{cron_id}." cron_type ".$crons->{cron_type}." ".$crons->{min}." ".$crons->{hour}." ".$crons->{day_of_month}." ".$crons->{month}." ".$crons->{day_of_week}."  \n ";
	}
	$sth_crons->finish;

	my $i =1;
        foreach my $key (sort (keys(%crons_ar))) {

             	if($crons_ar{$key} eq "HTTP"){ 
 			exec("/usr/bin/perl ./cron_monitor_http.pl $key &> /tmp/cron_monitor_http_$key.log  ");
		} elsif($crons_ar{$key} eq "HTTPS"){ 
                        exec("/usr/bin/perl ./cron_monitor_https.pl $key &> /tmp/cron_monitor_https_$key.log  ");
		} elsif($crons_ar{$key} eq "FTP"){
                        exec("/usr/bin/perl ./cron_monitor_ftp.pl $key &> /tmp/cron_monitor_ftp_$key.log  ");
                } elsif($crons_ar{$key} eq "SSH"){
                        exec("/usr/bin/perl ./cron_monitor_ssh.pl $key &> /tmp/cron_monitor_ssh_$key.log  ");
                }elsif($crons_ar{$key} eq "SHELL"){
                        exec("/usr/bin/perl ./cron_monitor_shell.pl $key &> /tmp/cron_monitor_shell_$key.log  ");
                } elsif($crons_ar{$key} eq "MYSQL"){
                        exec("/usr/bin/perl ./cron_monitor_https.pl $key &> /tmp/cron_monitor_https_$key.log  ");
                }

      		print " CRON ID :".$key ." TYPE- ".$crons_ar{$key}."\n ";      
       
        }

# Disconnect the primary db 
$database_handle->disconnect;


system("$dir/scripts/cron_monitor.pl");


1;
#
