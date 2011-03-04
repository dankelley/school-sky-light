<!-- vim:set spell filetype=html: -->
<?php
parse_str($_SERVER['QUERY_STRING']);

if ("$subtab" == "") {
echo '<p>
<a href="?tab=results&amp;subtab=weather">Weather</a>
|
<a href="?tab=results&amp;subtab=solar_navigation">Solar Navigation</a>
</p>';
}

if ("$subtab" == "weather") {
echo '<p>
<p>
Weather
| 
<a href="?tab=results&amp;subtab=solar_navigation">Solar Navigation</a>
</p>';
echo '
<h1>Weather</h1>
<p>
<img src="code/plot.png" alt="plot"/>
</p>

<p>
The graph indicates temporal variation of light intensity in an office in 
Halifax, Nova Scotia, updated at 10-minute intervals based on 1-minute averages 
of data measured at 10-second intervals.  Readings of about 80% result from the 
use of overhead lights in the office.
</p>
';
}

if ("$subtab" == "solar_navigation") {
echo '<p>
<p>
<a href="?tab=results&amp;subtab=weather">Weather</a>
| 
Solar Navigation
</p>';
echo '
<h1>Solar Navigation</h1>
<p>
The graph below shows some early tests with detection of sunrise and sunset 
times.  Students could use these times to infer the location of the 
observation, putting them in touch with something that their seafaring 
ancestors would have understood easily.
</p>

<p>
<img src="code/sunrise_sunset.png" alt="sunrise_sunset.png"/>
</p>';
}
?>

