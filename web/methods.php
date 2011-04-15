<!-- vim:set spell filetype=php: -->
<p> <b>Apparatus.</b> The measurements are made with a <a 
href="http://www.robotshop.ca/dfrobot-ambient-light-sensor.html">DFRobot
            Ambient Light Sensor</a> connected to a "slave" <a
            href="http://www.robotshop.ca/arduino-uno-microcontroller-2.html">Arduino
            Uno microcontroller</a> that transmits data 
        to a "master" computer over a USB interface.
The microcontroller runs an Arduino script named <a 
href="code/slave_logger.pde">slave_logger.pde</a> and the logging computer 
interfaces to this with a C program called <a href="code/msl.c">msl.c</a>.
The logging computer also creates the graphs shown on this website at regular intervals, using the unix "cron" system.</p>

<p> <b>Data.</b> There is one sensor working at the moment,
an image of which, along with a pair that was sitting near it for a while, is
at the bottom of this page.
The data are available in an <a href="skyview.db">sqlite3 file</a>.
Note that one is more shaded than another, at the particular moment of the 
photo; the shading changes through the hours of the day.
</p>

<p>
<b>Development.</b> This project is developed in the open on <a 
href="http://github.com/dankelley/school-sky-light/">github.com</a>.
</p>

<p><img src="images/sensors_phase1.jpg" alt="sensors_phase1"/></p>

