<!-- vim: set filetype=html -->
<p>
The <a href="skynet-01.dat">measurements</a> were done
        by <a
            href="http://www.robotshop.ca/dfrobot-ambient-light-sensor.html">DFRobot
            Ambient Light Sensor</a> connected to an <a
            href="http://www.robotshop.ca/arduino-uno-microcontroller-2.html">Arduino
            Uno microcontroller</a>, which is subject to a <a
            href="code/slave_logger.pde">controlling program</a> that
        supplies real-time data to a computer over a USB interface.  The
        computer uses a <a href="code/msl.c">C program</a> to capture the
        serial stream, calculate statistical measures in 1-minute intervals,
        and append the results to a file on the computer.  At 10 minute
        intervals, a master computer updates all graphs with the following R programs:
<ul>
<li> <a href="code/plot.R">code.R</a>
<li> <a href="code/sunrise_sunset.R">sunrise_sunset.R</a>.
<li> <a href="code/calibration.R">calibration.R</a>
</p>

<p>
A second sensor was added on Feb 28, 2011.  The data (<a href="skynet-02.dat">skynet-02.dat</a>) 
are graphed below, using the calibration.R program given above.
</p>
<p>
<img src="code/calibration.png" alt="calibration.png"/>
</p>

