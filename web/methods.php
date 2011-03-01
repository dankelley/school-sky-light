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
        intervals, an <a href="code/plot.R">R program</a> reads the file and
        creates the image shown above.  Also, once per day, sunrise and sunset
        are inferred from the light intensity variation, and compared with
        actual times from celestial calculations; the plot below is produced by
<a href="code/sunrise_sunset.R">sunrise_sunset.R</a>.
</p>
<p>
<img src="code/sunrise_sunset.png" alt="sunrise_sunset.png"/>
</p>

<p>
A second sensor was added on Feb 28, 2011.  The <a href="skynet-02.dat">data</a> from this device are analysed on an hourly basis.  The plot below is produced by <a href="code/calibration.R">calibration.R</a>.
</p>
<p>
<img src="code/calibration.png" alt="calibration.png"/>
</p>

