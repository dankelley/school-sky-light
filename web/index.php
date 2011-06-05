<?php
require("tabbed_site.php");
$tab_titles    = array("Introduction","Results","Methods");
$tab_nicknames = array("introduction","results","methods");
$tab_pages     = array("introduction.php","results.php","methods.php");
$ts = new tabbed_site(
	$title         = "SkyView",
	$tab_titles    = $tab_titles,
	$tab_nicknames = $tab_nicknames,
        $tab_pages     = $tab_pages
    );
$ts->set_keywords("light skyview school arduino sensor education");
$ts->create(); 
?>
