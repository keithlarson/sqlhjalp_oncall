This is a LAMP stack monitoring application. Alterations for web servers other than APACHE on LINUX are up to you.

This application is designed for an Intranet. If you would like to place this on the public web I would recommend HTTP Password protection.

The application does the following:

--Schedules on call rotations for users.

--Notifications via email

--Notifications via a phone call
* --So you do not sleep through another txt message overnight

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

To begin: ./install.pl

Documentation is available via txt files in the docs folder, within the dashboard and also available online: https://github.com/keithlarson/sqlhjalp_oncall/ it was previously available here: https://code.launchpad.net/~klarson/+junk/sqlhjalp_monitor

Screenshots available via the github wiki - https://github.com/keithlarson/sqlhjalp_oncall/wiki/
