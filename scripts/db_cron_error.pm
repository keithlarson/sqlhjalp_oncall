#!/usr/bin/perl
 
##################################################################################
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
#
#


         sub db_cron_error{

                my ($database_handle,$cron_id,$status_id,$response) = @_;

                my $sth_cron_history = $database_handle->prepare("INSERT INTO cron_history (cron_id,status_id) VALUES ($cron_id,$status_id) ");
                $sth_cron_history->execute() or die "database error, sth_cron_history";

                my $sth_cron_dashboard = $database_handle->prepare("REPLACE INTO dashboard (cron_id,cron_status) VALUES ($cron_id,$status_id) ");
                $sth_cron_dashboard->execute() or die "database error, sth_cron_dashboard";

                my $sth_cron_failed = $database_handle->prepare("INSERT INTO cron_failed_response (cron_id,response) VALUES ($cron_id, '$response' ) ");
                $sth_cron_failed->execute() or die "database error, sth_cron_failed";

                die( $response );
        }


1;
