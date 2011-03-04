<!-- vim:set spell filetype=html: -->
<?php
parse_str($_SERVER['QUERY_STRING']);

if ("$subtab" == "") {
echo '<p>
<a href="?tab=applications&amp;subtab=weather">Weather</a>
|
<a href="?tab=applications&amp;subtab=solar_navigation">Solar Navigation</a>
</p>';
}

if ("$subtab" == "weather") {
echo '<p>
<p>
Weather
| 
<a href="?tab=applications&amp;subtab=solar_navigation">Solar Navigation</a>
</p>';
echo '
<h1>Weather</h1>
<p>(FILL IN)</p>
';
}

if ("$subtab" == "solar_navigation") {
echo '<p>
<p>
<a href="?tab=applications&amp;subtab=weather">Weather</a>
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

