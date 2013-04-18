Chapter: 8
Page Number: 8.00
Title: MySQL Stored Procedures
Content: \
\
The monitoring application uses the following Stored Procedures:\
\
[day_of_month] This procedure is used to quickly populate the jquery/ajax select box for month values in cron times\
[day_of_week]  This procedure is used to quickly populate the jquery/ajax select box for day of the week values in cron times\
[hour]  This procedure is used to quickly populate the jquery/ajax select box for hour values in cron times\
[minutes] This procedure is used to quickly populate the jquery/ajax select box for minutes values in cron times\
[month] This procedure is used to quickly populate the jquery/ajax select box for month values in cron times\
[innodb_buffer_pool_size] This procedure is called via events to keep a history of recommended buffer pool size hourly, results are available on the graphs tab under databases.\
[innodb_log_file_size]  This procedure is called via events to keep a history of recommended log file size hourly, results are available on the graphs tab under databases.\
 \
Mark Leith's performance procedures are documented here http://www.markleith.co.uk/ps_helper/\


 Chapter: 8
Page Number: 8.10
Title: MySQL Events
Content: \
\
Two recurring events used by the sqlhjalp monitor. \
\
The innodb_buffer_pool_size  and the innodb_log_file_size events call the related procedures. \
\
To enable events you set the variable via SET GLOBAL event_scheduler=ON;\
\


 Chapter: 8
Page Number: 8.20
Title: MySQL Triggers 
Content: \
\
Currently the monitor is only utilizing one trigger to ensure the cron times table is updated when a new cron is created. \
\
To see triggers; mysql> show triggers G\
\


 Chapter: 8
Page Number: 8.30
Title: MySQL Performance
Content: \
\
Optimizing your MySQL performance is dependent on numerous things. The databases page help gather data and recommendations for you evaluate. \
\
The Mark Leith's performance procedures help you evaluate options. \
\
Recommend my.cnf edits can be done or checked against the my.cnf created via the Pecona tools at tools.percona.com\
\


 Chapter: 8
Page Number: 8.40
Title: MySQL Events Scheduler
Content: The MySQL Events Scheduler is required to be enabled. \
\
To enable this you set the variable via SET GLOBAL event_scheduler=ON;\
\
This is required for the related EVENTS which active stored routines. 

 