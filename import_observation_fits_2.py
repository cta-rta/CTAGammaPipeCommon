# ==========================================================================
# Import fits file in database
#
# Copyright (C) 2018 Giovanni De Cesare
#
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

from conf import get_evtdb_conf
from astropy.io import fits
import mysql.connector as mysql
import sys
#from datetime import datetime

author = "Giovanni De Cesare"
date = "2018-01-22"

def info():
    """
    Description: Print infos

    Usage: info()
    """
    print("Some tool to write CTA event files into mysql db")
    print("Author: " + author)
    print("Date: " + date)

def import_observation_fits(fits_file,observationid,datarepositoryid):
    """
    Description: insert lines into the database

    Usage: import_observation_fits(fits_file,observationid,datarepositoryid)
    """
    event_batch_number = 5000

    #print("open fits")
    #print(datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3])

    # Read the fit file
    hdulist = fits.open(fits_file)
    tbdata = hdulist[1].data
    print("no of elements: " +  str(len(tbdata)))

    #connect to evt database
    conf_dictionary = get_evtdb_conf()

    evtdb_hostname = conf_dictionary['host']
    evtdb_username = conf_dictionary['username']
    evtdb_password = conf_dictionary['password']
    evtdb_database = conf_dictionary['database']

    conn_evt_db = mysql.connect(host=evtdb_hostname, user=evtdb_username, passwd=evtdb_password, db=evtdb_database)
    cursor_evt_db = conn_evt_db.cursor(dictionary=True)

    count = 0
    timestart = 0

    print("start for")
    #print(datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3])

    insert_query = ""

    #for each event create execute statement
    for event in tbdata:


        if(count == 0):
            #conn_evt_db.commit()
            insert_query = "INSERT INTO evt3 (eventidfits,observationid,datarepositoryid,time,ra_deg,dec_deg,energy,detx,dety,mcid,status) VALUES "
        if(count == event_batch_number):
            count = 0
            #print(insert_query)
            cursor_evt_db.execute(insert_query)
            conn_evt_db.commit()
            insert_query = "INSERT INTO evt3 (eventidfits,observationid,datarepositoryid,time,ra_deg,dec_deg,energy,detx,dety,mcid,status) VALUES "
        elif(count != 0):
            insert_query += ","

        if(timestart == 0):
            timestart = float(event[1])

        eventidfits = str(event[0])
        time = str(float(event[1])-timestart)
        ra = str(event[2])
        dec = str(event[3])
        energy = str(event[4])
        detx = str(event[5])
        dety = str(event[6])
        mc_id = str(event[7])

        insert_query += " ("+eventidfits+","+observationid+","+datarepositoryid+","+time+","+ra+","+dec+","+energy+","+detx+","+dety+","+mc_id+",0)"
        count = count + 1

    #commit last event
    cursor_evt_db.execute(insert_query)
    conn_evt_db.commit()

    print("finish for")

    #close connections
    cursor_evt_db.close()
    conn_evt_db.close()

if __name__ == '__main__':

    filename = sys.argv[1]
    obs_id = sys.argv[2]
    datarepositoryid = sys.argv[3]

    import_observation_fits(filename,obs_id,datarepositoryid)
