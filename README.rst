Concept
=======

A darkening sky is a good indicator of the onset of bad weather.  We look up at the sky to decide
whether to run to the shelter, on an unsettled day.  Weather forecasts do not address broad issues
of weather variations over days and hundreds of kilometers, but people have still rely on the sky
for quick, localized forecasts.  

A limitation of this observer-based forecasting is that even small-scale weather patterns are not
entirely localized.  Events such as fronts and thunderstorms tend to sweep across regions, so that
one neighborhood could warn another of impending bad weather.

The idea of this project is to develop a network of skylight sensors that would mimic the human eye,
testing for darkening of the sky hour by hour, or even minute by minute.  The network would need to
cover populated areas in a reasonable data density, say one sensor per square kilometre or so.  The
national weather service could do that in a professional way, probably at great expense for
equipment, networking, and maintenance. 

But there is another way: put the sensors in schools.  Let the students build the sensors, 
network them, write the code to integrate them, and perform regular calibration and other
maintenance.   Each of the steps would provide students with fun, and good learning experiences.
Building the sensors would help them to learn about the physics of light sensing and about the
electronics of data logging.  Networking and coding provide the chance to learn about computing
hardware and software.  And the maintenance would do two important things.  First, it would
continually reinforce the lessons about physics and electronics, spreading the learning across the
entire class, so that it doesn't end at the construction phase.  Second,  it would underline for the
students the importance of assessing and documenting data quality, a topic that occupies much of a
scientist's day, but that is seldom discussed in textbooks.

The sensors could be built for under $100 each, putting them well within the reach of schools.  The
networking would be free, since the sensors could be connected to existing networked computers.  And
the data compilation and presentation on the web would be free, with work done by students
themselves.   Schools are spaced at a distance of a few kilometers in towns and cities, so the data
sampling density would be very high.  (There is no reason that students wouldn't put these sensors
on their homes, either, yielding even higher data densities.)

Beyond some initial proof-of-concept work on the electronics and on computer security, there would
be no need for wide organization of the project.  The students could run it, themselves.  One model
would be a single hosting computer, perhaps at Environment Canada.  But another model, probably of
more interest to the students, would be a distributed model, using peer-to-peer methods.

As to the name of the project, and a logo to distinguish it, and an aesthetic theme for the project's
website, these are things best decided by students, and provide avenues for participation of
students whose interests focus on communication skills.

This project may be interesting to students even at the very early stages, and should garner more
and more attention as widening data streams suggest widening application.


Notes on work
-------------

Light sensor
............

DFRobot Ambient Light Sensor (http://www.robotshop.ca/dfrobot-ambient-light-sensor-1.html).  At
about $5, it would make sense to get a few, to see if there are inter-unit differences.

Data-logging processor
......................

There are many possibilities.  I'll narrow to arduino, partly because they are popular (and kids may
be using them for robots, already) and cheap.  Robotshop.ca has a movie
(http://youtu.be/yYjtB_3en4s) that is quite helpful in describing the various types of arduino.

For initial work, the best would be to get a $48 kit, which also gives jumper cables, a breadboard, and
a power supply (http://www.robotshop.ca/robotshop-arduino-basic-kit-7.html).

If this seems promising, the second stage would be to start on self-contained units, e.g. wrapping
also a $13 enclosure case (http://www.robotshop.ca/sfe-arduino-project-enclosure.html) around the
$30 Arduino Uno USB Microcontroller (https://admin.robotshop.ca/productinfo.aspx?pc=rb-ard-18).

Arduino software is available (http://arduino.cc/en/Main/Software).

Open issues and questions
.........................

1. **QUESTION**: are there any good books to speed up the learning process?

* Maybe buy a kit plus 2 books, from amazon (http://www.amazon.com/Arduino-UNO-board/dp/B004CG4CN4/ref=pd_sim_b_6)

* There is an O'Reilly book (and they are almost always excellent) coming out in a week (http://www.amazon.com/Arduino-Cookbook-Oreilly-Cookbooks-Margolis/dp/0596802471/ref=pd_sim_b_13)
