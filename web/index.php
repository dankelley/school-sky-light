<?php
require("tabbed_site.php");
$tab_titles    = array("Concept","Conditions","Methods","Development");
$tab_nicknames = array("concept","conditions","methods","development");
$tab_pages     = array("concept.php","conditions.php","methods.php","development.php");

# Set up the site ...
$ts = new tabbed_site(
	$title         = "SkyNet",
	$tab_titles    = $tab_titles,
	$tab_nicknames = $tab_nicknames,
	$tab_pages     = $tab_pages);

# ... and then display the results
$ts->create(); 

?>
