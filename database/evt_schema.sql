-- MySQL dump 10.13  Distrib 5.7.20, for macos10.12 (x86_64)
--
-- Host: morgana.iasfbo.inaf.it    Database: evt
-- ------------------------------------------------------
-- Server version	5.1.73

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
-- Table structure for table `evt3`
--

DROP TABLE IF EXISTS `evt3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `evt3` (
  `evtid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `eventidfits` int(11) NOT NULL,
  `observationid` int(10) unsigned NOT NULL,
  `datarepositoryid` int(11) unsigned NOT NULL,
  `time` double NOT NULL COMMENT 's',
  `ra_deg` double NOT NULL COMMENT 'deg',
  `dec_deg` double NOT NULL COMMENT 'deg',
  `energy` double DEFAULT NULL COMMENT 'TeV',
  `detx` double NOT NULL COMMENT 'deg',
  `dety` double NOT NULL COMMENT 'deg',
  `mcid` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `timerealtt` double NOT NULL,
  `insert_time` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`evtid`),
  UNIQUE KEY `eventidfits` (`eventidfits`,`datarepositoryid`,`observationid`),
  KEY `observationid` (`observationid`),
  KEY `datarepositoryid` (`datarepositoryid`),
  KEY `timerealtt` (`timerealtt`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=40228725 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log_streaming`
--

DROP TABLE IF EXISTS `log_streaming`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_streaming` (
  `id_log_streaming` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime NOT NULL,
  `obs_id` int(11) DEFAULT NULL,
  `twindow_start` double DEFAULT NULL,
  `twindow_stop` double DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id_log_streaming`)
) ENGINE=InnoDB AUTO_INCREMENT=871005 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stream_data`
--

DROP TABLE IF EXISTS `stream_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stream_data` (
  `streamdataid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `observationid` int(11) unsigned NOT NULL,
  `datarepositoryid` int(11) unsigned NOT NULL,
  `tstart` double NOT NULL,
  `tstop` double NOT NULL,
  `streamstatus` int(11) NOT NULL DEFAULT '0',
  `twindowstart` double NOT NULL,
  `twindowstop` double NOT NULL,
  `pipedbname` varchar(255) NOT NULL DEFAULT '',
  `timestep` int(11) NOT NULL,
  `timestepcount` int(11) NOT NULL,
  `speedfactor` int(11) NOT NULL,
  PRIMARY KEY (`streamdataid`),
  UNIQUE KEY `observationid` (`observationid`,`datarepositoryid`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stream_event`
--

DROP TABLE IF EXISTS `stream_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stream_event` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `streaming_evt`
--

DROP TABLE IF EXISTS `streaming_evt`;
/*!50001 DROP VIEW IF EXISTS `streaming_evt`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `streaming_evt` AS SELECT 
 1 AS `evtid`,
 1 AS `eventidfits`,
 1 AS `observationid`,
 1 AS `datarepositoryid`,
 1 AS `time`,
 1 AS `ra_deg`,
 1 AS `dec_deg`,
 1 AS `energy`,
 1 AS `detx`,
 1 AS `dety`,
 1 AS `mcid`,
 1 AS `status`,
 1 AS `timerealtt`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `streaming_evt`
--

/*!50001 DROP VIEW IF EXISTS `streaming_evt`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50001 VIEW `streaming_evt` AS select `evt3`.`evtid` AS `evtid`,`evt3`.`eventidfits` AS `eventidfits`,`evt3`.`observationid` AS `observationid`,`evt3`.`datarepositoryid` AS `datarepositoryid`,`evt3`.`time` AS `time`,`evt3`.`ra_deg` AS `ra_deg`,`evt3`.`dec_deg` AS `dec_deg`,`evt3`.`energy` AS `energy`,`evt3`.`detx` AS `detx`,`evt3`.`dety` AS `dety`,`evt3`.`mcid` AS `mcid`,`evt3`.`status` AS `status`,`evt3`.`timerealtt` AS `timerealtt` from `evt3` where (`evt3`.`status` = 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-08-08 12:15:37
