<!-- vim:set spell filetype=php: -->
<?php
parse_str($_SERVER['QUERY_STRING']);

if ("$subtab" == "") {
    echo '<p>
        <a href="?tab=results&amp;subtab=weather">Weather</a>
        |
        <a href="?tab=results&amp;subtab=solar_navigation">Solar Navigation</a>
        </p>';
} elseif ("$subtab" == "weather") {
        echo '<p>
Weather
| 
<a href="?tab=results&amp;subtab=solar_navigation">Solar Navigation</a>
</p>';

echo '
    <h1>Weather</h1>

    <p><img src="code/plot.png" alt="plot"/></p>

    <p>The graph shown above indicates temporal variation of light intensity in 
    an office in Halifax, Nova Scotia, updated at 10-minute intervals based on 
    1-minute averages of data measured at 10-second intervals.  The sensor is
    placed on a desk, pointing upwards, and shaded from direct sunlight.  The 
    graph is made by an R script called <a href="code/weather.R">weather.R</a>.</p>

    <p>Unsettled days are typified by rapid variations in light intensity.  
    This was the case early on February 24th, but around noon, the sky cleared 
    up for the rest of the day.  February 25th was stormy, and this can be seen 
    in both in the rapid variations in light intensity and in the low 
    intensity, overall.  Students might enjoy consulting graphs of this sort, 
    updated daily, and noting any relationship to observed weather.</p>

    <p>(The sharp transitions to light levels of approximately 80% result when 
    the lights are turned on in the office.  This is an anomaly that will not 
    cause problems in designs with the sensor pointing out a window, or on a 
    roof.)</p>

    ';

} elseif ("$subtab" == "solar_navigation") {
    echo '
        <p>
        <a href="?tab=results&amp;subtab=weather">Weather</a>
        | 
        Solar Navigation
        </p>';

    echo '

        <h1>Solar Navigation</h1>

        <p> <img src="code/solar_navigation_timeseries.png" alt="solar_navigation_timeseries.png"/> </p>

        <p>The graph shown above is the result of early tests with automatic 
        detection of sunrise and sunset times.  The graph shown below indicates 
        the observation location in Halifax, Nova Scotia, along with an 
        inference of that location based on sunrise and sunset times.  Both 
        graphs are made by an R script called <a 
            href="code/solar_navigation.R">solar_navigation.R</a>.</p>

        <p> <img src="code/solar_navigation_map.png" alt="solar_navigation_map.png"/> </p>

        '
        ;
}

?>

