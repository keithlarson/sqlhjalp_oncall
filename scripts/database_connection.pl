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
#  https://code.launchpad.net/~klarson/+junk/sqlhjalp_monitor			 #
#                                                                                #
#                                                                                # 
##################################################################################

use Data::Dumper;
use DBI;
use Cwd;

my $dir = getcwd;


sub trim {
#  This is jus to trim and remove excess data
   my $string = shift;
   $string =~ s/^\s+//;
   $string =~ s/\s+$//;
   return $string;
}


sub parse_info{

   my %data = {};
   my $filename = "$dir/../config/config.info"; 
 
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
#	 print "Values from lookup in constants.txt:source:".$source.",user:".$user.",pass:".$pass."\n";
      my $dbh = DBI->connect($source, $user, $pass) or die("Could not connect to database\n$!\n".${DBI::strerr});

return $dbh
}
1;
