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
##  https://github.com/keithlarson/sqlhjalp_oncall                                #
##                                                                                #
##                                                                                # 
###################################################################################

# MORE Information about the Twilio.com service
# http://www.perl.com/pub/2011/09/automating-telephony-with-perl-and-twilio.html
# http://search.cpan.org/~scottw/WWW-Twilio-API-0.17/lib/WWW/Twilio/API.pm 
# http://search.cpan.org/~scottw/WWW-Twilio-TwiML-1.05/lib/WWW/Twilio/TwiML.pm
# http://www.perl.com/pub/2011/12/building-telephony-applications-with-perl-and-twiml.html
#
use WWW::Twilio::API; 
use HTML::Entities;
sub twilio{

my $to = "+1".$_[0];
my $from = $_[1];
my $message = $_[2];
my $SID = $_[3];
my $token = $_[4];
my $voice= $_[5];

my $twilio = WWW::Twilio::API->new( AccountSid  => $SID,
                                 AuthToken   => $token,  
                                 API_VERSION => '2010-04-01' );

## A hollow voice says 'plugh'

my $response = $twilio->POST( 'Calls',
                              To   => $to,  
                              From => $from,  
                              Url  => "http://twimlets.com/message?Message%5B0%5D=".$voice."");
                                    

my $response = $twilio->POST( 'SMS/Messages',
                              To   => $to, 
                              From => $from, 
                              Body => $message ); 
                                
# print $response->{content};
}

1;

