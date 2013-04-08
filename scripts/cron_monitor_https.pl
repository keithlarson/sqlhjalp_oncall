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
require LWP::UserAgent;
require LWP::RobotUA;
use HTML::LinkExtor;
use URI::URL;
use LWP::Protocol::https;
use MIME::Base64;
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
	my $code = "";
	my $content = "";
	my $url= new LWP::RobotUA 'my-robot/1.0', 'RobotUA@.sqlhjalp.com';
	my $url_string="https://";
	my $status_id=3;	
        

        #Gather Cron information
        my %crons_ar = crons_sql_idtype($database_handle,'HTTPS',$id);
	        
	# NEED TO DEBUG THE PHISH LIKE USER AND PASSWORD CHCK
	if( ($crons_ar{username} ne "") && ($crons_ar{password} ne "") ){ $url_string.=$crons_ar{username}.":".$crons_ar{password}."@"; }

	if($crons_ar{domain_ip} eq 'ip'){
                $url_string.=$crons_ar{ip_address};
        }else {
                $url_string.=$crons_ar{domain};
        }
		$url_string.=$crons_ar{command};
	

     	$url->delay(0);
	my $UserAgent = LWP::UserAgent->new();
     	my $request = new HTTP::Request('GET', $url_string);
	 	$request->header('If-SSL-Cert-Subject' => "/CN=".$crons_ar{domain});
     	my $response = $url->request($request);
     	my $headers=$url->request($request);
        my $status_line = $headers->status_line;
     	$code = $response->code;
     	$content = $response->content;
	my $res = $UserAgent->request( $request );


	# Response Codes defined here http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html

	if($content =~ m/$crons_ar{validate}/gs){ $status_id=1; } else { $status_id=2; } 

	if($status_id != 1) {
                db_cron_error($database_handle,$crons_ar{cron_id},2,$code);
        } else{
                db_cron_update($database_handle,$crons_ar{cron_id},$status_id);
        }

	
$database_handle->disconnect;

1;

