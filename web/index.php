<?php
require("tabbed_site.php");
$tab_titles    = array("Concept","Conditions","Applications","Methods","Development");
$tab_nicknames = array("concept","conditions","applications","methods","development");
$tab_pages     = array("concept.php","conditions.php","applications.php","methods.php","development.php");
$ts = new tabbed_site(
	$title         = "SkyNet",
	$tab_titles    = $tab_titles,
	$tab_nicknames = $tab_nicknames,
	$tab_pages     = $tab_pages);
$ts->create(); 
?>
