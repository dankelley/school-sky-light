import socket
import serial
from time import sleep, time
from string import atoi
import sys
sys.path.append("../")
import secret

# FIXME: database work
if 6 != len(sys.argv):
    print "Usage examples:"
    print "  python " + sys.argv[0] +  " 1 10 60 /dev/tty.usbmodem411    /Users/kelley/Sites/skyview/skyview.db"
    print "  python " + sys.argv[0] +  " 1 10 60 /dev/tty.usbmodemfa2131 /Users/kelley/Sites/skyview/skyview.db"
    print "(meaning: station secret-index code, sample every 10s, report every 60s, sensor on named /dev, local store db)"
    exit(2)
secret_station_id = atoi(sys.argv[1])
if (secret_station_id >= len(secret.station_id)):
    print "no such station"
    exit(2)
this_station_id = secret.station_id[secret_station_id]
this_station_code = secret.station_code[secret_station_id]
sampling_interval = atoi(sys.argv[2])
reporting_interval = atoi(sys.argv[3])
usb = sys.argv[4]
db = sys.argv[5]
def meanstd(x):
    from math import sqrt
    n, mean, std = len(x), 0, 0
    for a in x:
        mean = mean + a
    mean = mean / float(n)
    for a in x:
        std = std + (a - mean)**2
    std = sqrt(std / float(n-1))
    return mean, std

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
baud = 9600
ser = serial.Serial(usb, baud)
ser.write('>')
sleep(0.1)
first_newline = True
cbuf = ""
max = int(round(reporting_interval / sampling_interval))
times = []
values = []
while (True):
    sleep(0.01) # perhaps this is good for avoiding overtalking?
    c = ser.read(1)
    if len(c) > 0:
        if c == '\n':
            if first_newline:
                first_newline = False
            else:
                values.append(atoi(cbuf))
                times.append(time())
                if len(values) == max:
                    light_mean, light_stdev = meanstd(values)
                    time_mean, time_stdev = meanstd(times)
                    #print int(round(time_mean)), int(round(light_mean)), int(round(light_stdev))
                    msg = "%d %4s %d %d %d" % (this_station_id, this_station_code, int(round(time_mean)), int(round(light_mean)), int(round(light_stdev)))
                    print msg
                    sock.sendto(msg, (secret.aggregator_ip, secret.aggregator_port))
                    times = []
                    values = []
            ser.write('>')
            sleep(sampling_interval)
            cbuf = ""
        else:
            cbuf = cbuf + c
