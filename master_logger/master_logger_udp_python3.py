import socket
import serial
from time import sleep, time
from sys import argv, exit
UDP_IP="129.173.23.36" # emit.phys.ocean.dal.ca
UDP_PORT=5005
sensor_code=1
# FIXME: udp work
# FIXME: database work
if 5 != len(argv):
    print("Usage examples:")
    print("  python " + argv[0] +  " 10 60 /dev/tty.usbmodem411    /Users/kelley/Sites/skyview/skyview.db")
    print("  python " + argv[0] +  " 10 60 /dev/tty.usbmodemfa2131 /Users/kelley/Sites/skyview/skyview.db")
    exit(2)
sampling_interval = int(argv[1])
reporting_interval = int(argv[2])
usb = argv[3]
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
                values.append(int(cbuf))
                times.append(time())
                if len(values) == max:
                    light_mean, light_stdev = meanstd(values)
                    time_mean, time_stdev = meanstd(times)
                    #print int(round(time_mean)), int(round(light_mean)), int(round(light_stdev))
                    msg = "%d %d %d %d" % (sensor_code, int(round(time_mean)), int(round(light_mean)), int(round(light_stdev)))
                    sock.sendto(msg, (UDP_IP, UDP_PORT))
                    times = []
                    values = []
            ser.write('>')
            sleep(sampling_interval)
            cbuf = ""
        else:
            cbuf = cbuf + c
