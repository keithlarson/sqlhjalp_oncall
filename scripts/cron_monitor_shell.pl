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

my $dir = getcwd;

# REQUIREMENTS 
require "$dir/database_connection.pl" or die $!;
require "$dir/crons_sql.pm" or die $!;
require "$dir/db_cron_error.pm" or die $!;
require "$dir/db_cron_update.pm" or die $!;



# DEFINE VARIABLES
	my $database_handle = db();
	my $id = $ARGV[0];  
	my $result = "";
	my $content = "";
	my $url_string;
	my $status_id=3;	

	#Gather Cron information
	my %crons_ar = crons_sql_idtype($database_handle,'SHELL',$id);
	
	$result = `$crons_ar{command}`;

	if($result =~ m/$crons_ar{validate}/gs){ $status_id=1; } else { $status_id=2; } 


	if($status_id != 1) {
                db_cron_error($database_handle,$crons_ar{cron_id},2," $result  ");
        } else{
                db_cron_update($database_handle,$crons_ar{cron_id},$status_id);
        }


$database_handle->disconnect;

1;

