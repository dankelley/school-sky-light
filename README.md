# Concept

A darkening sky is a good indicator of the onset of bad weather.  We look up at
the sky to decide whether to run to the shelter, on an unsettled day.  Weather
forecasts do not address broad issues of weather variations over days and
hundreds of kilometers, but people have still rely on the sky for quick,
localized forecasts.  

A limitation of this observer-based forecasting is that even small-scale
weather patterns are not entirely localized.  Events such as fronts and
thunderstorms tend to sweep across regions, so that one neighborhood could warn
another of impending bad weather.

The idea of this project is to develop a network of skylight sensors that would
mimic the human eye, testing for darkening of the sky hour by hour, or even
minute by minute.  The network would need to cover populated areas in a
reasonable data density, say one sensor per square kilometre or so.  The
national weather service could do that in a professional way, probably at great
expense for equipment, networking, and maintenance. 

But there is another way-- put the sensors in schools.  Let the students build
the sensors, network them, write the code to integrate them, and perform
regular calibration and other maintenance.   Each of the steps would provide
students with fun, and good learning experiences.  Building the sensors would
help them to learn about the physics of light sensing and about the electronics
of data logging.  Networking and coding provide the chance to learn about
computing hardware and software.  And the maintenance would do two important
things.  First, it would continually reinforce the lessons about physics and
electronics, spreading the learning across the entire class, so that it does
not end at the construction phase.  Second,  it would underline for the
students the importance of assessing and documenting data quality, a topic that
occupies scientists for much of their time, but that is seldom discussed in
textbooks.

The sensors could be built for under $100 each, putting them well within the
reach of schools.  The networking would be free, since the sensors could be
connected to existing networked computers.  And the data compilation and
presentation on the web would be free, with work done by students themselves.
Schools are spaced at a distance of a few kilometers in towns and cities, so
the data sampling density would be very high.  (There is no reason that
students would not put these sensors on their homes, either, yielding even
higher data densities.)

Beyond some initial proof-of-concept work on the electronics and on computer
security, there would be no need for wide organization of the project.  The
students could run it, themselves.  One model would be a single hosting
computer, perhaps at Environment Canada.  But another model, probably of more
interest to the students, would be a distributed model, using peer-to-peer
methods.

As to the name of the project, and a logo to distinguish it, and an aesthetic
theme for the project website, these are things best decided by students, and
provide avenues for participation of students whose interests focus on
communication skills.

This project may be interesting to students even at the very early stages, and
should garner more and more attention as widening data streams suggest widening
application.

## Ideas for student work

**skynet** (as above ... many subasts in web design etc)

**navigator** use sunrise/sunset times to determine latitude and longitude, perhaps using R, with the sun.angle() function in the oce package.



## Notes on work

### Light sensor

[DFRobot Ambient Light
Sensor](http://www.robotshop.ca/dfrobot-ambient-light-sensor-1.html).  At about
$5, it would make sense to get a few, to see if there are inter-unit
differences.  

**Connections** Need to use jumpers to connect; see the [pin-out
schematic](http://www.dfrobot.com/wiki/index.php?title=DFRobot_Ambient_Light_Sensor_(SKU:DFR0026_))

**Read serial port**

    screen /dev/tty.usbmodem621 9600

To kill a screen, do

    C-a K

within it.  You may also detach, with ``C-a C-d``, and in that case, use

    ``screen -ls``

to see the screen identifier.  You may reattach to this later using that
identifier, e.g.

    screen -D -R 2998.ttys001.remit

and *then* you can kill with ``C-a K``.  (I couldn't figout out how to kill a
detached screen; the manpage is daunting.)


Another method may be 

    cu -s 9600 -l /dev/tty.usbmodem621

But I guess I should just figure out a C way, so I can write a daemon to
calculate stats and store them where a webserver can get them. 

### Calibration

First, some rough values.  In the morning (0710) on a clear day, direct
sunlight gave 42, pointing to ceiling gave 300, and pointing to the window (but
not the sun) gave 210.  At night, covered in a room lit by one lamp, the
reading was 1023.  

### Data-logging processor

There are many possibilities.  I will narrow to arduino, partly because they
are popular (and kids may be using them for robots, already) and cheap.
Robotshop.ca has a [movie](http://youtu.be/yYjtB_3en4s) that is quite helpful in
describing the various types of arduino.

For initial work, the best would be to get a $48
[kit](http://www.robotshop.ca/robotshop-arduino-basic-kit-7.html), which also
gives jumper cables, a breadboard, and a power supply.

If this seems promising, the second stage would be to start on self-contained
units, e.g. wrapping also a $13 
[enclosure case](http://www.robotshop.ca/sfe-arduino-project-enclosure.html) around the $30
[Arduino Uno USB Microcontroller](https://admin.robotshop.ca/productinfo.aspx?pc=rb-ard-18).

Arduino software is available [online](http://arduino.cc/en/Main/Software).

## Open issues and questions

1. **QUESTION**: are there any good books to speed up the learning process?

* Maybe buy a kit plus 2 books, from [amazon](http://www.amazon.com/Arduino-UNO-board/dp/B004CG4CN4/ref=pd_sim_b_6)

* There is an O'Reilly 
[book](http://www.amazon.com/Arduino-Cookbook-Oreilly-Cookbooks-Margolis/dp/0596802471/ref=pd_sim_b_13)

### reading serial port

- [python](http://mbed.org/cookbook/Interfacing-with-Python)

- [C (poor stackoverflow)](http://stackoverflow.com/questions/2504714/reading-serial-data-from-c-osx-dev-tty)

- [wikibook Serial_Linux](http://en.wikibooks.org/wiki/Serial_Programming:Serial_Linux)

- [wikibook termios](http://en.wikibooks.org/wiki/Serial_Programming:Unix/termios)


### daemons

- [linix junky blog](http://linux-junky.blogspot.com/2010/03/writing-daemon-in-c-or-daemonize.html)

- [peter lombardo](http://peterlombardo.wikidot.com/linux-daemon-in-c)

- [systhread](http://www.systhread.net/texts/200508cdaemon2.php#one)

- [fork manpage](http://linux.die.net/man/2/fork)

### stats

    xmean = sum(x) / n

    xstddev = sqrt(sum((x - xbar)^2) / (n - 1))
    
    > x<-rnorm(100)
    > Sx<-sum(x)
    > Sxx<-sum(x^2)
    > n<-length(x)
    > xvar<-(Sxx - Sx * Sx / n) / (n-1)
    > xvar - var(x)
    [1] 0
