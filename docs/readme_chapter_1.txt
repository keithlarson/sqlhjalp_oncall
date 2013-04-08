Chapter: 1
Page Number: 1.00
Title: Overview
Content:  This is a LAMP stack monitoring application. Alterations for web servers other than APACHE on LINUX are up to you.
 
This application is designed for an Intranet. If you would like to place this on the public web I would recommend HTTP Password protection.

The application does the following:
--Schedules on call rotations for users.
--Notifications via email
--Notifications via a phone call
	--So you do not sleep through another txt message overnight
--Notifications via a txt message
--Allows dynamic cron creation for dynamic monitoring options.
--Monitor MySQL connections
--Monitor MySQL performance
--Monitor HTTP results
--Monitor HTTP results
--Monitor results via SSH command
--Monitor results via MySQL query
--Monitor results from shell command


The install.pl script is designed to install via modules. So if you need to reinstall a certain aspect you can rerun the script and just execute the desired section.

To begin: . install.pl

Documentation is available via txt files in the docs folder, within the dashboard and also available online: https://github.com/keithlarson/sqlhjalp_oncall



Chapter: 1
Page Number: 1.20
Title: Audience
Content:  The extended audience for this software includes LAMP stack developers, administrators and MySQL DBAs or anyone who is on-call. 

Users of Nagios and other notification systems could use this product as well. 

The smart phone changes the world, it also changed how on-call personal are notified. 

In the past, a pager was used to alert and or awaken someone so that they could address a situation. Now with the smart phones, people get txt notifications but those can easily be missed or slept through. People can turn up the volume on their phone so a txt message would alert them but this is currently not addressed per address contact but just overall volume. This product solves that concern and will notify the on-call personal via email, txt message as well as a phone call. 

With a Twilo.com account (which is free to test) and this software you can get voice notifications about a problem. This allows on-call personal to also set distinct ringtones for a call from the Twilo.com or another service number. 

This software is not dependent on Twilo.com. I use this service to allow others to get up and running fast and easily. People can feel free to use wvdial to at least get a phone to alert the on-call user, or build out other voice systems. 


 
