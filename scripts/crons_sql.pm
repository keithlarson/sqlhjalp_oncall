#!/usr/bin/perl

###################################################################################
##                                                                                #
##  Copyright (c) 2013, SQLHJALP.com All rights reserved.                         #
##                                                                                #
##  This program is free software; you can redistribute it and/or modify          #
##  it under the terms of the GNU General Public License as published by          #
##  the Free Software Foundation; version 2 of the License.                       #
##                                                                                #
##  This program is distributed in the hope that it will be useful,               #
##  but WITHOUT ANY WARRANTY; without even the implied warranty of                #
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                 #
##  GNU General Public License for more details.                                  #
##                                                                                #
##  You should have received a copy of the GNU General Public License             #
##  along with this program; if not, write to the Free Software                   #
##  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA      #
##                                                                                #
##  Programmer    Keith Larson                                                    #
##  Description   DATABASE CONNECTION FOR THE SQLHJALP MONITOR                    #
##  https://code.launchpad.net/~klarson/+junk/sqlhjalp_monitor                    #
##                                                                                #
##                                                                                # 
###################################################################################
use MIME::Base64;

sub crons_sql_idtype{

my $database_handle=$_[0];
my $type = $_[1];
my $id = $_[2];
my %ca_data = ();


        my $sth_crons = $database_handle->prepare("SELECT c.cron_id , c.cron_type , c.domain , INET_NTOA(c.ip_address) as  ip_address , c.domain_ip, c.command, c.validate , c.threshold, c.threshold_ratio , c.username , c.password 
        FROM cron  c
        WHERE c.cron_type = '".$type."' 
        AND c.cron_id = '$id'
        ORDER BY c.cron_type");

        $sth_crons->execute() or die "database error, sth_crons";
        while(my $crons = $sth_crons->fetchrow_hashref){
                $ca_data{cron_id} = $crons->{cron_id};
                $ca_data{cron_type} = $crons->{cron_type};
                $ca_data{domain} = $crons->{domain};
                $ca_data{ip_address}= $crons->{ip_address};
                $ca_data{domain_ip}= $crons->{domain_ip};
                $ca_data{command}= $crons->{command};
                $ca_data{validate}= $crons->{validate};
                $ca_data{threshold}= $crons->{threshold};
                $ca_data{threshold_ratio}= $crons->{threshold_ratio};
                $ca_data{username}= $crons->{username};
                $ca_data{password}= decode_base64($crons->{password});

        }
        $sth_crons->finish;

return %ca_data;
}


1;
