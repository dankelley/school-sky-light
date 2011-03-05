<!-- vim:set spell filetype=php: -->
<p>
<b>Development.</b> This project is developed in the open on <a 
href="http://github.com/dankelley/school-sky-light/">github.com</a>.
</p>

<p>
<b>Apparatus.</b> The measurements are made with a <a 
href="http://www.robotshop.ca/dfrobot-ambient-light-sensor.html">DFRobot
            Ambient Light Sensor</a> connected to a "slave" <a
            href="http://www.robotshop.ca/arduino-uno-microcontroller-2.html">Arduino
            Uno microcontroller</a> that transmits data 
        to a "master" computer over a USB interface.
</p>

<p>
<b>Software.</b>  The master computer uses the "cron" system command to organize the graphing and analysis of the data at regular intervals.  The computer programs are as follows.</p>
<ul>
<li> <a href="code/slave_logger.pde">slave_logger.pde</a> (code driving the microcontroller's data acquisition
<li> <a href="code/msl.c">msl.c</a> (code used by the master computer to drive the slave microcontroller)
<li> <a href="code/plot.R">code.R</a>a (R code used to graph light versus time)
<li> <a href="code/calibration.R">calibration.R</a> (calibrates two sensors, as shown below)
<li> <a href="code/sunrise_sunset.R">sunrise_sunset.R</a> (not documented here yet)
</ul>
</p>

<p> <b>Data.</b> There are two sensors working at the moment, <a
    href="skynet-01.dat">skynet-01.dat</a> and <a
    href="skynet-02.dat">skynet-02.dat</a>.  A comparison of their signals is
shown below.  (Note that the sensors are only approximately co-located, and so
some of the variation may result from the fact that they are in different
shadows, or reflections, as the day progresses.) </p>

<p> <img src="code/calibration.png" alt="calibration.png"/> </p>

