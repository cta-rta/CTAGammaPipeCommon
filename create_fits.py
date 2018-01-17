# Copyright (c) 2017, AGILE team
# Authors: Nicolo' Parmiggiani <nicolo.parmiggiani@gmail.com>,
#
# Any information contained in this software is property of the AGILE TEAM
# and is strictly private and confidential. All rights reserved.


import sys
import mysql.connector as mysql
from conf import get_pipedb_conf
from conf import get_evtdb_conf
from GammaPipeCommon import utility
import numpy as np
from numpy import rec
#from pyfits import Column
import os
from astropy.time import Time
from astropy.coordinates import SkyCoord
from astropy.io import fits

# create FITS with event in time window from observation
def write_fits(tstart,tstop,observationid,path_base_fits):

    tstart = float(tstart)
    tstop = float(tstop)

    #connect to database
    conf_dictionary = get_pipedb_conf()

    pipedb_hostname = conf_dictionary['host']
    pipedb_username = conf_dictionary['username']
    pipedb_password = conf_dictionary['password']
    pipedb_port = conf_dictionary['port']
    pipedb_database = conf_dictionary['database']

    #connect to database
    conf_dictionary = get_evtdb_conf()

    evtdb_hostname = conf_dictionary['host']
    evtdb_username = conf_dictionary['username']
    evtdb_password = conf_dictionary['password']
    evtdb_port = conf_dictionary['port']
    evtdb_database = conf_dictionary['database']

    # get events list
    conn = mysql.connect(host=evtdb_hostname, user=evtdb_username, passwd=evtdb_password, db=evtdb_database)
    cursor = conn.cursor(dictionary=True)


    cursor.execute("SELECT * FROM streaming_evt WHERE TIME_REAL_TT > "+str(tstart)+" AND TIME_REAL_TT < "+str(tstop)+" AND OBS_ID = "+str(observationid))

    events = cursor.fetchall()

    cursor.close()
    conn.close()

    #get observation info
    conn = mysql.connect(host=pipedb_hostname, user=pipedb_username, passwd=pipedb_password, db=pipedb_database)
    cursor = conn.cursor(dictionary=True)

    #get observation info
    cursor.execute("SELECT * FROM observation_parameters WHERE observationid = "+str(observationid))

    observation_parameters = cursor.fetchone()

    cursor.close()
    conn.close()

    hdulist = fits.open(path_base_fits)

    primary_hdu = hdulist[0]

    events_hdu = hdulist[1]


    #convert time from TT to MJD REF CTA
    tref_mjd = observation_parameters['timerefstart']

    for x in events:
        time_real_mjd = Utility.convert_tt_to_mjd(x['TIME_REAL_TT'])
        x['TIME_REAL_TT'] = str(float(time_real_mjd)-float(tref_mjd))*86400

    # CREATE EVENTS data table HDU

    c_e_1 = fits.Column(name = 'EVENT_ID', format = '1J', bscale = 1, bzero = 2147483648, array=np.array([x['EVT_ID'] for x in events]))
    c_e_2 = fits.Column(name = 'TIME',format = '1D', unit = 's', array=np.array([x['TIME_REAL_TT'] for x in events]))
    c_e_3 = fits.Column(name = 'RA',format = '1E', unit = 'deg', array=np.array([x['RA'] for x in events]))
    c_e_4 = fits.Column(name = 'DEC', format = '1E', unit = 'deg', array=np.array([x['DEC'] for x in events]))
    c_e_5 = fits.Column(name = 'ENERGY', format = '1E', unit = 'TeV', array=np.array([x['ENERGY'] for x in events]))
    c_e_6 = fits.Column(name = 'DETX', format = '1E', unit = 'deg', array=np.array([x['DETX'] for x in events]))
    c_e_7 = fits.Column( name = 'DETY', format = '1E', unit = 'deg', array=np.array([x['DETY'] for x in events]))
    c_e_8 = fits.Column(name = 'MC_ID', format = '1J', array=np.array([x['MC_ID'] for x in events]))

    coldefs = fits.ColDefs([c_e_1, c_e_2,c_e_3,c_e_4,c_e_5,c_e_6,c_e_7,c_e_8])

    data_tbhdu = fits.BinTableHDU.from_columns(coldefs)
    data_tbhdu.header = hdulist[1].header

    #convert coordinate from galactic to celestial (icrs)
    obs_gal_coord = SkyCoord(observation_parameters['lon'],observation_parameters['lat'], unit='deg', frame='galactic')

    #print obs_gal_coord
    obs_icrs_coord = obs_gal_coord.icrs

    #print obs_icrs_coord

    obs_ra = "{0:.4f}".format(obs_icrs_coord.ra.degree)
    obs_dec = "{0:.4f}".format(obs_icrs_coord.dec.degree)

    #print obs_ra
    #print obs_dec

    #change header content
    data_tbhdu.header['NAXIS2'] = len(events)
    data_tbhdu.header['DSVAL2'] = str(observation_parameters['emin'])+":"+str(observation_parameters['emax'])
    data_tbhdu.header['DSVAL3'] = "CIRCLE("+obs_ra+","+obs_dec+","+str(observation_parameters['fov'])+")"
    data_tbhdu.header['MMN00001'] = "None"
    data_tbhdu.header['MMN00002'] = "None"
    data_tbhdu.header['TELESCOP'] = str(observation_parameters['name'])
    data_tbhdu.header['OBS_ID'] = str(observationid)

    # # time_second/86400 + 51544.5 = time_mjd
    # tstart_mjd = str(float(tstart)/86400 + 51544.5)
    # tstop_mjd = str(float(tstop)/86400 + 51544.5)
    # print tstart_mjd
    # print tstop_mjd
    # # UTC timescale
    # tstart_astropy = Time(tstart_mjd, format='mjd')
    # tstop_astropy = Time(tstop_mjd, format='mjd')
    #
    # #convert to ISO
    # tstart_astropy = tstart_astropy.iso
    # tstop_astropy = tstop_astropy.iso

    #date time
    data_tbhdu.header['DATE_OBS'] = ""
    data_tbhdu.header['TIME_OBS'] = ""
    data_tbhdu.header['DATE_END'] = ""
    data_tbhdu.header['TIME_END'] = ""
    data_tbhdu.header['TSTART'] = str(tstart)
    data_tbhdu.header['TSTOP'] = str(tstop)

    refint,refdecimal = int(tref_mjd),tref_mjd-int(tref_mjd)

    data_tbhdu.header['MJDREFI'] = str(refint)
    data_tbhdu.header['MJDREFF'] = str(refdecimal)

    data_tbhdu.header['TELAPSE'] = str(tstop-tstart)
    data_tbhdu.header['ONTIME'] = str(tstop-tstart)
    data_tbhdu.header['LIVETIME'] = str(tstop-tstart)
    data_tbhdu.header['DEADC'] = "1"
    data_tbhdu.header['TIMEDEL'] = "1"

    data_tbhdu.header['RA_PNT'] = obs_ra
    data_tbhdu.header['DEC_PNT'] = obs_dec

    # CREATE GTI data table HDU

    gti_tstart = np.array([tstart])
    gti_tstop = np.array([tstop])
    c1 = fits.Column(name='START', format='1D', array=gti_tstart)
    c2 = fits.Column(name='STOP', format='1D', array=gti_tstop)
    coldefs = fits.ColDefs([c1, c2])

    gti_tbhdu = fits.BinTableHDU.from_columns(coldefs)
    gti_tbhdu.header = hdulist[2].header

    thdulist = fits.HDUList([primary_hdu,data_tbhdu,gti_tbhdu])

    filename = "obs_"+str(observationid)+"_"+str(tstart)+"_"+str(tstop)+".fits"
    if os.path.exists(filename):
        os.unlink(filename)
    thdulist.writeto(filename)

    hdulist_new = fits.open(filename)

    #print hdulist_new[2].header

    hdulist_new.close()


if __name__ == '__main__':

    # crete the XML for the specific observation
    tstart = sys.argv[1]
    tstop = sys.argv[2]
    observationid = sys.argv[3]
    path_base_fits = "templates/base_empty.fits"

    write_fits(tstart,tstop,observationid,path_base_fits)
