Chapter: 2
Page Number: 2.00
Title: Installation
Content:  \
Installation is handled by a prebuilt Perl script. \
\
This script will evaluate and start the installations for the required PERL modules via cpan if you allow it. \
\
You will need to have valid permissions to install CPAN modules and create database a users. \
\
Since I am unsure of your current Perl installation... I will use wget to start the configuration while I build out your perl install. \
\
What MySQL username and password is used for this monitor to execute as is up to you. I suggest a new user and password. This installation will create and grant a user for just the required database. If you need additional database permissions that is up to you.\
\
If you do not have wget installed, please do so first. 'yum -y install wget'\


 Chapter: 2
Page Number: 2.10
Title: Configuration File
Content:  \
The Configuration File is referenced and parsed by PHP and PERL for related account information. \
\
It is created by the installation script but values can be changed at any time after created. Keep in mind if you alter the encryption key or iv after it has been used those values would be invalid and have to be reentered.\
\
This file needs to remain secure.\
\
SQLMOT_HOST===< HOST INFO HERE > # example www.sqlhjalp.com\
\
SQLMOT_DB_USER===< USERINFO HERE > # MySQL Username here \
\
SQLMOT_DB_PASS===< PASSWORD HERE > # MySQL Password here\
\
SQLMOT_ADMIN_EMAIL===< ADMIN EMAIL HERE > # Email used for notifications if required. \
\
SQLMOT_DB_DATABASE===sqlhjalp_monitor # This is the default database\
\
SQLMOT_LOCATION_HTTP===< LOCATION HERE > # Example: /sqlhjalp_monitor/ \
\
# THE FOLLOWING KEY IS USED TO ENCRYPT passwords.\
# Please to change this during install. Once you enter a value, changing it will require you to update all passwords in this system. \
# Note that the IV must match the chosen key block size bytes in length\
\
SQLMOT_KEY===< KEY HERE > # I recommend you change the default value that is put into place here before proceeding with saving username and password information in the system. These items are encrypted so would have to be reserved if this key is changed at a later date. \
\
SQLMOT_IV===< IV HERE > # I recommend you change the default value that is put into place here before proceeding with saving username and password information in the system. These items are encrypted so would have to be reserved if this IV is changed at a later date. the IV must match the chosen key block size \
\
# SMTP SERVER INFO BELOW\
\
SMTP_SERVER===< LOCATION HERE > # Example: smtp.gmail.com\
\
SMTP_USER===< LOCATION HERE > # Example: john@doe.com\
\
SMTP_PASS===< LOCATION HERE > # Example: not password\
\
# www.twilio.com Account info below\
\
ACCOUNTSID===< ACCOUNTSID HERE > Example: AC0a6c105...\
\
AUTHTOKEN===< AUTHTOKEN HERE > Example: 140ef63898b...\
\
PHONE===< AUTHTOKEN HERE > Example: 15555555555 Full phone number is require for use with www.twilio.com. If you alter system to use wvdial or other methods for local calls that is up to you.\
\
# http://www.markleith.co.uk/ps_helper/ \
\
LEITH_HOST===< LEITH_HOST HERE > Example: localhost or masterhost\
\
LEITH_USER===< LEITH_USER HERE > Example: not root\
\
LEITH_PASS===< LEITH_PASS HERE > Example: not password or blank\
\
LEITH===1 # This is just an binary value to notify if LEITH is enabled or not.\


 