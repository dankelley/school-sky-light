# Apparatus

See also: [introduction](index.md) and [results](results.md).

The measurements are made with a
[http://www.robotshop.ca/dfrobot-ambient-light-sensor.html](DFRobot Ambient
Light Sensor) connected to an
[http://www.robotshop.com/ca/en/arduino-uno-r3-usb-microcontroller.html](Arduino
Uno microcontroller) that transmits data to a desktop computer over a USB
interface.  The microcontroller runs an Arduino script named
`slave_logger.pde`> and the logging computer interfaces to this with a C
program called `msl.c`, and that computer also creates the graphs shown on this
website at regular intervals, using the unix "cron" system.

# Data

There is one sensor working at the moment, an image of which, along with a pair
that was sitting near it for a while, is at the bottom of this page.  The data
are available in an sqlite3 file named `skyview.db`.  Note that one is more
shaded than another, at the particular moment of the photo; the shading changes
through the hours of the day.

# Development

This project is developed in the open on
[http://github.com/dankelley/school-sky-light](github.com).

![images/sensors_phase1.jpg](images/sensors_phase1)


