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
use MIME::Base64;
use File::Basename;
my ($dir) = $0 =~ m|^(/.+)/scripts/| ? $1 : "./";
$dir=$dir."/scripts/";



# REQUIREMENTS 
require "$dir/database_connection.pl" or die $!;
require "$dir/crons_sql.pm" or die $!;
require "$dir/db_cron_error.pm" or die $!;
require "$dir/db_cron_update.pm" or die $!;



# DEFINE VARIABLES
	my $database_handle = db();
	my $id = $ARGV[0];  
	my $variables= {};
	my $source;
	my $content = "";
	my $status_id=3;	
	my $response;
	my $database_db;
	my $database_query;
	my $database_port=3306;

	#Gather Cron information
	my %crons_ar = crons_sql_idtype($database_handle,'MySQL',$id);


	# Choose which we prefer ip or domain name
	if($crons_ar{domain_ip} eq 'ip'){
                $source=$crons_ar{ip_address};
        }else {
                $source=$crons_ar{domain};
        }
	

	my @command_array = split('\n',$crons_ar{command});
        foreach my $c (@command_array){

		my @key_val_array = split('===',$c);

		if($key_val_array[0] eq "PORT"){ $database_port=$key_val_array[1];  }
		if($key_val_array[0] eq "DATABASE"){ $database_db=$key_val_array[1];  } 
		if($key_val_array[0] eq "QUERY"){ $database_query=$key_val_array[1];  }
	}

	my $dbi_info= "DBI:mysql:database=".$database_db.';host='.$source.";port=".$database_port;

        my $cron_handle = DBI->connect($dbi_info, $crons_ar{username}, $crons_ar{password}) or db_cron_error($database_handle,$crons_ar{cron_id},2,${DBI::strerr}); 

	# if($content =~ m/$validate/gs){ $status_id=1; } else { $status_id=2; } 

 	if( $database_query ne "" ){

		my $cron_sql_check = $cron_handle->prepare($database_query);
		$cron_sql_check->execute() or db_cron_error($database_handle,$crons_ar{cron_id},2,${DBI::strerr}); 
        	while(my $sql = $cron_sql_check->fetchrow_arrayref){
		
			 if( $sql->[0] =~ m/$validate/gs){ $status_id=1; } else { $status_id=2; }
		}

	}	
	# Disconnect the cron db check
	$cron_handle->disconnect;

	db_cron_update($database_handle,$crons_ar{cron_id},$status_id);

# Disconnect the primary db 
$database_handle->disconnect;
1;

