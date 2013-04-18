<?
#################################################################################
#                                                                               #
# Copyright (c) 2013, SQLHJALP.com All rights reserved.                         #
#                                                                               #
# This program is free software; you can redistribute it and/or modify          #
# it under the terms of the GNU General Public License as published by          #
# the Free Software Foundation; version 2 of the License.                       #
#                                                                               #
# This program is distributed in the hope that it will be useful,               #
# but WITHOUT ANY WARRANTY; without even the implied warranty of                #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                 #
# GNU General Public License for more details.                                  #
#                                                                               #
# You should have received a copy of the GNU General Public License             #
# along with this program; if not, write to the Free Software                   #
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA      #
#                                                                               #
# Programmer    Keith Larson                                                    #
# Description   parses our default variables file				#
# https://github.com/keithlarson/sqlhjalp_oncall                                #
#                                                                               #
# This class is broken out into different sections.                             #
#										# 
#################################################################################

if(!class_exists('file_parse')){
   class file_parse{

      	private $parsed;
	private $debug=0; # 1 is debug 0 is off
  	public $parse_ar=array(); 

      #################################################### 
      # Automatically look up the ../config/config.info file and builds the variables from it Otherwise passed info can set parse info
      #################################################### 
      public function __construct($file=false){

         if ($file){ 
		$filename = $file;
         }elseif(defined('PARSE_PATH')){ 
		$filename = PARSE_PATH;
            }else{ 
  		 $filename = substr('_FILE_',0,strpos('_FILE_','../config/')).'../config/config.info';
	 }


         $this->parsed = file($filename);

         if(is_array($this->parsed)){
	  
            foreach($this->parsed as $prse){
		# Skip Comments
               	if(preg_match('/^#/',$prse)) continue;

               	$E = explode("===",$prse);
               	if(count($E)<2) continue;

		# Skip Comments
                if(preg_match('/^#/',$E[0]) ) continue;
		if(preg_match('/^#/',$E[1]) ) continue;

               	$value = trim($E[1]);
               	$name = trim($E[0]);
          	
		# SET VARIABLE FOR RETURN 
		$this->parse_ar[$name]=$value;
		$_SESSION['parse'][$name]=$value;

		# DEBUG
                if($this->debug==1){ echo "<br>name: $name = value: $value ";  }  
		#else { error_log(" $name = $value  " , 0);  }
             
               	
            } # end of foreach

         } # end of is_array
	 return $this->parse_ar;

      } # end of public function

   } # end of class file_parse
} # end of if(!class_exists 



?>
