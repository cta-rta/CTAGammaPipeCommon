# ==========================================================================
#
#
# Copyright (C) 2018 Nicolò Parmiggiani <nicolo.parmiggiani@inaf.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# ==========================================================================

INSERT INTO timereftype (timereftypeid,name,unit) VALUES (1,'mjd','day');
INSERT INTO timereftype (timereftypeid,name,unit) VALUES (2,'tt','s');

INSERT INTO skyreftype (skyreftypeid,name,unit) VALUES (1,'galactic','deg');
INSERT INTO skyreftype (skyreftypeid,name,unit) VALUES (2,'fk5','deg');

INSERT INTO energyreftype (energyreftypeid,name) VALUES (0,'Not Specified');
INSERT INTO energyreftype (energyreftypeid,name) VALUES (1,'MeV');
INSERT INTO energyreftype (energyreftypeid,name) VALUES (2,'TeV');

INSERT INTO instrument (instrumentid,name,fov) VALUES (0,'TEST',NULL);
INSERT INTO instrument (instrumentid,name,fov) VALUES (1,'FERMI_GBM',NULL);
INSERT INTO instrument (instrumentid,name,fov) VALUES (2,'FERMI_LAT',NULL);
INSERT INTO instrument (instrumentid,name,fov) VALUES (3,'SWIFT',NULL);
INSERT INTO instrument (instrumentid,name,fov) VALUES (4,'AGILE_GRID',180);
INSERT INTO instrument (instrumentid,name,fov) VALUES (5,'AGILE_MCAL',180);
INSERT INTO instrument (instrumentid,name,fov) VALUES (6,'AGILE_SA',180);
INSERT INTO instrument (instrumentid,name,fov) VALUES (7,'LIGO',NULL);
INSERT INTO instrument (instrumentid,name,fov) VALUES (8,'ICECUBE',NULL);
INSERT INTO instrument (instrumentid,name,fov) VALUES (9,'AGILE',180);
INSERT INTO instrument (instrumentid,name,fov,irf,caldb) VALUES (10,'CTA-SOUTH',5,'North_0.5h','prod2');
INSERT INTO instrument (instrumentid,name,fov,irf,caldb) VALUES (11,'CTA-NORTH',5,'South_0.5h','prod2');


INSERT INTO network (networkid,name,external) VALUES (0,'TEST',0);
INSERT INTO network (networkid,name,external) VALUES (1,'GCN',1);
INSERT INTO network (networkid,name,external) VALUES (2,'AGILEPIPE',0);
INSERT INTO network (networkid,name,external) VALUES (3,'MANUAL',0);

INSERT INTO energybingroup (energybingroupid,shortname,description,energyreftypeid) VALUES (1,'fullband','Full Band',1);

INSERT INTO energybin (energybinid,energybingroupid,emin,emax) VALUES (1,1,0,10000);

INSERT INTO datalevel (datalevelid,name) VALUES (1,"DL3");

INSERT INTO `datatype` (`datatypeid`, `name`, `datalevelid`)
VALUES
	(1,'EVT3_CTA',1);

INSERT INTO `datarepository` (`datarepositoryid`, `datatypeid`, `category`, `name`, `description`, `active`)
VALUES
	(1,1,0,'EVT3_CTA','CTA repo of EVT3 files on database',1);

INSERT INTO `observation` (`observationid`, `tstartplanned`, `tendplanned`, `tstartreal`, `tendreal`, `status`, `fitspath`, `l`, `b`, `timereftypeid`, `skyreftypeid`, `name`)
VALUES

	(1,442800000,442808639.9999999,442800000,442808639.9999999,1,NULL,184.557449,-5.78436,1,2,'Crab'),
	(2,442800000,442808639.9999999,442800000,442808639.9999999,0,NULL,304.18,-0.99,1,2,'PSR B1259-63'),
	(3,442800000,442808639.9999999,442800000,442808639.9999999,0,NULL,280.306984,-32.784041,1,2,'LMC-N132D'),
	(4,442800000,442808639.9999999,442800000,442808639.9999999,0,NULL,350.37,-32.61,1,2,'PKS 2005-489');

INSERT INTO `observation_to_datarepository` (`datarepositoryid`, `observationid`, `tstartdata`, `tenddata`)
VALUES

	(1,1,0,0),
	(1,2,0,0),
	(1,3,0,0),
	(1,4,0,0);


INSERT INTO `analysistrigger` (`analysistriggerid`, `name`, `shortname`, `category`, `triggersourcedatarepositoryid`, `triggersourcedatarepositoryidinstrumentid`, `triggersourcesciencealertinstrumentid`, `basedirresults`, `basedirrun`, `status`)
VALUES
	(1,'CTA_SOUTH_EVT3DB','',0,1,10,NULL,'/ANALYSIS3/','/ANALYSIS3/RUN/',1),
	(2,'','GBM-notice',0,NULL,NULL,1,'/ANALYSIS3/','/ANALYSIS3/RUN/',1);

INSERT INTO `dataprocessingtool` (`dataprocessingtoolid`, `name`, `module`, `sciencetool`, `skyreftypeid`, `timereftypeid`)
VALUES
    (1,'ctools','',1,2,1);

INSERT INTO `dataprocessingtool_datatype_input` (`dataprocessingtoolid`, `datatypeid`, `type`, `required`)
VALUES
  (1,1,1,1);


INSERT INTO `analysistype` (`analysistypeid`, `name`, `shortname`, `description`, `dataprocessingtoolid`, `intervaltype`, `metaconffile`, `task`, `deleterun`)
VALUES
	(1,'ctools-lc','ctools-lc',X'6D616B65204C437320776974682063746F6F6C730A',1,NULL,'<run id=\"#@runid@#\">\n	<parameter name=\"RegionOfInterest\" ra=\"#@ra@#\" dec=\"#@dec@#\" skypositiontype=\"#@skypositiontype@#\" radius=\"#@radius@#\" AlertContour=\"#@contour_name@#\" frame=\"#@skyrefname@#\" unit=\"#@skyrefunit@#\" />\n	<parameter name=\"TimeIntervals\" tmin=\"#@tstart@#\" tmax=\"#@tstop@#\" timeunit=\"#@timerefunit@#\" timesys=\"#@timerefname@#\" />\n	<parameter name=\"ScienceToolReference\" timestart=\"51544.5\" timeunit=\"day\" timesys=\"mjd\" timeref=\"LOCAL\" skyframe=\"fk5\" skyframeunit=\"deg\" />\n	<parameter name=\"Energy\" emin=\"#@emin@#\" emax=\"#@emax@#\" energyBinID=\"\" />\n	<parameter name=\"DirectoryList\" run=\"#@diroutputrun@#\" results=\"#@diroutputresults@#\" runprefix=\"#@runprefix@#\" />\n	<parameter name=\"WorkInMemory\" value=\"0\" />\n	<parameter name=\"MakeCtsMap\" value=\"1\" />\n	<parameter name=\"CountsMap\" enumbins=\"1\" nxpix=\"\" nypix=\"\" binsz=\"0.02\" coordsys=\"CEL\" proj=\"CAR\" ebinalg=\"LOG\" usepnt=\"no\" />\n	<parameter name=\"HypothesisGenerator3GH\" value=\"0\" />\n  	<parameter name=\"CtsMapToPng\" value=\"1\" />\n	<parameter name=\"DeleteRun\" value=\"0\" />\n	<parameter name=\"Binned\" value=\"0\" />\n</run>','echo $PYTHONPATH\ndate +\"%T.%N\"\npython $PIPELINE/ctoolsint/ExecuteCTools.py -anamodel target.xml -runconf run.xml -observation obs.xml\ndate +\"%T.%N\"\n',0),
	(2,'ctools_lc_0.1','ctools_lc_0.1',X'6C632D302E3162696E7A',1,NULL,'<run id=\"#@runid@#\">\n	<parameter name=\"RegionOfInterest\" ra=\"#@ra@#\" dec=\"#@dec@#\" skypositiontype=\"#@skypositiontype@#\" radius=\"#@radius@#\" AlertContour=\"#@contour_name@#\" frame=\"#@skyrefname@#\" unit=\"#@skyrefunit@#\" />\n	<parameter name=\"TimeIntervals\" tmin=\"#@tstart@#\" tmax=\"#@tstop@#\" timeunit=\"#@timerefunit@#\" timesys=\"#@timerefname@#\" />\n	<parameter name=\"ScienceToolReference\" timestart=\"51544.5\" timeunit=\"day\" timesys=\"mjd\" timeref=\"LOCAL\" skyframe=\"fk5\" skyframeunit=\"deg\" />\n	<parameter name=\"Energy\" emin=\"#@emin@#\" emax=\"#@emax@#\" energyBinID=\"\" />\n	<parameter name=\"DirectoryList\" run=\"#@diroutputrun@#\" results=\"#@diroutputresults@#\" runprefix=\"#@runprefix@#\" />\n	<parameter name=\"WorkInMemory\" value=\"0\" />\n	<parameter name=\"MakeCtsMap\" value=\"1\" />\n	<parameter name=\"CountsMap\" enumbins=\"1\" nxpix=\"\" nypix=\"\" binsz=\"0.1\" coordsys=\"CEL\" proj=\"CAR\" ebinalg=\"LOG\" usepnt=\"no\" />\n	<parameter name=\"HypothesisGenerator3GH\" value=\"0\" />\n  	<parameter name=\"CtsMapToPng\" value=\"1\" />\n	<parameter name=\"DeleteRun\" value=\"0\" />\n</run>','echo $PYTHONPATH\ndate +\"%T.%N\"\npython $PIPELINE/ctoolsint/ExecuteCTools.py -anamodel target.xml -runconf run.xml -observation obs.xml\ndate +\"%T.%N\"\n',0),
	(3,'ctools_lc_0.2','ctools_lc_0.2',X'6C632D302E3262696E7A',1,NULL,'<run id=\"#@runid@#\">\n	<parameter name=\"RegionOfInterest\" ra=\"#@ra@#\" dec=\"#@dec@#\" skypositiontype=\"#@skypositiontype@#\" radius=\"#@radius@#\" AlertContour=\"#@contour_name@#\" frame=\"#@skyrefname@#\" unit=\"#@skyrefunit@#\" />\n	<parameter name=\"TimeIntervals\" tmin=\"#@tstart@#\" tmax=\"#@tstop@#\" timeunit=\"#@timerefunit@#\" timesys=\"#@timerefname@#\" />\n	<parameter name=\"ScienceToolReference\" timestart=\"51544.5\" timeunit=\"day\" timesys=\"mjd\" timeref=\"LOCAL\" skyframe=\"fk5\" skyframeunit=\"deg\" />\n	<parameter name=\"Energy\" emin=\"#@emin@#\" emax=\"#@emax@#\" energyBinID=\"\" />\n	<parameter name=\"DirectoryList\" run=\"#@diroutputrun@#\" results=\"#@diroutputresults@#\" runprefix=\"#@runprefix@#\" />\n	<parameter name=\"WorkInMemory\" value=\"0\" />\n	<parameter name=\"MakeCtsMap\" value=\"1\" />\n	<parameter name=\"CountsMap\" enumbins=\"1\" nxpix=\"\" nypix=\"\" binsz=\"0.2\" coordsys=\"CEL\" proj=\"CAR\" ebinalg=\"LOG\" usepnt=\"no\" />\n	<parameter name=\"HypothesisGenerator3GH\" value=\"0\" />\n  	<parameter name=\"CtsMapToPng\" value=\"1\" />\n	<parameter name=\"DeleteRun\" value=\"0\" />\n</run>','echo $PYTHONPATH\ndate +\"%T.%N\"\npython $PIPELINE/ctoolsint/ExecuteCTools.py -anamodel target.xml -runconf run.xml -observation obs.xml\ndate +\"%T.%N\"\n',0),
	(4,'ctools_lc_0.5','ctools_lc_0.5',X'6C632D302E3562696E7A',1,NULL,'<run id=\"#@runid@#\">\n	<parameter name=\"RegionOfInterest\" ra=\"#@ra@#\" dec=\"#@dec@#\" skypositiontype=\"#@skypositiontype@#\" radius=\"#@radius@#\" AlertContour=\"#@contour_name@#\" frame=\"#@skyrefname@#\" unit=\"#@skyrefunit@#\" />\n	<parameter name=\"TimeIntervals\" tmin=\"#@tstart@#\" tmax=\"#@tstop@#\" timeunit=\"#@timerefunit@#\" timesys=\"#@timerefname@#\" />\n	<parameter name=\"ScienceToolReference\" timestart=\"51544.5\" timeunit=\"day\" timesys=\"mjd\" timeref=\"LOCAL\" skyframe=\"fk5\" skyframeunit=\"deg\" />\n	<parameter name=\"Energy\" emin=\"#@emin@#\" emax=\"#@emax@#\" energyBinID=\"\" />\n	<parameter name=\"DirectoryList\" run=\"#@diroutputrun@#\" results=\"#@diroutputresults@#\" runprefix=\"#@runprefix@#\" />\n	<parameter name=\"WorkInMemory\" value=\"0\" />\n	<parameter name=\"MakeCtsMap\" value=\"1\" />\n	<parameter name=\"CountsMap\" enumbins=\"1\" nxpix=\"\" nypix=\"\" binsz=\"0.5\" coordsys=\"CEL\" proj=\"CAR\" ebinalg=\"LOG\" usepnt=\"no\" />\n	<parameter name=\"HypothesisGenerator3GH\" value=\"0\" />\n  	<parameter name=\"CtsMapToPng\" value=\"1\" />\n	<parameter name=\"DeleteRun\" value=\"0\" />\n</run>','echo $PYTHONPATH\ndate +\"%T.%N\"\npython $PIPELINE/ctoolsint/ExecuteCTools.py -anamodel target.xml -runconf run.xml -observation obs.xml\ndate +\"%T.%N\"\n',0),
	(5,'ctools-lc-b','ctools-lc-b',X'6D616B65204C437320776974682063746F6F6C732062696E6E65640A',1,NULL,'<run id=\"#@runid@#\">\n	<parameter name=\"RegionOfInterest\" ra=\"#@ra@#\" dec=\"#@dec@#\" skypositiontype=\"#@skypositiontype@#\" radius=\"#@radius@#\" AlertContour=\"#@contour_name@#\" frame=\"#@skyrefname@#\" unit=\"#@skyrefunit@#\" />\n	<parameter name=\"TimeIntervals\" tmin=\"#@tstart@#\" tmax=\"#@tstop@#\" timeunit=\"#@timerefunit@#\" timesys=\"#@timerefname@#\" />\n	<parameter name=\"ScienceToolReference\" timestart=\"51544.5\" timeunit=\"day\" timesys=\"mjd\" timeref=\"LOCAL\" skyframe=\"fk5\" skyframeunit=\"deg\" />\n	<parameter name=\"Energy\" emin=\"#@emin@#\" emax=\"#@emax@#\" energyBinID=\"\" />\n	<parameter name=\"DirectoryList\" run=\"#@diroutputrun@#\" results=\"#@diroutputresults@#\" runprefix=\"#@runprefix@#\" />\n	<parameter name=\"WorkInMemory\" value=\"0\" />\n	<parameter name=\"MakeCtsMap\" value=\"1\" />\n	<parameter name=\"CountsMap\" enumbins=\"1\" nxpix=\"\" nypix=\"\" binsz=\"0.02\" coordsys=\"CEL\" proj=\"CAR\" ebinalg=\"LOG\" usepnt=\"no\" />\n	<parameter name=\"HypothesisGenerator3GH\" value=\"0\" />\n  	<parameter name=\"CtsMapToPng\" value=\"1\" />\n	<parameter name=\"DeleteRun\" value=\"0\" />\n	<parameter name=\"Binned\" value=\"1\" />\n</run>','echo $PYTHONPATH\ndate +\"%T.%N\"\npython $PIPELINE/ctoolsint/ExecuteCTools.py -anamodel target.xml -runconf run.xml -observation obs.xml\ndate +\"%T.%N\"\n',0);


INSERT INTO `postanalysis` (`postanalysisid`, `name`, `shortname`, `ncpu`, `task`, `metaconffile`, `queue`, `reservation`, `type`)
VALUES
	(1,'postanalysis','pa',1,'date +\"%T.%N\"\npython $PIPELINE/ctoolsint/PostAnalysis.py session.xml\ndate +\"%T.%N\"\n#echo $PWD >> /tmp/history_postanalysis','<session id=\"#@analysissessionid@#\" runid=\"#@runid@#\" >\n        <parameter name=\"postanalysis\" value=\"copyfiles\" />\n        <parameter name=\"DirectoryList\" results=\"#@diroutputresults@#\" />\n        <parameter name=\"WebImage\" value=\"1\" dir=\"/ANALYSIS3/web/\" />\n        <parameter name=\"TimeLine\" value=\"1\" dir=\"/ANALYSIS3/timeline/\" />\n</session>','fast','fast_rt',1),
	(2,'post_analysis_notice','Pa_notice',1,'python $PIPELINE/ctoolsint/ExecuteCTools.py -postanalysis session.xml\n\necho $PWD >> /tmp/history_postanalysis','<session id=\"#@analysissessionid@#\" runid=\"#@runid@#\" >\n        <parameter name=\"postanalysis\" value=\"copyfiles\" />\n        <parameter name=\"DirectoryList\" results=\"#@diroutputresults@#\" />\n        <parameter name=\"WebImage\" value=\"1\" dir=\"/ANALYSIS3/web/\" />\n        <parameter name=\"TimeLine\" value=\"1\" dir=\"/ANALYSIS3/timeline/\" />\n</session>','fast','fast_rt',0),
	(3,'postanalysis_noprec','pa_noprec',1,'date +\"%T.%N\"\npython $PIPELINE/ctoolsint/PostAnalysis.py session.xml\ndate +\"%T.%N\"\n#echo $PWD >> /tmp/history_postanalysis','<session id=\"#@analysissessionid@#\" runid=\"#@runid@#\" >\n        <parameter name=\"postanalysis\" value=\"copyfiles\" />\n        <parameter name=\"DirectoryList\" results=\"#@diroutputresults@#\" />\n        <parameter name=\"WebImage\" value=\"1\" dir=\"/ANALYSIS3/web/\" />\n        <parameter name=\"TimeLine\" value=\"1\" dir=\"/ANALYSIS3/timeline/\" />\n</session>','fast','fast_rt',0);


  INSERT INTO `analysissessiontype` (`analysissessiontypeid`, `name`, `shortname`, `aggregation`, `description`, `analysistypeid`, `analysistriggerid`, `deltatstart`, `deltatstop`, `timebinsize`, `minbinsize`, `maxbinsize`, `timestep`, `runnable`, `queue`, `reservation`, `energybingroupid`, `skypositiontype`, `skyringgroupid`, `analysisradius`, `postanalysisid`)
  VALUES
  	(1,'','LC10s',1,'LC10s',1,1,0,0,10,10,0,10,0,'large','large_rt',1,1,NULL,5,1),
  	(2,'','LC10s-alert',1,'RT01d',1,2,-100,100,200,50,200,200,0,'fast','fast_rt',1,1,1,5,1),
  	(3,'','RT20s-alert',1,'RT100s',1,2,-100,100,200,200,0,200,0,'fast','fast_rt',1,1,NULL,5,NULL),
  	(4,'','LC1000s',1,'LC1000s',1,1,0,0,1000,1000,0,1000,0,'large','large_rt',1,1,NULL,5,1),
  	(5,'','LC100s',1,'LC100s',1,1,0,0,100,100,0,100,0,'large','large_rt',1,1,NULL,5,1),
  	(6,'','LC200s-ring',1,'200s-ring',1,1,0,0,200,200,0,200,0,'large','large_rt',1,10,1,29.3162,1),
  	(7,'','LC100s-alert',1,'100s-alert',1,2,-500,500,100,100,0,100,0,'fast','fast_rt',1,1,NULL,5,1),
  	(8,'','LC300-shift10',1,'LC300-shift10',1,1,0,0,300,300,0,10,0,'large','large_rt',1,1,NULL,5,1),
  	(9,'','LC-flexible',1,'LC-flexible',1,1,0,0,-1,0,0,0,0,'large','large_rt',1,1,NULL,5,1),
  	(10,'','LC1000-shift10',1,'LC1000-shift10',1,1,0,0,1000,1000,0,10,1,'large','large_rt',1,1,NULL,5,1),
  	(11,'','LC1000-shift20',1,'LC1000-shift20',1,1,0,0,1000,1000,0,20,0,'large','large_rt',1,1,NULL,5,1),
  	(12,'','LC1000-shift10-ant2',1,'LC1000-shift10',2,1,0,0,1000,1000,0,10,0,'large','large_rt',1,1,NULL,5,1),
  	(13,'','LC1000-shift10-ant3',1,'LC1000-shift10',3,1,0,0,1000,1000,0,10,0,'large','large_rt',1,1,NULL,5,1),
  	(14,'','LC1000-shift10-ant4',1,'LC1000-shift10',4,1,0,0,1000,1000,0,10,0,'large','large_rt',1,1,NULL,5,1),
  	(15,'','LC1000-shift10-b',1,'LC1000-shift10-b',5,1,0,0,1000,1000,0,10,0,'large','large_rt',1,1,NULL,5,1);


INSERT INTO proposal (proposalid,description) VALUES (1,"Crab observation");

INSERT INTO `observingmode` (`observingmodeid`, `instrumentid`, `zenithangle`, `minskyquality`, `minnsb`, `maxnsb`)
VALUES
  (1,10,NULL,NULL,NULL,NULL),
  (2,11,NULL,NULL,NULL,NULL);

INSERT INTO `target` (`targetid`, `targetcode`, `proposalid`, `observingmodeid`, `name`, `l`, `b`, `xmlmodel`, `emin`, `emax`)
VALUES

	(1,1,1,1,'Crab',184.557449,-5.78436,'<?xml version=\"1.0\" standalone=\"no\"?>\n<source_library title=\"source library\">\n  <source name=\"Crab\" type=\"PointSource\" tscalc=\"1\">\n    <spectrum type=\"PowerLaw\">\n       <parameter name=\"Prefactor\"   scale=\"1e-16\" value=\"5.7\"  min=\"1e-07\" max=\"1000.0\" free=\"1\"/>\n       <parameter name=\"Index\"       scale=\"-1\"    value=\"2.48\" min=\"0.0\"   max=\"+5.0\"   free=\"1\"/>\n       <parameter name=\"PivotEnergy\" scale=\"1e6\"   value=\"0.3\"  min=\"0.01\"  max=\"1000.0\" free=\"0\"/>\n    </spectrum>\n    <spatialModel type=\"PointSource\">\n      <parameter name=\"RA\"  scale=\"1.0\" value=\"83.6331\" min=\"-360\" max=\"360\" free=\"0\"/>\n      <parameter name=\"DEC\" scale=\"1.0\" value=\"22.0145\" min=\"-90\"  max=\"90\"  free=\"0\"/>\n    </spatialModel>\n  </source>\n  <source name=\"CTABackgroundModel\" type=\"CTAIrfBackground\" instrument=\"CTA-SOUTH\">\n    <spectrum type=\"PowerLaw\">	\n      <parameter name=\"Prefactor\"   scale=\"1.0\"  value=\"1.0\"  min=\"1e-3\" max=\"1e+3\"   free=\"1\"/>	\n      <parameter name=\"Index\"       scale=\"1.0\"  value=\"0.0\"  min=\"-5.0\" max=\"+5.0\"   free=\"1\"/>\n      <parameter name=\"PivotEnergy\" scale=\"1e6\"  value=\"1.0\"  min=\"0.01\" max=\"1000.0\" free=\"0\"/>\n    </spectrum>\n  </source>	\n</source_library>\n',0.1,100),
	(2,2,1,1,'PSR B1259-63',304.18,-0.99,'<?xml version=\"1.0\" standalone=\"no\"?>\n<source_library title=\"source library\">\n  <source name=\"Crab\" type=\"PointSource\" tscalc=\"1\">\n    <spectrum type=\"PowerLaw\">\n       <parameter name=\"Prefactor\"   scale=\"1e-16\" value=\"10\"  min=\"1e-07\" max=\"1000.0\" free=\"1\"/>\n       <parameter name=\"Index\"       scale=\"-1\"    value=\"2.48\" min=\"0.0\"   max=\"+5.0\"   free=\"1\"/>\n       <parameter name=\"PivotEnergy\" scale=\"1e6\"   value=\"0.3\"  min=\"0.01\"  max=\"1000.0\" free=\"0\"/>\n    </spectrum>\n    <spatialModel type=\"PointSource\">\n      <parameter name=\"RA\"  scale=\"1.0\" value=\"195.698554\" min=\"-360\" max=\"360\" free=\"1\"/>\n      <parameter name=\"DEC\" scale=\"1.0\" value=\"-63.835732\" min=\"-90\"  max=\"90\"  free=\"1\"/>\n    </spatialModel>\n  </source>\n  <source name=\"CTABackgroundModel\" type=\"CTAIrfBackground\" instrument=\"CTA-SOUTH\">\n    <spectrum type=\"PowerLaw\">	\n      <parameter name=\"Prefactor\"   scale=\"1.0\"  value=\"1.0\"  min=\"1e-3\" max=\"1e+3\"   free=\"1\"/>	\n      <parameter name=\"Index\"       scale=\"1.0\"  value=\"0.0\"  min=\"-5.0\" max=\"+5.0\"   free=\"1\"/>\n      <parameter name=\"PivotEnergy\" scale=\"1e6\"  value=\"1.0\"  min=\"0.01\" max=\"1000.0\" free=\"0\"/>\n    </spectrum>\n  </source>	\n</source_library>',0.1,100),
	(3,3,1,1,'LMC-N132D',280.306984,-32.784041,'<?xml version=\"1.0\" standalone=\"no\"?>\n<source_library title=\"source library\">\n  <source name=\"Crab\" type=\"PointSource\" tscalc=\"1\">\n    <spectrum type=\"PowerLaw\">\n       <parameter name=\"Prefactor\"   scale=\"1e-16\" value=\"2\"  min=\"1e-07\" max=\"1000.0\" free=\"1\"/>\n       <parameter name=\"Index\"       scale=\"-1\"    value=\"2.48\" min=\"0.0\"   max=\"+5.0\"   free=\"1\"/>\n       <parameter name=\"PivotEnergy\" scale=\"1e6\"   value=\"0.3\"  min=\"0.01\"  max=\"1000.0\" free=\"0\"/>\n    </spectrum>\n    <spatialModel type=\"PointSource\">\n      <parameter name=\"RA\"  scale=\"1.0\" value=\"81.259167\" min=\"-360\" max=\"360\" free=\"1\"/>\n      <parameter name=\"DEC\" scale=\"1.0\" value=\"-69.644167\" min=\"-90\"  max=\"90\"  free=\"1\"/>\n    </spatialModel>\n  </source>\n  <source name=\"CTABackgroundModel\" type=\"CTAIrfBackground\" instrument=\"CTA-SOUTH\">\n    <spectrum type=\"PowerLaw\">	\n      <parameter name=\"Prefactor\"   scale=\"1.0\"  value=\"1.0\"  min=\"1e-3\" max=\"1e+3\"   free=\"1\"/>	\n      <parameter name=\"Index\"       scale=\"1.0\"  value=\"0.0\"  min=\"-5.0\" max=\"+5.0\"   free=\"1\"/>\n      <parameter name=\"PivotEnergy\" scale=\"1e6\"  value=\"1.0\"  min=\"0.01\" max=\"1000.0\" free=\"0\"/>\n    </spectrum>\n  </source>	\n</source_library>',0.1,100),
	(4,4,1,1,'PKS 2005-489',350.37,-32.61,'<?xml version=\"1.0\" standalone=\"no\"?>\n<source_library title=\"source library\">\n  <source name=\"Crab\" type=\"PointSource\" tscalc=\"1\">\n    <spectrum type=\"PowerLaw\">\n       <parameter name=\"Prefactor\"   scale=\"1e-16\" value=\"3.5\"  min=\"1e-07\" max=\"1000.0\" free=\"1\"/>\n       <parameter name=\"Index\"       scale=\"-1\"    value=\"2.48\" min=\"0.0\"   max=\"+5.0\"   free=\"1\"/>\n       <parameter name=\"PivotEnergy\" scale=\"1e6\"   value=\"0.3\"  min=\"0.01\"  max=\"1000.0\" free=\"0\"/>\n    </spectrum>\n    <spatialModel type=\"PointSource\">\n      <parameter name=\"RA\"  scale=\"1.0\" value=\"302.355795\" min=\"-360\" max=\"360\" free=\"1\"/>\n      <parameter name=\"DEC\" scale=\"1.0\" value=\"-48.831589\" min=\"-90\"  max=\"90\"  free=\"1\"/>\n    </spatialModel>\n  </source>\n  <source name=\"CTABackgroundModel\" type=\"CTAIrfBackground\" instrument=\"CTA-SOUTH\">\n    <spectrum type=\"PowerLaw\">	\n      <parameter name=\"Prefactor\"   scale=\"1.0\"  value=\"1.0\"  min=\"1e-3\" max=\"1e+3\"   free=\"1\"/>	\n      <parameter name=\"Index\"       scale=\"1.0\"  value=\"0.0\"  min=\"-5.0\" max=\"+5.0\"   free=\"1\"/>\n      <parameter name=\"PivotEnergy\" scale=\"1e6\"  value=\"1.0\"  min=\"0.01\" max=\"1000.0\" free=\"0\"/>\n    </spectrum>\n  </source>	\n</source_library>',0.1,100);


INSERT INTO observation_target (observationid,targetid) VALUES
(1,1),
(2,2),
(3,3),
(4,4);
