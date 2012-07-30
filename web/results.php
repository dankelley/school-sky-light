<!-- vim:set spell filetype=php: -->
<?php
parse_str($_SERVER['QUERY_STRING']);

if ("$subtab" == "") {
    echo '<div class="submenu">
        <ul>
        <li> <a href="?tab=results&amp;subtab=weather">Weather</a>
        <li> <a href="?tab=results&amp;subtab=solar_navigation">Solar Navigation</a>
        <li> <a href="?tab=results&amp;subtab=sensor_calibration">Sensor Calibration</a>
        </ul></div>';
    echo '<p>Select a sub-menu to see results, up to 2012-07-26, when the sensor
        was turned off owing to (a) the uselessness of measuring light in a room now in the shadow of a new building and (b) the evacuation of the room owing to water damage from a leaking roof (caused by the attachment of that same new building).</p>';
}

if ("$subtab" == "weather") {
    echo '<div class="submenu">
        <ul>
        <li id=current> <a href="?tab=results&amp;subtab=weather">Weather</a>
        <li> <a href="?tab=results&amp;subtab=solar_navigation">Solar Navigation</a>
        <li> <a href="?tab=results&amp;subtab=sensor_calibration">Sensor Calibration</a>
        </ul></div>';
    echo '<p>The graph shown below indicates recent variations in light 
        intensity in an office in Halifax, Nova Scotia.  The graph is made by 
        an R script called <a href="code/weather.R">weather.R</a>, which is run 
        every 10 minutes, using data measured every 10 seconds and formed into 
        1-minute averages.  The sensor is placed on a desk, pointing upwards, 
        and shaded from direct sunlight.  The (rare) use of lights in the 
        office is indicated by near-constant light levels of 80 percent.  The 
        blue curve is atmospheric pressure (from Environment Canada), on a 
        different scale.  Note that unsettled weather is typified by low and 
        rapidly-varying light levels.</p>';
    echo '<p><img src="code/weather.png" alt="weather.png"/></p>';
    echo '<p>The image below shows light measured since March 2011,
        color-coded for intensity and shown as a function of the 
        hour of the day and the day of the year.  It is created at a 10-minute 
        interval with the R script <a 
        href="code/weather_image.R">weather_image.R</a>.  The white 
        regions of the image correspond to times when the sensor
        was disconnected from the logging computer.</p>';
    echo '<p><img src="code/weather_image.png" alt="weather_image.png"/></p>';
    echo '<p>The graph below highlights the time of day, with deviations from 
        the "clock" indicating light intensity, and the colour of the lines 
        indicating time within the whole time series.  The graph is created
        with the R script <a href="code/light_clock.R">light_clock.R</a>.</p>';
    echo '<p><img src="code/light_clock.png" alt="light_clock.png"/></p>';
} 

if ("$subtab" == "solar_navigation") {
     echo '<div class="submenu">
        <ul>
        <li> <a href="?tab=results&amp;subtab=weather">Weather</a>
        <li id=current> <a href="?tab=results&amp;subtab=solar_navigation">Solar Navigation</a>
        <li> <a href="?tab=results&amp;subtab=sensor_calibration">Sensor Calibration</a>
        </ul></div>';

     echo '<p>NOTE: navigation is not working well lately, because the new 
         "Ocean Excellence" building shades the office so completely that 
         overhead lights must be used much of the day.</p>

        <p> <img src="code/solar_navigation_timeseries.png" 
        alt="solar_navigation_timeseries.png"/> </p>

        <p>The graph shown above is the result of early tests with automatic 
        detection of sunrise and sunset times.
        </p>
      <p>  The graph shown below indicates 
        the observation location in Halifax, Nova Scotia, along with an 
        inference of that location based on sunrise and sunset times.  Both 
        graphs are made by an R script called <a 
        href="code/solar_navigation.R">solar_navigation.R</a>, which is 
        run twice per day.
        </p>


        <p> <img src="code/solar_navigation_map.png" 
        alt="solar_navigation_map.png"/> </p>';
}

if ("$subtab" == "sensor_calibration") {
     echo '<div class="submenu">
        <ul>
        <li><a href="?tab=results&amp;subtab=weather">Weather</a>
        <li><a href="?tab=results&amp;subtab=solar_navigation">Solar Navigation</a>
        <li id=current><a href="?tab=results&amp;subtab=sensor_calibration">Sensor Calibration</a>
        </ul></div>';
    echo '<p> The graph below shows a calibration between two sensors placed near 
        each other.  It seems reasonable to take the main shape as a measure of 
        inter-sensor differences, although the detailed trajectories in the 
        calibration space may also relate to differences in light intensity at 
        the two sensors, since they are nestled between various bits of 
        equipment on a table, and one is sometimes in brighter light than the 
        other, as light passes through the room through the course of the day.  
        The graph is created by an R script called <a 
        href="code/calibration.R">calibration.R</a>.</p>

        <p> <img src="code/calibration.png" alt="calibration.png"/> </p>';
}

?>

