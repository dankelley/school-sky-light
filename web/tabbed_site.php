<?php
class tabbed_site
{
    var $author          = "author";
    var $author_email    = "author@email";
    var $title           = "";  # may be set by set_title()
    var $keywods         = "";
    var $logo            = "";  # may be set by set_logo()
    var $favicon         = "";  # may be set by set_favicon()
    var $tab_titles      = array("Home"); # may contain spaces
    var $tab_nicknames   = array("home"); # no spaces
    var $tab_pages       = array("home.php"); # for inclusion
    var $is_login_site   = false;
    var $want_javascript = false;
    var $logo_type       = 2;		/* 1=image 2=plain */
    var $footer_msg      = "";
    function tabbed_site(
        $title = "insert title here",
        $tab_titles=array("Home"),
        $tab_nicknames=array("home"),
        $tab_pages=array("home.php"),
        $is_login_site = false)
    {
        $this->title         = $title;
        $this->tab_titles    = $tab_titles;
        $this->tab_nicknames = $tab_nicknames;
        $this->tab_pages     = $tab_pages;
        $this->is_login_site = $is_login_site;
    }
    function set_logo_type($type)          { $this->logo_type        = $type;      }
        function set_site_title($title)        { $this->title            = $title;     }
        function set_keywords($keywords)       { $this->keywords         = $keywords;  }
        function set_logo($logo)               { $this->logo             = $logo;      }
        function set_favicon($favicon)         { $this->favicon          = $favicon;   }
        function set_tab_titles($titles)       { $this->tab_titls        = $titles;    }
        function set_tab_nicknames($nicknames) { $this->tab_nicknames    = $nicknames; }
        function set_tab_pages($pages)         { $this->tab_pages        = $pages;     }
        function set_author($author)           { $this->author           = $author;    }
        function set_author_email($email)      { $this->author_email     = $email;     }
        function set_want_javascript($w)       { $this->want_javascript  = $w;         }
        function set_footer_msg($msg)          { $this->footer_msg       = $msg;       }
        function footer()                 {
            if (isset($_SERVER['HTTP_USER_AGENT']) && 
                (strpos($_SERVER['HTTP_USER_AGENT'], 'MSIE') !== false)) {
                    echo "<p class=\"iesucks\">This site will look much better if you do not use Internet Explorer.</p>\n";
                }
            print "<div class=\"footer\">$this->footer_msg</div>\n";
            print "</body>\n</html>";
        }
    function site_info()
    {
        echo "<p>Site info should be $this->danboy here.</p>";
        #		$n = count($tab_);
    }
    function create()
    {
        global $ls;
        $qs = $_SERVER['QUERY_STRING'];
        parse_str($_SERVER['QUERY_STRING'], $qs);
        print "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n";
        print "<html>\n";
        print "<head>\n";
        if ($this->want_javascript) {
            print "  <script src=\"javascripts/prototype.js\" type=\"text/javascript\"></script>\n";
            print "  <script src=\"javascripts/scriptaculous.js\" type=\"text/javascript\"></script>\n";
        }
        print "  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=US-ASCII\">\n";
        print "  <title>$this->title</title>\n";
        if (isset($_SERVER['HTTP_USER_AGENT']) && 
            (strpos($_SERVER['HTTP_USER_AGENT'], 'MSIE') !== false)) {
                print "  <link rel=\"stylesheet\" href=\"style.css\" type=\"text/css\">\n";
            } else {
                print "  <link rel=\"stylesheet\" href=\"style.css\" type=\"text/css\">\n";
            }
        print "  <meta name=\"Author\" content=\"$this->author\">\n";
        print "  <meta name=\"keywords\" content=\"$this->keywords\">\n";
        print "  <link rel=\"Shortcut Icon\" href=\"$this->favicon\">\n";
        print "</head>\n";
        print "<body>\n";
        print "<div class=\"main-base\">\n";
        if ($this->logo_type == 1) {
            print "  <div class=\"main-logo-1\">\n";
        } elseif ($this->logo_type == 2) {
            print "  <div class=\"main-logo-2\">";
            print $this->title;
        } else {
            print "  <div class=\"main-logo-2\">";
            print $this->title;
        }
        print "\n    <span class=\"login-line\">\n";
        if ($this->is_login_site) {
            if ($ls->logged_in()) { # BUG: assuming name of login_site object is "ls"
                print "      <span class=\"user-name\">" . $_SESSION[$this->title . "LoginName"] . "</span>\n";
                print "      |\n";
                print "      " . $ls->member_logout_link() . "\n";
            } else {
                #			print "      <span class=\"user-name\">" . "(USERNAME HERE)" . "</span>\n";
                #			print "      |\n";
                print "      " . $ls->member_login_link() . "\n";
                print "      |\n";
                print "      " . $ls->join_link($ls->base) . "\n";
            }
        }
        print "    </span>\n";
        print "    <div class=\"main-nav\">\n";
        print "      <ul>\n";
        $i = 0;
        $width = 90;
        $n = count ($this->tab_titles);
        $match = -1;
        if (!isset($qs['tab'])) 
            $qs['tab'] = $this->tab_nicknames[0];
        for ($i = 0; $i < $n; $i++) {
            if ($this->tab_nicknames[$i] == $qs['tab']) {
                $match = $i;
                print "        <li id=\"current\"><a href=\"?tab=" . $this->tab_nicknames[$i] . "\">";
                print $this->tab_titles[$i];
                print "</a>\n";
            } else {
                print "        <li><a href=\"?tab=" . $this->tab_nicknames[$i] . "\">";
                print $this->tab_titles[$i];
                print "</a>\n";
            }
            #			echo "<br>(".$qs['tab'].")<br>";
        }
        print "      </ul>\n";
        print "    </div>\n";
        print "  </div>\n";
        print "</div>\n";
        $cols = $i * 2 + 1;
        if ($this->want_javascript)
            echo "<noscript><p style=\"font-size:small;color:red\">Please turn <b>javascript</b> on, so that this site will function better for you.</p></noscript>\n";
        // print "<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n";
        // print "  <tr>\n";
        // print "    <td>&nbsp;</td>\n";
        // 	    print "    <td><img src=\"$this->logo\" alt=\"$this->title\" border=\"\"></td>\n";
        // print "  </tr>\n";
        // print "</table>\n\n";
        if ($match > -1)
            require($this->tab_pages[$match]);
        $this->footer();
    }
}
?>
