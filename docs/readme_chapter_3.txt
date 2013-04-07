Chapter: 3
Page Number: 3.00
Title: Dashboard Overview
Content:  
The Dashboard displays the current status of all active cron jobs and their status after they have ran. 

At first this page will be blank. Once you create and have an active cron job running this page will give you the latest results, PASS OR FAIL. 


 Chapter: 3
Page Number: 3.01
Title: Dashboard Default
Content:  
The Dashboard is set as the default page of the system. While this is a blank page at the start it is default so that you will have easy access to the latest information once you log in. 

This page will also auto refresh every 15 minutes. 


 Chapter: 3
Page Number: 3.02
Title: Dashboard General Tab
Content:  
The Dashboard General Tab is the navigational location for dashboard information. This page is for informational purposes only.


 Chapter: 3
Page Number: 3.03
Title: Dashboard Documentation Tab
Content:  
The 'Dashboard' page displays the current status of all active cron jobs. 

The Tab: [General] Displays the current status of all active cron jobs. 

Results are displayed by CRON ID Name Status Threshold Last Ran and last Response

The Tab: [Documentation] Contains related Documentation to the Dashboard.


 Chapter: 3
Page Number: 3.04
Title: Dashboard Cron Page
Content:  
The Dashboard Cron Page displays the current crons that have been created, active or inactive. 

This page is made of up 3 different tabs, General, Add New Cron and Documentation.



 Chapter: 3
Page Number: 3.05
Title: Cron General Tab
Content:  
The Tab: [General] contains cron jobs listed by ID, Name and last updated status. The cron id is a hyperlink that allows you to go to the 'details page', more information is available on the 'details page' documentation section.



 Chapter: 3
Page Number: 3.06
Title: Add New Cron Tab 
Content:  
The Tab: [ADD NEW CRON] is how you create new cron jobs. Enter the desired name and select the check button. This will create the cron job and allow you to continue edits via the 'General' tab and cron id hyperlink.


 Chapter: 3
Page Number: 3.07
Title: Cron Documentation Tab
Content:  
The 'Cron Jobs' page lists current crons created.

The Tab: [General] contains cron jobs listed by ID, Name and last updated status. The cron id is a hyperlink that allows you to go to the 'details page,' more information is available on the 'details page' documentation section.

The Tab: [ADD NEW CRON] is how you create new cron jobs. Enter the desired name and select the check button. This will create the cron job and allow you to continue edits via the 'General' tab and cron id hyperlink. 

The Tab: [Documentation] Contains related Documentation to the Cron jobs.


 Chapter: 3
Page Number: 3.08
Title: Cron Details 
Content:  
Cron Details page lists current details about the cron job created. 

All page contacts items that are editable per field. 

The Tab: [General] contains the required information to execute the cron job as you require. 

The Tab: [Command||Execute||SQL] contains documentation about the dynamic values used. 

The Tab: [Documentation] Contains related Documentation to the Cron jobs.


 Chapter: 3
Page Number: 3.09
Title: Cron Details General Tab  
Content:  
Cron Details page lists current details about the cron job created. 

All page contacts items that are editable per field. 

The Tab: General contains the required information to execute the cron job as you require. 

The Field: Name Is for user reference only. 

The Field: Type Includes the Cron job protocol options which includes ('HTTP','HTTPS','SSH','MySQL','WGET','FTP','SHELL') or the option 'OFF' will disable the cron job. 

The Field: Domain Allows DNS reference to related the cron job. 

The Field: IP Address Allows IP address reference to related the cron job.

The Field: Domain or IP Allows you to choose which reference will be used, Domain or IP .

The Field: Validate Is the value used for validation of a positive result. For example if validating a html page the reference /html could be used to show a valid page completed. 

The Field: Threshold Is an integer value that represents how many times a failed cron job can fail within the Threshold Ratio before notifications are engaged.

The Field: Threshold Ratio is the allowed time range to include Threshold failures before notifications are engaged.

The Field: UserName Is the username value for required protocols, SSH , FTP , HTTPS

The Field: Password Is the password value for required protocols, SSH , FTP , HTTPS

The Field: Command||Execute||SQL Please review the Command||Execute||SQL documentation section. This field allows dynamic override and commands for cron jobs. 

The Field: Cron Times These fields encompass runtimes for each cron job. These values are based on crontab values. 


 Chapter: 3
Page Number: 3.10
Title: Cron Details Extras Tab
Content:  

Additional options are available via the Command||Execute||SQL section. 
Below are some examples.
Always separate items with === and newline for each item.

FTP variable examples and overrides
PORT===21
PASSIVE===1
CWD===/home/username
DEBUG===1

MySQL variable examples and overrides
PORT===3306
DATABASE===test
QUERY===SELECT 1 as value

SSH variable examples and overrides
PORT===22
DEBUG===1
COMMAND===/tmp/script_with_result.sh


 Chapter: 3
Page Number: 3.11
Title: Cron Details Documentation Tab 
Content:  
The 'Cron Jobs' Details page lists current details about the cron job created. 

The Tab: [General] contains the required information to execute the cron job as you require. 

The Tab: [Command||Execute||SQL] contains documentation about the dynamic values used. 

The Tab: [Documentation] Contains related Documentation to the Cron jobs.

The Field: [Name] Is for user reference only. 

The Field: [Type] Includes the Cron job protocol options which includes ('HTTP','HTTPS','SSH','MySQL','WGET','FTP','SHELL') or the option 'OFF' will disable the cron job. 

The Field: [Domain] Allows DNS reference to related the cron job. 

The Field: [IP Address] Allows IP address reference to related the cron job.

The Field: [Domain or IP] Allows you to choose which reference will be used, Domain or IP .

The Field: [Validate] Is the value used for validation of a positive result. For example if validating a html page the reference /html could be used to show a valid page completed. 

The Field: [Threshold] Is an integer value that represents how many times a failed cron job can fail within the Threshold Ratio before notifications are engaged.

The Field: [Threshold Ratio] is the allowed time range to include Threshold failures before notifications are engaged.

The Field: [UserName] Is the username value for required protocols, SSH , FTP , HTTPS

The Field: [Password] Is the password value for required protocols, SSH , FTP , HTTPS

The Field: [Command||Execute||SQL] Please review the Command||Execute||SQL documentation section. This field allows dynamic override and commands for cron jobs. 

The Field: [Cron Times] These fields encompass runtimes for each cron job. These values are based on crontab values. 


 Chapter: 3
Page Number: 3.12
Title: Contacts Page 
Content:  
The 'Contacts' page lists current contacts. 

All contacts are then made available for on-call status under the Schedule Page. 

The Tab: General contains contact used for notifications. They are listed by ID, Email, Name and last updated status. 

The id is a hyperlink that allows you to go to the 'details page,' more information is available on the 'details page' documentation section.

The Tab: ADD NEW CONTACT is how you create new contact. Enter the desired email and select the check button. This will create a new contact and allow you to continue edits via the 'General' tab and contacts id hyperlink. 

The Tab: Documentation Contains related Documentation to contacts.


 Chapter: 3
Page Number: 3.13
Title: Contacts General Tab
Content:  
The Tab: General contains contact used for notifications. They are listed by ID, Email, Name and last updated status. 

The id is a hyperlink that allows you to go to the 'Contact details page,' more information is available on the 'details page' documentation section.


 Chapter: 3
Page Number: 3.14
Title: Add New Contact
Content:  
The Tab: ADD NEW CONTACT is how you create new contact. Enter the desired email and select the check button. This will create a new contact and allow you to continue edits via the 'General' tab and contacts id hyperlink. 


 Chapter: 3
Page Number: 3.15
Title: Contacts Documentation Tab   
Content:  
The 'Contacts' page lists current contacts.

The Tab: [General] contains contact used for notifications. They are listed by ID, Email, Name and last updated status. 

The id is a hyperlink that allows you to go to the 'details page,' more information is available on the 'details page' documentation section.

The Tab: [ADD NEW CONTACT] is how you create new contact. Enter the desired email and select the check button. This will create a new contact and allow you to continue edits via the 'General' tab and contacts id hyperlink. 

The Tab: [Documentation] Contains related Documentation to contacts.


 Chapter: 3
Page Number: 3.16
Title: Contacts Details Page
Content:  
The 'Contacts Details' page lists current contact information.

The Tab: [General] contains contact information available for edit. Each field is editable dynamically. 

The Tab: [Documentation] Contains related Documentation to contacts. 


 Chapter: 3
Page Number: 3.17
Title: Contacts Details General Tab
Content:  
The Tab: [General] contains contact information available for edit. Each field is editable dynamically. 

The Field: Email Is non editable. 

The Field: First Name Is editable.

The Field: Last Name Is editable.

The Field: Mobile Phone Number Is the full phone number use for voice notifications. 
An example is : 13035555555

The Field: Mobile Email Domain Can be used for SMS messages. Since we are currently using Twilio.com they can handle the SMS for us. If you override Twilio.com use can use your mobile phone and this field for SMS emails. 


 Chapter: 3
Page Number: 3.18
Title: Contacts Details Documentation Tab
Content:  
The 'Contacts Details' page lists current contact information.

The Tab: [General] contains contact information available for edit. Each field is editable dynamically. 

The Field: Email Is non editable. 

The Field: First Name Is editable.

The Field: Last Name Is editable.

The Field: Mobile Phone Number Is the full phone number use for voice notifications. 
An example is : 13035555555

The Field: Mobile Email Domain Can be used for SMS messages. Since we are currently using Twilio.com they can handle the SMS for us. If you override Twilio.com use can use your mobile phone and this field for SMS emails. 

The Tab: Documentation Contains related Documentation to contacts.


 Chapter: 3
Page Number: 3.19
Title: Schedule Page 
Content:  

The Tab: [General] Displays the calendar and on call contacts. 

The Tab: [Add event] Allows you to add a contact for on call status during a given time range.

The Tab: [Documentation] Contains related Documentation to the Schedule. 


 Chapter: 3
Page Number: 3.20
Title: Schedule General Tab
Content:  

The Tab: [General] Displays the calendar and on call contacts. 



 Chapter: 3
Page Number: 3.21
Title: Schedule Add New Event 
Content:  

The Tab: [Add event] Allows you to add a contact for on call status during a given time range. 

The Field: Contact Allows you to select a contact name. 

The Field: Start Date Is the start date for a given event or on call period.

The Field: End Date Is the end date for a given event or on call period.

The Field: Primary Contact Allows you to designate a contact as the primary contact. Notifications will contact this person first. 



 Chapter: 3
Page Number: 3.22
Title: Schedule Documentation
Content:  
The 'Schedule' page displays a calendar and the ability to add new on call contacts to the calendar. 

The Tab: [General] Displays the calendar and on call contacts. 

The Tab: [Add event] Allows you to add a contact for on call status during a given time range. 

The Field: Contact Allows you to select a contact name. 

The Field: Start Date Is the start date for a given event or on call period.

The Field: End Date Is the end date for a given event or on call period.

The Field: Primary Contact Allows you to designate a contact as the primary contact. Notifications will contact this person first. 

The Tab: [Documentation] Contains related Documentation to the Schedule.
 Contact Allows you to designate a contact as the primary contact. Notifications will contact this person first. 



 Chapter: 3
Page Number: 3.23
Title: History Page
Content:  
The 'History' page displays the history of all previous cron jobs. 

The Tab: [General] Displays the history of all previous cron jobs. History is displayed by CRON ID Name Status and Last Ran 

The Tab: [Documentation] Contains related Documentation to the History.



 Chapter: 3
Page Number: 3.24
Title: History General Tab
Content:  
The Tab: [General] Displays the history of all previous cron jobs. History is displayed by CRON ID Name Status and Last Ran 



 Chapter: 3
Page Number: 3.25
Title: History Documentation Tab 
Content:  
The 'History' page displays the history of all previous cron jobs. 

The Tab: [General] Displays the history of all previous cron jobs. History is displayed by CRON ID Name Status and Last Ran 

The Tab: [Documentation] Contains related Documentation to the History.


 Chapter: 3
Page Number: 3.26
Title: Database Page 
Content:  
The 'Database Details' page displays information related to the given databases. 

The Tab: [General] Displays the current important MySQL Variables. If the variable event_scheduler is OFF documentation to enable will be displayed. 

The Tab: [Graphs] Displays graphical historical recommendations for Innodb Log File Size and the Innodb Buffer Pool Size.

The Tab: [Mark Leith's pshelper] If enabled display MySQL information derived from Mark Leith's DB Performance procedures. 

 Chapter: 3
Page Number: 3.27
Title: Database General Tab
Content:  
The 'Database Details' page displays information related to the given databases. 

The Tab: [General] Displays the current important MySQL Variables. If the variable event_scheduler is OFF documentation to enable will be displayed. 


 Chapter: 3
Page Number: 3.28
Title: Database Graphs Tab 
Content:  
The Tab: [Graphs] Displays graphical historical recommendations for Innodb Log File Size and the Innodb Buffer Pool Size.


 Chapter: 3
Page Number: 3.29
Title: Database PS Helper Tab 
Content:  
The 'Mark Leith's pshelper tab displays information related to the enabled procedures. 

More information available here http://www.markleith.co.uk/ps_helper/

The Tab: [Top Global Consumers by Total Latency Displays] the top wait classes by total latency.

The Tab: [Top Global Consumers by Average Latency] Displays the top wait classes by average latency.

The Tab: [Statements with runtimes in 95th%] Displays the top 10 statements who's average runtime, in microseconds, is in the top 95th percentile.

The Tab: [Statements with Full Table Scans] Displays the top 10 normalized statements that use have done a full table scan ordered by the percentage of times a full scan was done, then by the number of times the statement executed.

The Tab: [Top IO by Thread] Displays the top IO consumers by thread, ordered by total latency.

The Tab: Documentation Contains related Documentation to the Mark Leith's pshelper.


 Chapter: 3
Page Number: 3.30
Title: Database Documentation Tab
Content:  
The 'Database Details' page displays information related to the given databases. 

The Tab: [General] Displays the current important MySQL Variables. If the variable event_scheduler is OFF documentation to enable will be displayed. 

The Tab: [Graphs] Displays graphical historical recommendations for Innodb Log File Size and the Innodb Buffer Pool Size.

The Tab: [Mark Leith's pshelper] If enabled display MySQL information derived from Mark Leith's DB Performance procedures. 

More information is available at http://www.markleith.co.uk/ps_helper/

Additional documentation available under the Mark Leith's pshelper documentation tab.

The Tab: Documentation Contains related Documentation to the Mark Leith's pshelper.


 
