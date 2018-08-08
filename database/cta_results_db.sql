-- MySQL dump 10.13  Distrib 5.7.20, for macos10.12 (x86_64)
--
-- Host: localhost    Database: cta_results_db
-- ------------------------------------------------------
-- Server version	5.7.20

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
-- Table structure for table `alert`
--

DROP TABLE IF EXISTS `alert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert` (
  `alertid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `maxdetectionid` int(10) unsigned NOT NULL,
  `firstdetectionid` int(10) unsigned NOT NULL,
  `tstart` double NOT NULL,
  `tstop` double NOT NULL,
  `seqnum` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`alertid`),
  KEY `spot6_maxdetectionid` (`maxdetectionid`),
  KEY `spot6_firstdetectionid` (`firstdetectionid`),
  CONSTRAINT `spot6_alertibfk1` FOREIGN KEY (`maxdetectionid`) REFERENCES `detection` (`detectionid`) ON DELETE CASCADE,
  CONSTRAINT `spot6_alertibfk2` FOREIGN KEY (`firstdetectionid`) REFERENCES `detection` (`detectionid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert`
--

LOCK TABLES `alert` WRITE;
/*!40000 ALTER TABLE `alert` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alert_curve`
--

DROP TABLE IF EXISTS `alert_curve`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_curve` (
  `lightcurveid` int(10) unsigned NOT NULL,
  `alertid` int(10) unsigned NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`lightcurveid`,`alertid`),
  KEY `spot6_lightcurveid` (`lightcurveid`),
  KEY `spot6_alertid` (`alertid`),
  CONSTRAINT `spot6_alertcurveibfk1` FOREIGN KEY (`alertid`) REFERENCES `alert` (`alertid`) ON DELETE CASCADE,
  CONSTRAINT `spot6_alertcurveibfk2` FOREIGN KEY (`lightcurveid`) REFERENCES `lightcurve` (`lightcurveid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_curve`
--

LOCK TABLES `alert_curve` WRITE;
/*!40000 ALTER TABLE `alert_curve` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_curve` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alert_detection`
--

DROP TABLE IF EXISTS `alert_detection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_detection` (
  `detectionid` int(10) unsigned NOT NULL,
  `alertid` int(10) unsigned NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`detectionid`,`alertid`),
  KEY `spot6_detectionid` (`detectionid`),
  KEY `spot6_alertid` (`alertid`),
  CONSTRAINT `spot6_alertdetectionibfk1` FOREIGN KEY (`detectionid`) REFERENCES `detection` (`detectionid`) ON DELETE CASCADE,
  CONSTRAINT `spot6_alertdetectionibfk2` FOREIGN KEY (`alertid`) REFERENCES `alert` (`alertid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_detection`
--

LOCK TABLES `alert_detection` WRITE;
/*!40000 ALTER TABLE `alert_detection` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_detection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alert_old_assoc`
--

DROP TABLE IF EXISTS `alert_old_assoc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_old_assoc` (
  `alertoldassocid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `newalertid` int(11) unsigned NOT NULL,
  `oldalertid` int(11) unsigned NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`alertoldassocid`),
  KEY `newalertid` (`newalertid`),
  KEY `oldalertid` (`oldalertid`),
  CONSTRAINT `alert_old_assoc_ibfk_1` FOREIGN KEY (`newalertid`) REFERENCES `alert` (`alertid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `alert_old_assoc_ibfk_2` FOREIGN KEY (`oldalertid`) REFERENCES `alert` (`alertid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_old_assoc`
--

LOCK TABLES `alert_old_assoc` WRITE;
/*!40000 ALTER TABLE `alert_old_assoc` DISABLE KEYS */;
/*!40000 ALTER TABLE `alert_old_assoc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detection`
--

DROP TABLE IF EXISTS `detection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `detection` (
  `detectionid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `detectionstatus` varchar(255) NOT NULL DEFAULT '',
  `detectioncounts` varchar(255) NOT NULL DEFAULT '',
  `label` varchar(255) NOT NULL,
  `rootname` varchar(255) NOT NULL,
  `l` float NOT NULL,
  `b` float NOT NULL,
  `r` float NOT NULL,
  `ella` float NOT NULL,
  `ellb` float NOT NULL,
  `ellphi` float NOT NULL,
  `bpeak` float DEFAULT NULL,
  `lpeak` float DEFAULT NULL,
  `fluxerr` double NOT NULL,
  `flux` float NOT NULL,
  `fluxul` float DEFAULT NULL,
  `sqrtts` float NOT NULL,
  `countul` int(11) DEFAULT NULL,
  `exposure` float DEFAULT NULL,
  `countserr` float DEFAULT NULL,
  `spectralindex` float NOT NULL,
  `spectralindexerr` float NOT NULL,
  `galerr` float DEFAULT NULL,
  `gal` float DEFAULT NULL,
  `iso` float DEFAULT NULL,
  `isoerr` float DEFAULT NULL,
  `galzeroerr` float DEFAULT NULL,
  `galzero` float DEFAULT NULL,
  `isozero` float DEFAULT NULL,
  `isozeroerr` float DEFAULT NULL,
  `startfixflag` float DEFAULT NULL,
  `startspectralindex` float DEFAULT NULL,
  `startl` float DEFAULT NULL,
  `startb` float DEFAULT NULL,
  `startflux` float DEFAULT NULL,
  `counts` float DEFAULT NULL,
  `tstarttt` double DEFAULT NULL,
  `tstoptt` double DEFAULT NULL,
  `tstartmjd` double DEFAULT NULL,
  `tstopmjd` double DEFAULT NULL,
  `runid` int(10) unsigned NOT NULL,
  `fitcts` float DEFAULT NULL,
  `fitfcn0` float DEFAULT NULL,
  `fitfcn1` float DEFAULT NULL,
  `fitedm0` float DEFAULT NULL,
  `fitedm1` float DEFAULT NULL,
  `fititer0` float DEFAULT NULL,
  `fititer1` float DEFAULT NULL,
  `resfile` text,
  `dist` float DEFAULT NULL,
  `distellipse` float DEFAULT NULL,
  `expratio` float DEFAULT NULL,
  `ulconflevel` float DEFAULT NULL,
  `srcconflevel` float DEFAULT NULL,
  `lmin` float DEFAULT NULL,
  `lmax` float DEFAULT NULL,
  `bmin` float DEFAULT NULL,
  `bmax` float DEFAULT NULL,
  `countserrorp` float DEFAULT NULL,
  `countserrorm` float DEFAULT NULL,
  `fluxerrorp` float DEFAULT NULL,
  `fluxerrorm` float DEFAULT NULL,
  `orbitalphase` float DEFAULT NULL,
  `energyrange` varchar(10000) DEFAULT NULL,
  `fovrange` varchar(10000) DEFAULT NULL,
  `albedo` float DEFAULT NULL,
  `binsize` float DEFAULT NULL,
  `expstep` float DEFAULT NULL,
  `phasecode` float DEFAULT NULL,
  `mlestep1ext1res` float DEFAULT NULL,
  `mlestep2step1res` float DEFAULT NULL,
  `mlestep3ext2res` float DEFAULT NULL,
  `mlestep4step2res` float DEFAULT NULL,
  `mlestep5contourres` float DEFAULT NULL,
  `mlestep6indexres` float DEFAULT NULL,
  `mlestep1ext1cts` float DEFAULT NULL,
  `mlestep2step1cts` float DEFAULT NULL,
  `mlestep3ext2cts` float DEFAULT NULL,
  `mlestep4step2cts` float DEFAULT NULL,
  `mlestep5contourcts` float DEFAULT NULL,
  `mlestep6indexcts` float DEFAULT NULL,
  `mlestep7ulcts` float DEFAULT NULL,
  `tstartutc` datetime DEFAULT NULL,
  `tstoputc` datetime DEFAULT NULL,
  `conf` text NOT NULL,
  `import_time` double DEFAULT NULL,
  PRIMARY KEY (`detectionid`),
  UNIQUE KEY `label` (`label`,`runid`),
  KEY `runid` (`runid`),
  CONSTRAINT `detection_run_fk` FOREIGN KEY (`runid`) REFERENCES `cta_pipe_db`.`run` (`runid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40138 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detection`
--

LOCK TABLES `detection` WRITE;
/*!40000 ALTER TABLE `detection` DISABLE KEYS */;
/*!40000 ALTER TABLE `detection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lightcurve`
--

DROP TABLE IF EXISTS `lightcurve`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lightcurve` (
  `lightcurveid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `firstalertid` int(10) unsigned NOT NULL,
  `maxalertid` int(10) unsigned NOT NULL,
  `tstart` double NOT NULL,
  `tstop` double NOT NULL,
  `seqnum` int(11) NOT NULL,
  PRIMARY KEY (`lightcurveid`),
  KEY `spot6_firstalertid` (`firstalertid`),
  KEY `spot6_maxalertid` (`maxalertid`),
  CONSTRAINT `spot6_lightcurveibfk1` FOREIGN KEY (`firstalertid`) REFERENCES `alert` (`alertid`) ON DELETE CASCADE,
  CONSTRAINT `spot6_lightcurveibfk2` FOREIGN KEY (`maxalertid`) REFERENCES `alert` (`alertid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lightcurve`
--

LOCK TABLES `lightcurve` WRITE;
/*!40000 ALTER TABLE `lightcurve` DISABLE KEYS */;
/*!40000 ALTER TABLE `lightcurve` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-08-08 12:10:38
