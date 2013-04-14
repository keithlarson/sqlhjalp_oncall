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
#  Description   DATABASE CONNECTION FOR THE SQLHJALP MONITOR			 #
#  https://github.com/keithlarson/sqlhjalp_oncall                                #
#                                                                                #
#                                                                                # 
##################################################################################

use Data::Dumper;
use DBI;
use Cwd;
use File::Basename;
use Net::SMTP::SSL;
use WWW::Twilio::API;

my ($dir) = $0 =~ m|^(/.+)/scripts/| ? $1 : "./";
my $filename = "$dir/config/config.info";
$dir=$dir."/scripts/";


sub trim {
#  This is jus to trim and remove excess data
   my $string = shift;
   $string =~ s/^\s+//;
   $string =~ s/\s+$//;
   return $string;
}


sub parse_info{

   my %data = {};
#   my $filename = "$dir/config/config.info"; 

   open FILE, "<$filename";
   while(my $line = <FILE>) {
      $line= trim($line);
	#Skip Comments 
      	if($line =~ /^#/m) {
         	next;
      	}
	# Parse out data per the === symbols 
      	my @split_ar = split(/\=\=\=/, $line);
      	if(@split_ar < 2) {
         	next;
      	}
      	my $name = trim($split_ar[0]);
      	my $value = trim($split_ar[1]);

      	$data{$name} = $value;
   }
   close FILE;
 
   return %data;
}

sub db{
	my $info={}; 
  	%info=parse_info(); 

     	my $source = "DBI:mysql:".$info{SQLMOT_DB_DATABASE}.':'.$info{SQLMOT_HOST};
	my $user = $info{SQLMOT_DB_USER};
	my $pass = $info{SQLMOT_DB_PASS};
 	# print " \n\nValues from lookup in constants.txt:source:".$source.",user:".$user.",pass:".$pass."\n \n";
      my $dbh = DBI->connect($source, $user, $pass) or nineoneone(%info,"Could not connect to database ".${DBI::strerr} );  #  die("Could not connect to database\n$!\n".${DBI::strerr});

return $dbh
}



sub nineoneone(){

my %info = $_[0]; 
my $error= $_[1];

my $subject=" SQLHJALP MONITOR 911";
my $body=" Hello you have been designated as the Admin contact.  We appear to have an alert that needs your attention.\n
 The Error is $error   ";
my $txt_info="ADMIN Alert -  $error ";
my $xml_message="
<Response>
     <Say>Hello you have been designated as the Admin contact.  We appear to have an alert that needs your attention. </Say>
     <Say>I will email and txt you additional information but for your reference here is what we know</Say>
     <Say>The Error is $error </Say>
</Response>";


	$to="ADMIN EMERGENCY CONTACT <".$info{SQLMOT_ADMIN_EMAIL}.">";
	&send_mail($to, $subject, $body,$info{SMTP_USER},$info{SMTP_PASS},$info{SMTP_SERVER},465);

	$message_info =~ s/ /+/g;
	&twilio($info{SQLMOT_ADMIN_PHONE},$info{PHONE},$txt_info,$info{ACCOUNTSID} ,$info{AUTHTOKEN},$xml_message );

	die("$to has been notified of the error - $error \n ");
}


1;
