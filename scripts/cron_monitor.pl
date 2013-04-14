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
#  Description   CRON JOB Notification monitor FOR THE SQLHJALP MONITOR 	 #
#  https://github.com/keithlarson/sqlhjalp_oncall                                #
#                                                                                #
#                                                                                # 
##################################################################################
# MODULES 
use Net::SMTP::SSL;
use WWW::Twilio::API;
use File::Basename;
my ($dir) = $0 =~ m|^(/.+)/scripts/| ? $1 : "./";
$dir=$dir."/scripts/";



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
	my $http_domain=$parsed_info{SQLMON_ROOT_HTTP};
	my %crons_ar = ();
	my %contacts_array=();
	my %notify_array = ();
	my $notify=0; 
	my $contact_check=0;
	my $message_info;
	my $to;
	
	my $subject = "SQLHJALP Monitor Alert";
	my $debug=0;


	# Gather the active Crons with thresholds
	my $sth_crons = $database_handle->prepare("SELECT  c.cron_id , c.threshold, c.threshold_ratio
	FROM cron c
	WHERE c.cron_type != 'OFF' 
	AND c.threshold != ''
	AND c.threshold_ratio != '' 
	");
	# Who will we need to contact
#Update the SQL to gather primary 1st that are not in the notification history table 
	my $sth_contacts = $database_handle->prepare("SELECT c.contact_id , c.first_name , c.last_name , c.email , c.mobile_phone, c.mobile_domain 
	FROM events e 
	INNER JOIN contact c ON c.contact_id = e.contact_id
	LEFT JOIN cron_notifications n ON n.contact_id = c.contact_id AND n.time_recorded BETWEEN e.start_date and e.end_date
	WHERE NOW() BETWEEN e.start_date and e.end_date
	AND n.contact_id IS NULL
	AND c.email IS NOT NULL AND  c.mobile_phone IS NOT NULL AND c.mobile_domain IS NOT NULL 
	ORDER BY e.primary_contact DESC , events_id ASC  
	LIMIT 1  ");


	#Build out the notification history
	my $sth_notifications= $database_handle->prepare("INSERT INTO cron_notifications VALUES (NULL,?,?,?,?,NOW())   ");

	# Loops over or active Crons
	$sth_crons->execute() or die "database error, sth_crons";
	while(my $crons = $sth_crons->fetchrow_hashref){	
		$crons_ar{$crons->{cron_id}}{threshold} = $crons->{threshold};
		$crons_ar{$crons->{cron_id}}{threshold_ratio} = $crons->{threshold_ratio};
		if($debug >0){ print " Cron ID: ".$crons->{cron_id}."  threshold ".$crons->{threshold}."  -> ".$crons->{threshold_ratio}."  \n  "; }
	}
	$sth_crons->finish;

	# Sort per active crons to test against each threshold per cron	
        foreach my $key (sort (keys(%crons_ar))) {

	# Gather Thresehold info per cron 
	my $sth_notify = $database_handle->prepare("SELECT f.cron_id , c.cron_name, COUNT(f.cron_failed_response_id) as failures , f.response,f.cron_failed_response_id  
        FROM cron_failed_response f
	INNER JOIN cron c ON f.cron_id = c.cron_id
	LEFT JOIN cron_notifications n ON n.cron_failed_response_id = f.cron_failed_response_id
        WHERE f.cron_id = $key
	AND ( n.status_id != 1 OR n.status_id != 3 OR n.status_id IS NULL)	
	AND f.acknowledge=0
        AND f.date_recorded >= NOW() - interval ".$crons_ar{$key}{threshold_ratio}." HAVING COUNT(f.cron_failed_response_id)  > ".$crons_ar{$key}{threshold});
 	$sth_notify->execute()or die "database error, sth_notify";

	 my $i=0;
         while(my $n = $sth_notify->fetchrow_hashref){
		if($debug >0){ print" SHOULD NOTIFY on CRON  ".$n->{cron_id}." ".$n->{cron_name}." ".$n->{cron_failed_response_id}." \n";   }
		$notify_array{$i}{'cron_id'} = $n->{cron_id};
		$notify_array{$i}{'cron_name'} = $n->{cron_name};
		$notify_array{$i}{'failures'} = $n->{failures};
		$notify_array{$i}{'response'} = $n->{response};
		$notify_array{$i}{'cron_failed_response_id'} = $n->{cron_failed_response_id};
		$i=$i+1;
         }
         $sth_notify->finish;
        } # For Each End of Loop

		# We need to contact others now Via email , txt and phone call if $notify_array was populated
		$sth_contacts->execute() or die "database error, sth_contacts";
		my $i=0;
		while(my $contact = $sth_contacts->fetchrow_hashref){        
		if($debug >0){  print "inside contacts $to \n ";}
			$contacts_array{$i}{'contact_id'}=$contact->{contact_id};
			$contacts_array{$i}{'first_name'}=$contact->{first_name};
			$contacts_array{$i}{'last_name'}=$contact->{last_name};
			$contacts_array{$i}{'email'}=$contact->{email};
			$contacts_array{$i}{'mobile_phone'}=$contact->{mobile_phone};
			$contact_check=1;	
		}
		$sth_contacts->finish;
		my $numberofcontacts= scalar keys %contacts_array;
		if($debug >0){  print "size of contacts $numberofcontacts  \n ";}	
		if( $numberofcontacts  == 0){ 
			$i=$numberofcontacts;
			$contacts_array{$i}{'contact_id'}=0;
                        $contacts_array{$i}{'first_name'}="Admin";
                        $contacts_array{$i}{'last_name'}="Contact";
                        $contacts_array{$i}{'email'}=$parsed_info{SQLMOT_ADMIN_EMAIL};
                        $contacts_array{$i}{'mobile_phone'}=$parsed_info{SQLMOT_ADMIN_PHONE};
		 }

		foreach my $ckey (sort (keys(%contacts_array))) {	

			$to=$contacts_array{$ckey}{first_name}." ".$contacts_array{$ckey}{last_name}. "<".$contacts_array{$ckey}{email}.">";
			if($debug >0){  print "inside contacts foreach $to \n ";}
			foreach my $key (sort (keys(%notify_array))) {
			my $info_passed="CTID---".$contacts_array{$ckey}{contact_id}."___CI---".$notify_array{$key}{'cron_id'}."___CFRI---".$notify_array{$key}{'cron_failed_response_id'};
my $xml_message="
<Response>
  <Gather method=\"GET\" action=\"".$http_domain."/?cni=".$info_passed."\" numDigits=\"1\">
     <Say>Hello ".$contacts_array{$ckey}{first_name}." we appear to have an alert that needs your attention. </Say>
     <Say>I will email and txt you additional information but for your reference here is what we know</Say>
     <Say>Cron ".$notify_array{$key}{'cron_name'}." ID ".$notify_array{$key}{'cron_id'}." Failed ".$notify_array{$key}{'failures'}." times with a ".$notify_array{$key}{'response'}." response. </Say>
     <Say>Press 1 to confirm alert</Say>
     <Say>Press 2 to say you are unavailable</Say>
  </Gather>
</Response>";

		my $txt_message="Cron ".$notify_array{$key}{'cron_name'}." ID ".$notify_array{$key}{'cron_id'}." Failed";				
		my $email_message="Cron ".$notify_array{$key}{'cron_name'}." ID ".$notify_array{$key}{'cron_id'}." Failed ".$notify_array{$key}{'failures'}." times with a ".$notify_array{$key}{'response'}." response.";
		   	$email_message.="You can follow this hyperlink to confirm you are aware of this "; 
			$email_message.="<a href=\"".$http_domain."/?cni=".$info_passed."&Digits=1&email=1\">Confirm</a> ";
			$email_message.="<a href=\"".$http_domain."/?cni=".$info_passed."&Digits=2&email=1\">UnAvailable</a> ";
		if($debug >0){ print " \n\n $xml_message \n\n ";  }
         
 			&send_mail($to, $subject,$email_message,$user,$pass,$smtp_server,465);			
 			&twilio($contacts_array{$ckey}{mobile_phone},$from_phone,$txt_message,$SID ,$token,$xml_message);
			$sth_notifications->execute($notify_array{$key}{'cron_id'},$notify_array{$key}{'cron_failed_response_id'},$contacts_array{$ckey}{contact_id},3) or die "database error, sth_notifications";
			}
			

        	}
   

# Disconnect the primary db 
$database_handle->disconnect;
1;
