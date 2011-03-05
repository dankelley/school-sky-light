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

<p> <b>Data.</b> There are two sensors working at the moment, <a
    href="skynet-01.dat">skynet-01.dat</a> and <a
    href="skynet-02.dat">skynet-02.dat</a>.
</p>

<p>
<b>Development.</b> This project is developed in the open on <a 
href="http://github.com/dankelley/school-sky-light/">github.com</a>.
</p>

