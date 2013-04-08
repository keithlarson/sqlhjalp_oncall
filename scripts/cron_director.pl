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
# MODULES 
use File::Basename;
use strict; 
#use Proc::PID_File;
# die "Already running!" if Proc::PID::File->running();
# my $child1 = Proc::PID::File->new(name => "lock.1");

# REQUIREMENTS 
my ($dir) = $0 =~ m|^(/.+)/scripts/| ? $1 : "./";

require "$dir/scripts/database_connection.pl" or die $!;


# DEFINE VARIABLES
	my $database_handle = db();
 

#Gather Cron Bots 
	my %crons_ar ={};
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

FROM cron  c
INNER JOIN cron_times t ON t.cron_id = c.cron_id 
LEFT JOIN cron_history h ON h.cron_id = c.cron_id 

WHERE c.cron_type != 'OFF' 
GROUP BY c.cron_id
ORDER BY c.cron_type  ");
	$sth_crons->execute() or die "database error, sth_crons";

	while(my $crons = $sth_crons->fetchrow_hashref){	
	
		if( ($crons->{min} eq 'PASS') && ($crons->{hour} eq 'PASS') && ($crons->{day_of_month} eq 'PASS') && ($crons->{month} eq 'PASS') && ($crons->{day_of_week} eq 'PASS')  ){
			$crons_ar{$crons->{cron_id}}{'id'} = $crons->{cron_id};
			$crons_ar{$crons->{cron_id}}{'type'} = $crons->{cron_type};

		}

	}
	$sth_crons->finish;



	foreach my $key (sort keys %crons_ar) {

		my $cron_id = $crons_ar{$key}{'id'};
		my $cron_type=$crons_ar{$key}{'type'};

             	if($cron_type eq "HTTP"){ 
			 `/usr/bin/perl $dir/scripts/cron_monitor_http.pl $cron_id > /tmp/cron_monitor_http_$cron_id.log & `;
		} elsif($cron_type eq "HTTPS"){ 
			`/usr/bin/perl $dir/scripts/cron_monitor_https.pl $cron_id > /tmp/cron_monitor_https_$cron_id.log &`;
		} elsif($cron_type eq "FTP"){
			`/usr/bin/perl $dir/scripts/cron_monitor_ftp.pl $cron_id > /tmp/cron_monitor_ftp_$cron_id.log &`;
                } elsif($cron_type eq "SSH"){
                        `/usr/bin/perl $dir/scripts/cron_monitor_ssh.pl $cron_id > /tmp/cron_monitor_ssh_$cron_id.log &`;
                }elsif($cron_type eq "SHELL"){
                        `/usr/bin/perl $dir/scripts/cron_monitor_shell.pl $cron_id > /tmp/cron_monitor_shell_$cron_id.log &`;
                } elsif($cron_type eq "MYSQL"){
                        `/usr/bin/perl $dir/scripts/cron_monitor_https.pl $cron_id > /tmp/cron_monitor_https_$cron_id.log &`;
                }

      	#	print " CRON ID :".$cron_id." TYPE- ".$cron_type."\n ";      
      
        }



# Disconnect the primary db 
$database_handle->disconnect;

sleep(30);
`$dir/scripts/cron_monitor.pl`;


1;
#
