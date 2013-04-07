REPLACE INTO cron VALUES (1,'DEMO HTTP CRON','OFF','www.google.com',0,'domain','','/html',5,'5 MINUTE',NOW(),'','','');
REPLACE INTO cron_history VALUES (1,1,1,NOW());
REPLACE INTO contact VALUES (1,'Foo','Bar','foo@bar.com','15555555555','txt.att.net',NOW());
REPLACE INTO events VALUES (1,'DEMO On Call user',1,CURDATE(),CURDATE(),1);
REPLACE INTO dashboard VALUES (1,1,1,NOW());

