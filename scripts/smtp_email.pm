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
# THIS SUBROUTINE WAS FOUND HERE http://robertmaldon.blogspot.com/2006/10/sending-email-through-google-smtp-from.html


sub send_mail {
my $to = $_[0];
my $subject = $_[1];
my $body = $_[2];
my $from = $_[3];
my $password = $_[4];
my $smtp_server = $_[5];
my $port= $_[6];
my $smtp;

if (not $smtp = Net::SMTP::SSL->new($smtp_server,
                            Port => $port,
                            Debug => 1)) {
   die "Could not connect to server\n";
}

$smtp->auth($from, $password)
   || die "Authentication failed!\n";

$smtp->mail($from . "\n");
my @recepients = split(/,/, $to);
foreach my $recp (@recepients) {
    $smtp->to($recp . "\n");
}
$smtp->data();
$smtp->datasend("From: " . $from . "\n");
$smtp->datasend("To: " . $to . "\n");
$smtp->datasend("Subject: " . $subject . "\n");
$smtp->datasend("\n");
$smtp->datasend($body . "\n");
$smtp->dataend();
$smtp->quit;
}

1;

