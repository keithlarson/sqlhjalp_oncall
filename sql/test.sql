-- MySQL dump 10.13  Distrib 5.6.10, for Linux (i686)
--
-- Host: localhost    Database: sqlhjalp_monitor
-- ------------------------------------------------------
-- Server version	5.6.10-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cron`
--

DROP TABLE IF EXISTS `cron`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cron` (
  `cron_id` int(11) NOT NULL AUTO_INCREMENT,
  `cron_name` varchar(255) DEFAULT NULL,
  `cron_type` enum('OFF','HTTP','HTTPS','SSH','MySQL','WGET','FTP','SHELL') DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  `ip_address` int(10) unsigned DEFAULT NULL,
  `domain_ip` enum('domain','ip') NOT NULL DEFAULT 'ip',
  `command` varchar(255) DEFAULT NULL,
  `validate` varchar(255) DEFAULT NULL,
  `threshold` int(10) unsigned DEFAULT '0',
  `threshold_ratio` enum('5 MINUTE','15 MINUTE','30 MINUTE','45 MINUTE','1 HOUR','2 HOUR','4 HOUR','1 DAY','1 MONTH','1 YEAR') DEFAULT NULL,
  `time_recorded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `runtime` varchar(10) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`cron_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cron`
--

LOCK TABLES `cron` WRITE;
/*!40000 ALTER TABLE `cron` DISABLE KEYS */;
INSERT INTO `cron` VALUES (1,'DEMO HTTP CRON','HTTP','www.google.com',0,'domain','','/html',5,'5 MINUTE','2013-04-08 14:50:33','','',''),(2,'DEMO HTTPS CRON','HTTPS','www.google.com',0,'domain','','/html',5,'2 HOUR','2013-04-08 14:50:51','','',''),(3,'DEMO MySQL','MySQL','',2130706433,'ip','COMMAND===select 1','1',5,'5 MINUTE','2013-04-08 14:51:52','','sqlapp','c2RqZHNhdmRzanY='),(4,'DEMO FTP','FTP','ftp.mozilla.org',NULL,'domain',NULL,'Login successful',6,'5 MINUTE','2013-04-08 14:42:35',NULL,'anonymous','YW5vbnltb3Vz'),(5,'DEMO SSH','SSH',NULL,2130706433,'ip','COMMAND===/tmp/somescript.sh','1',24,'2 HOUR','2013-04-08 14:53:32',NULL,'Foo','cGFzc3dvcmQ='),(6,'DEMO SH','SHELL',NULL,3232235521,'ip','/tmp/somescript.sh','1',4,'30 MINUTE','2013-04-08 15:56:18',NULL,NULL,NULL);
/*!40000 ALTER TABLE `cron` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`keith`@`localhost`*/ /*!50003 TRIGGER crons AFTER INSERT ON cron
FOR EACH ROW BEGIN 
INSERT INTO cron_times SET  cron_id = NEW.cron_id; 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cron_history`
--

DROP TABLE IF EXISTS `cron_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cron_history` (
  `cron_history_id` int(11) NOT NULL AUTO_INCREMENT,
  `cron_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL,
  `date_recorded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cron_history_id`)
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cron_history`
--

LOCK TABLES `cron_history` WRITE;
/*!40000 ALTER TABLE `cron_history` DISABLE KEYS */;
INSERT INTO `cron_history` VALUES (1,3,1,'2013-04-08 14:31:48'),(2,4,1,'2013-04-08 14:45:44'),(3,1,1,'2013-04-08 15:02:18'),(4,1,1,'2013-04-08 15:03:35'),(5,1,1,'2013-04-08 15:05:15'),(6,1,1,'2013-04-08 15:06:38'),(7,1,1,'2013-04-08 15:07:38'),(8,1,1,'2013-04-08 15:09:41'),(9,1,1,'2013-04-08 15:09:54'),(10,1,1,'2013-04-08 15:23:46'),(11,1,1,'2013-04-08 15:27:51'),(12,1,1,'2013-04-08 15:29:09'),(13,4,1,'2013-04-08 15:29:33'),(14,1,1,'2013-04-08 15:31:52'),(15,1,1,'2013-04-08 15:32:22'),(16,1,1,'2013-04-08 15:32:38'),(17,1,1,'2013-04-08 15:33:17'),(18,1,1,'2013-04-08 15:33:33'),(19,1,1,'2013-04-08 15:34:09'),(20,1,1,'2013-04-08 15:34:30'),(21,4,1,'2013-04-08 15:35:12'),(22,1,1,'2013-04-08 15:39:04'),(23,1,1,'2013-04-08 15:40:52'),(24,1,1,'2013-04-08 15:41:31'),(25,1,1,'2013-04-08 15:41:58'),(26,1,1,'2013-04-08 15:42:27'),(27,1,1,'2013-04-08 15:42:50'),(28,1,1,'2013-04-08 15:45:39'),(29,1,1,'2013-04-08 15:46:13'),(30,2,1,'2013-04-08 15:48:45'),(31,1,1,'2013-04-08 15:48:45'),(32,1,1,'2013-04-08 15:48:59'),(33,6,2,'2013-04-08 15:51:21'),(34,1,1,'2013-04-08 15:51:21'),(35,4,1,'2013-04-08 15:51:22'),(36,2,1,'2013-04-08 15:51:22'),(37,6,2,'2013-04-08 15:52:44'),(38,4,1,'2013-04-08 15:52:45'),(39,2,1,'2013-04-08 15:52:45'),(40,1,1,'2013-04-08 15:52:45'),(41,6,2,'2013-04-08 15:55:27'),(42,6,2,'2013-04-08 15:55:39'),(43,6,1,'2013-04-08 15:56:33'),(44,1,1,'2013-04-08 18:47:02'),(45,4,1,'2013-04-08 18:47:02'),(46,4,1,'2013-04-08 18:48:02'),(47,1,1,'2013-04-08 18:48:02'),(48,2,1,'2013-04-08 18:48:03'),(49,4,1,'2013-04-08 18:49:02'),(50,1,1,'2013-04-08 18:49:02'),(51,2,1,'2013-04-08 18:49:03'),(52,4,1,'2013-04-08 18:49:04'),(53,1,1,'2013-04-08 18:49:04'),(54,2,1,'2013-04-08 18:49:04'),(55,4,1,'2013-04-08 18:50:02'),(56,1,1,'2013-04-08 18:50:02'),(57,2,1,'2013-04-08 18:50:02'),(58,4,1,'2013-04-08 18:51:02'),(59,1,1,'2013-04-08 18:51:02'),(60,2,1,'2013-04-08 18:51:02'),(61,6,1,'2013-04-08 18:52:02'),(62,4,1,'2013-04-08 18:52:02'),(63,1,1,'2013-04-08 18:52:03'),(64,2,1,'2013-04-08 18:52:03'),(65,6,1,'2013-04-08 18:52:14'),(66,4,1,'2013-04-08 18:52:14'),(67,1,1,'2013-04-08 18:52:14'),(68,2,1,'2013-04-08 18:52:14'),(69,6,1,'2013-04-08 18:56:02'),(70,4,1,'2013-04-08 18:56:02'),(71,1,1,'2013-04-08 18:56:02'),(72,2,1,'2013-04-08 18:56:02'),(73,6,1,'2013-04-08 18:57:01'),(74,4,1,'2013-04-08 18:57:02'),(75,1,1,'2013-04-08 18:57:02'),(76,2,1,'2013-04-08 18:57:02'),(77,6,1,'2013-04-08 18:58:02'),(78,4,1,'2013-04-08 18:58:02'),(79,2,1,'2013-04-08 18:58:02'),(80,1,1,'2013-04-08 18:58:03'),(81,6,1,'2013-04-08 18:58:48'),(82,4,1,'2013-04-08 18:58:49'),(83,1,1,'2013-04-08 18:58:49'),(84,2,1,'2013-04-08 18:58:49'),(85,6,1,'2013-04-08 18:59:01'),(86,4,1,'2013-04-08 18:59:01'),(87,1,1,'2013-04-08 18:59:02'),(88,2,1,'2013-04-08 18:59:02'),(89,6,1,'2013-04-08 18:59:53'),(90,4,1,'2013-04-08 18:59:53'),(91,1,1,'2013-04-08 18:59:53'),(92,2,1,'2013-04-08 18:59:53'),(93,6,1,'2013-04-08 19:00:02'),(94,4,1,'2013-04-08 19:00:02'),(95,1,1,'2013-04-08 19:00:02'),(96,2,1,'2013-04-08 19:00:03'),(97,6,1,'2013-04-08 19:01:01'),(98,4,1,'2013-04-08 19:01:02'),(99,2,1,'2013-04-08 19:01:02'),(100,1,1,'2013-04-08 19:01:02'),(101,6,1,'2013-04-08 19:02:02'),(102,4,1,'2013-04-08 19:02:02'),(103,1,1,'2013-04-08 19:02:02'),(104,2,1,'2013-04-08 19:02:02'),(105,6,1,'2013-04-08 19:03:01'),(106,4,1,'2013-04-08 19:03:02'),(107,1,1,'2013-04-08 19:03:02'),(108,2,1,'2013-04-08 19:03:02'),(109,6,1,'2013-04-08 19:04:02'),(110,4,1,'2013-04-08 19:04:02'),(111,2,1,'2013-04-08 19:04:02'),(112,1,1,'2013-04-08 19:04:02'),(113,6,1,'2013-04-08 19:05:01'),(114,4,1,'2013-04-08 19:05:02'),(115,1,1,'2013-04-08 19:05:02'),(116,2,1,'2013-04-08 19:05:03'),(117,6,1,'2013-04-08 19:06:02'),(118,4,1,'2013-04-08 19:06:02'),(119,1,1,'2013-04-08 19:06:02'),(120,2,1,'2013-04-08 19:06:02'),(121,6,1,'2013-04-08 19:07:01'),(122,4,1,'2013-04-08 19:07:01'),(123,1,1,'2013-04-08 19:07:02'),(124,2,1,'2013-04-08 19:07:02'),(125,6,1,'2013-04-08 19:08:02'),(126,4,1,'2013-04-08 19:08:02'),(127,1,1,'2013-04-08 19:08:02'),(128,2,1,'2013-04-08 19:08:03'),(129,6,1,'2013-04-08 19:09:01'),(130,4,1,'2013-04-08 19:09:02'),(131,1,1,'2013-04-08 19:09:02'),(132,2,1,'2013-04-08 19:09:02'),(133,6,1,'2013-04-08 19:10:02'),(134,4,1,'2013-04-08 19:10:02'),(135,1,1,'2013-04-08 19:10:02'),(136,2,1,'2013-04-08 19:10:02'),(137,6,1,'2013-04-08 19:11:01'),(138,4,1,'2013-04-08 19:11:02'),(139,1,1,'2013-04-08 19:11:02'),(140,2,1,'2013-04-08 19:11:02'),(141,6,1,'2013-04-08 19:12:02'),(142,4,1,'2013-04-08 19:12:02'),(143,2,1,'2013-04-08 19:12:02'),(144,1,1,'2013-04-08 19:12:02'),(145,6,1,'2013-04-08 19:13:01'),(146,4,1,'2013-04-08 19:13:02'),(147,1,1,'2013-04-08 19:13:02'),(148,2,1,'2013-04-08 19:13:04'),(149,6,1,'2013-04-08 19:14:02'),(150,4,1,'2013-04-08 19:14:02'),(151,1,1,'2013-04-08 19:14:02'),(152,2,1,'2013-04-08 19:14:02'),(153,6,1,'2013-04-08 19:15:01'),(154,4,1,'2013-04-08 19:15:02'),(155,1,1,'2013-04-08 19:15:02'),(156,2,1,'2013-04-08 19:15:02'),(157,6,1,'2013-04-08 19:16:02'),(158,4,1,'2013-04-08 19:16:02'),(159,1,1,'2013-04-08 19:16:02'),(160,2,1,'2013-04-08 19:16:03'),(161,6,1,'2013-04-08 19:17:01'),(162,4,1,'2013-04-08 19:17:02'),(163,1,1,'2013-04-08 19:17:02'),(164,2,1,'2013-04-08 19:17:02'),(165,6,1,'2013-04-08 19:18:02'),(166,1,1,'2013-04-08 19:18:02'),(167,2,1,'2013-04-08 19:18:03'),(168,4,1,'2013-04-08 19:18:05'),(169,6,1,'2013-04-08 19:19:01'),(170,4,1,'2013-04-08 19:19:02'),(171,2,1,'2013-04-08 19:19:02'),(172,1,1,'2013-04-08 19:19:02'),(173,6,1,'2013-04-08 19:20:02'),(174,1,1,'2013-04-08 19:20:02'),(175,4,1,'2013-04-08 19:20:02'),(176,2,1,'2013-04-08 19:20:03'),(177,6,1,'2013-04-08 19:21:01'),(178,4,1,'2013-04-08 19:21:02'),(179,1,1,'2013-04-08 19:21:02'),(180,2,1,'2013-04-08 19:21:02'),(181,6,1,'2013-04-08 19:22:02'),(182,4,1,'2013-04-08 19:22:02'),(183,1,1,'2013-04-08 19:22:02'),(184,2,1,'2013-04-08 19:22:03'),(185,6,1,'2013-04-08 19:23:01'),(186,4,1,'2013-04-08 19:23:02'),(187,2,1,'2013-04-08 19:23:02'),(188,1,1,'2013-04-08 19:23:02'),(189,6,1,'2013-04-08 19:24:02'),(190,1,1,'2013-04-08 19:24:02'),(191,2,1,'2013-04-08 19:24:03'),(192,4,1,'2013-04-08 19:24:04'),(193,6,1,'2013-04-08 19:25:01'),(194,4,1,'2013-04-08 19:25:02'),(195,1,1,'2013-04-08 19:25:02'),(196,2,1,'2013-04-08 19:25:02'),(197,6,1,'2013-04-08 19:26:02'),(198,4,1,'2013-04-08 19:26:02'),(199,1,1,'2013-04-08 19:26:02'),(200,2,1,'2013-04-08 19:26:02'),(201,6,1,'2013-04-08 19:27:01'),(202,4,1,'2013-04-08 19:27:02'),(203,1,1,'2013-04-08 19:27:02'),(204,2,1,'2013-04-08 19:27:03'),(205,6,1,'2013-04-08 19:28:02'),(206,4,1,'2013-04-08 19:28:02'),(207,1,1,'2013-04-08 19:28:02'),(208,2,1,'2013-04-08 19:28:02'),(209,6,1,'2013-04-08 19:29:01'),(210,4,1,'2013-04-08 19:29:02'),(211,2,1,'2013-04-08 19:29:02'),(212,1,1,'2013-04-08 19:29:02'),(213,6,1,'2013-04-08 19:30:02'),(214,4,1,'2013-04-08 19:30:02'),(215,1,1,'2013-04-08 19:30:02'),(216,2,1,'2013-04-08 19:30:02'),(217,6,1,'2013-04-08 19:31:01'),(218,1,1,'2013-04-08 19:31:02'),(219,4,1,'2013-04-08 19:31:02'),(220,2,1,'2013-04-08 19:31:02'),(221,6,1,'2013-04-08 19:32:02'),(222,4,1,'2013-04-08 19:32:02'),(223,1,1,'2013-04-08 19:32:02'),(224,2,1,'2013-04-08 19:32:02'),(225,6,1,'2013-04-08 19:33:01'),(226,4,1,'2013-04-08 19:33:02'),(227,1,1,'2013-04-08 19:33:02'),(228,2,1,'2013-04-08 19:33:03'),(229,6,1,'2013-04-08 19:34:02'),(230,4,1,'2013-04-08 19:34:02'),(231,1,1,'2013-04-08 19:34:02'),(232,2,1,'2013-04-08 19:34:02'),(233,6,1,'2013-04-08 19:35:01'),(234,1,1,'2013-04-08 19:35:02'),(235,4,1,'2013-04-08 19:35:02'),(236,2,1,'2013-04-08 19:35:03'),(237,6,1,'2013-04-08 19:36:02'),(238,4,1,'2013-04-08 19:36:02'),(239,1,1,'2013-04-08 19:36:02'),(240,2,1,'2013-04-08 19:36:03'),(241,6,1,'2013-04-08 19:37:01'),(242,4,1,'2013-04-08 19:37:02'),(243,2,1,'2013-04-08 19:37:02'),(244,1,1,'2013-04-08 19:37:02'),(245,6,1,'2013-04-08 19:38:02'),(246,4,1,'2013-04-08 19:38:02'),(247,1,1,'2013-04-08 19:38:02'),(248,2,1,'2013-04-08 19:38:04'),(249,6,1,'2013-04-08 19:39:01'),(250,4,1,'2013-04-08 19:39:02'),(251,1,1,'2013-04-08 19:39:02'),(252,2,1,'2013-04-08 19:39:02'),(253,6,1,'2013-04-08 19:40:02'),(254,4,1,'2013-04-08 19:40:02'),(255,1,1,'2013-04-08 19:40:02'),(256,2,1,'2013-04-08 19:40:02'),(257,6,1,'2013-04-08 19:41:01'),(258,4,1,'2013-04-08 19:41:02'),(259,1,1,'2013-04-08 19:41:02'),(260,2,1,'2013-04-08 19:41:03'),(261,6,1,'2013-04-08 19:42:02'),(262,4,1,'2013-04-08 19:42:02'),(263,1,1,'2013-04-08 19:42:02'),(264,2,1,'2013-04-08 19:42:03'),(265,6,1,'2013-04-08 19:42:28'),(266,4,1,'2013-04-08 19:42:28'),(267,1,1,'2013-04-08 19:42:28'),(268,2,1,'2013-04-08 19:42:29'),(269,6,1,'2013-04-08 19:43:02'),(270,6,1,'2013-04-08 19:43:02'),(271,4,1,'2013-04-08 19:43:02'),(272,4,1,'2013-04-08 19:43:02'),(273,1,1,'2013-04-08 19:43:02'),(274,1,1,'2013-04-08 19:43:03'),(275,2,1,'2013-04-08 19:43:03'),(276,2,1,'2013-04-08 19:43:05'),(277,6,1,'2013-04-08 19:44:02'),(278,6,1,'2013-04-08 19:44:02'),(279,4,1,'2013-04-08 19:44:02'),(280,4,1,'2013-04-08 19:44:02'),(281,1,1,'2013-04-08 19:44:02'),(282,2,1,'2013-04-08 19:44:03'),(283,1,1,'2013-04-08 19:44:03'),(284,2,1,'2013-04-08 19:44:03'),(285,6,1,'2013-04-08 19:45:02'),(286,6,1,'2013-04-08 19:45:02'),(287,4,1,'2013-04-08 19:45:03'),(288,4,1,'2013-04-08 19:45:03'),(289,1,1,'2013-04-08 19:45:03'),(290,2,1,'2013-04-08 19:45:03'),(291,1,1,'2013-04-08 19:45:03'),(292,2,1,'2013-04-08 19:45:03'),(293,6,1,'2013-04-08 19:46:02'),(294,6,1,'2013-04-08 19:46:02'),(295,4,1,'2013-04-08 19:46:02'),(296,4,1,'2013-04-08 19:46:02'),(297,1,1,'2013-04-08 19:46:02'),(298,1,1,'2013-04-08 19:46:03'),(299,2,1,'2013-04-08 19:46:03'),(300,2,1,'2013-04-08 19:46:04');
/*!40000 ALTER TABLE `cron_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact`
--

DROP TABLE IF EXISTS `contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contact` (
  `contact_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobile_phone` varchar(255) DEFAULT NULL,
  `mobile_domain` enum('archwireless.net','cellcom.quiktxt.com','cellularonewest.com','email.uscc.net','fido.ca','gocbw.com','message.alltel.com','messaging.nextel.com','messaging.sprintpcs.com','mmsviaero.com','mobile.celloneusa.com','msg.telus.com','myairmail.com','mymetropcs.com','page.metrocall.com','page.southernlinc.com','pcs.rogers.com','sms.bluecell.com','sms.mycricket.com','tmomail.net','tms.suncom.com','txt.att.net','txt.bellmobility.ca','vtext.com') DEFAULT NULL,
  `date_recorded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`contact_id`),
  UNIQUE KEY `mp` (`mobile_phone`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact`
--

LOCK TABLES `contact` WRITE;
/*!40000 ALTER TABLE `contact` DISABLE KEYS */;
INSERT INTO `contact` VALUES (2,'Billy','Collins','klarson@sqlhjalp.com','1303356582','txt.att.net','2013-04-08 19:43:02'),(3,'Jenny','Heath','klarson@econseiller.com','13033356582','txt.att.net','2013-04-08 19:43:21');
/*!40000 ALTER TABLE `contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events` (
  `events_id` int(11) NOT NULL AUTO_INCREMENT,
  `events_name` varchar(255) DEFAULT NULL,
  `contact_id` int(11) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `primary_contact` tinyint(2) DEFAULT NULL,
  PRIMARY KEY (`events_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,'DEMO Foo Bar ',1,'2013-04-08','2013-04-08',1),(2,'DEMO Billy Collins',2,'2013-04-15','2013-04-22',1),(3,'DEMO Jenny Heath',3,'2013-04-08','2013-04-08',0),(4,'Billy Collins',2,'2013-04-08','2013-04-30',1);
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dashboard`
--

DROP TABLE IF EXISTS `dashboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dashboard` (
  `dashboard_id` int(11) NOT NULL AUTO_INCREMENT,
  `cron_id` int(11) NOT NULL,
  `cron_status` tinyint(2) DEFAULT NULL,
  `date_recorded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`dashboard_id`),
  UNIQUE KEY `Cid` (`cron_id`)
) ENGINE=InnoDB AUTO_INCREMENT=303 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dashboard`
--

LOCK TABLES `dashboard` WRITE;
/*!40000 ALTER TABLE `dashboard` DISABLE KEYS */;
INSERT INTO `dashboard` VALUES (3,3,1,'2013-04-08 14:31:48'),(296,6,1,'2013-04-08 19:46:02'),(298,4,1,'2013-04-08 19:46:02'),(300,1,1,'2013-04-08 19:46:03'),(302,2,1,'2013-04-08 19:46:04');
/*!40000 ALTER TABLE `dashboard` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-04-08 14:46:23
