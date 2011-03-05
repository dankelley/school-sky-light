<!-- vim:set spell filetype=html: -->
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

    <p>The graph shown above indicates temporal variation of light intensity in an
    office in Halifax, Nova Scotia, updated at 10-minute intervals based on
    1-minute averages of data measured at 10-second intervals.  The sensor is
    placed on a desk, pointing upwards, and shaded from direct sunlight.  The sharp
    transitions to light levels of approximately 80% result when the lights are
    turned on in the office.</p>

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

        <p> <img src="code/sunrise_sunset.png" alt="sunrise_sunset.png"/> </p>

        <p>The graph shown above is the result of early tests with detection of sunrise
        and sunset times.  Students could use these times to infer the location of the
        observation, putting them in touch with something that their seafaring
        ancestors would have understood easily.</p>

        '
        ;
}

?>

