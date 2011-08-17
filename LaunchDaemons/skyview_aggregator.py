import sys
import socket
import datetime
import sqlite3
import skyview_secret
DEBUG = False

# Find list of allowed stations.
conn = sqlite3.connect(skyview_secret.db)
if not conn:
    print 'cannot open database'
    exit(2)
curr = conn.cursor()
valid_station_id = [x[0] for x in curr.execute("""select id from stations""")]
valid_station_code = [x[0] for x in curr.execute("""select code from stations""")]
if DEBUG:
    print "valid station ID:", valid_station_id
    print "valid station code:", valid_station_code

# Open communication to UDP, on secret ip address and port number
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
if DEBUG:
    print "ip:", skyview_secret.aggregator_ip
    print "port:", skyview_secret.aggregator_port
sock.bind((skyview_secret.aggregator_ip, skyview_secret.aggregator_port))

while True:
    # limit size in case we're being attacked; 31 is OK here, for under 1000 stations and 4-byte code
    data, addr = sock.recvfrom(32)
    if DEBUG:
        print "received message: \"", data, "\" from", addr, "at time", datetime.datetime.now()
    station_id, station_code, time, light_mean, light_stddev = data.split(' ')
    station_id = int(station_id)
    time = int(time)
    light_mean = int(light_mean)
    light_stddev = int(light_stddev)
    if DEBUG:
        print "station_id:", station_id
        print "station_code:", station_code
    try:
        index = valid_station_id.index(station_id)
        if station_code == valid_station_code[index]:
            sql = """insert into observations(station_id,time,light_mean,light_stddev) VALUES (%d,%d,%d,%d)""" % (station_id, time, light_mean, light_stddev)
            if DEBUG:
                print sql
            curr.execute(sql)
            conn.commit()
        else:
            print "invalid code %s for station with id %d" % (code, id)
            pass
    except:
        print "station %d is not on file" % station_id
        pass

