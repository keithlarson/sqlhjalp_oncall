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
use Net::SMTP::SSL;
use WWW::Twilio::API;
use Cwd;

my $dir = getcwd;

# REQUIREMENTS 
 require "$dir/database_connection.pl" or die $!;
 require "$dir/smtp_email.pm" or die $!;
 require "$dir/twilio.pm"  or die $!;


# DEFINE VARIABLES
	my $database_handle = db();
	my %parsed_info=parse_info();
	my $smtp_server=$parsed_info{SMTP_SERVER};
        my $user=$parsed_info{SMTP_USER};
        my $pass=$parsed_info{SMTP_PASS};
	my $SID=$parsed_info{ACCOUNTSID};
	my $token=$parsed_info{AUTHTOKEN};
	my $from_phone=$parsed_info{PHONE};
	my %crons_ar = ();
	my %notify_array = ();
	my $notify=0; 
	my $message_info;
	my $voice_message;
	my $txt_info="CRON IDS that FAILED ";
	my $to;
	my $body;
	my $subject = "SQLHJALP Monitor Alert";
	my $debug=1;

	# Gather the active Crons with thresholds
	my $sth_crons = $database_handle->prepare("SELECT  c.cron_id , c.threshold, c.threshold_ratio
	FROM sqlmot_cron c
	WHERE c.cron_type != 'OFF' 
	AND c.threshold != ''
	AND c.threshold_ratio != '' 
	");
	# Who will we need to contact
	my $sth_contacts = $database_handle->prepare("SELECT c.contact_id , c.first_name , c.last_name , c.email , c.mobile_phone, c.mobile_domain 
	FROM sqlmot_events e 
	INNER JOIN sqlmot_contact c ON c.contact_id = e.contact_id
	WHERE NOW() BETWEEN e.start_date and e.end_date
	AND c.email IS NOT NULL AND  c.mobile_phone IS NOT NULL AND c.mobile_domain IS NOT NULL 
	ORDER BY e.primary_contact DESC ");

	# Update status so we do not notify more than once for same alert
	my $sth_acknowledge= $database_handle->prepare("UPDATE sqlmot_cron_failed_response SET acknowledge=1 WHERE cron_id = ? ");

	# Loops over or active Crons
	$sth_crons->execute() or die "database error, sth_crons";
	while(my $crons = $sth_crons->fetchrow_hashref){	
		$crons_ar{$crons->{cron_id}}{threshold} = $crons->{threshold};
		$crons_ar{$crons->{cron_id}}{threshold_ratio} = $crons->{threshold_ratio};
	}
	$sth_crons->finish;

	# Sort per active crons to test against each threshold per cron	
        foreach my $key (sort (keys(%crons_ar))) {

	# Gather Thresehold info per cron 
	my $sth_notify = $database_handle->prepare("SELECT f.cron_id , c.cron_name, COUNT(f.cron_failed_response_id) as failures , f.response 
        FROM sqlmot_cron_failed_response f
	INNER JOIN sqlmot_cron c ON f.cron_id = c.cron_id
        WHERE f.cron_id = $key
	AND f.acknowledge=0
        AND f.date_recorded >= NOW() - interval ".$crons_ar{$key}{threshold_ratio}." HAVING COUNT(f.cron_failed_response_id)  > ".$crons_ar{$key}{threshold});
 	 $sth_notify->execute()or die "database error, sth_notify";

         while(my $n = $sth_notify->fetchrow_hashref){
		$notify=1;
		$message_info.="Cron [".$n->{cron_id}."] ".$n->{cron_name}." Failed and currently has ".$n->{failures}." \n Last Known Response was ".$n->{response}." \n\n " ;
	   	$txt_info.=$n->{cron_id}." ";			
		my $name_clean=$n->{cron_name};
		$name_clean =~ s/ /+/g;
		$voice_message.="Cron+id+".$n->{cron_id}."+".$name_clean."+Failed+";
		$notify_array{$crons->{cron_id}};
         }
         $sth_notify->finish;
        } # For Each End of Loop


	# We need to contact others now Via email , txt and phone call
	if($notify == 1){
		$body = "The SQLHJALP Monitor has detected failures for the following cron jobs that you set up.\n $message_info \n\n ";
	
		$sth_contacts->execute() or die "database error, sth_contacts";
		while(my $contact = $sth_contacts->fetchrow_hashref){        

              		$to=$contact->{first_name}." ".$contact->{last_name}. "<".$contact->{email}.">"; 
			&send_mail($to, $subject, $body,$user,$pass,$smtp_server,465);			
			  
			$message_info =~ s/ /+/g;
 			&twilio($contact->{mobile_phone},$from_phone,$txt_info,$SID ,$token,$voice_message );
        	}
        	$sth_contacts->finish;


		foreach my $key (sort (keys(%crons_ar))) {
			$sth_acknowledge->execute($key)  or die "database error, sth_acknowledge";
		}

	}

# Disconnect the primary db 
$database_handle->disconnect;
1;
