The daemon should be placed in the directory ``/Library/LaunchDaemons`` (on an
OSX machine), and then it will commence working on system reboot.  To test it
on a running system, issue the following unix command

    launchctl load org.skyview.start.plist

and to check it, issue

    launchctl list|grep sky

NOTE: it will be necessary to change the name of the executable (``.../msl``)
and the name of the USB slot, and the database name, in order for this to work
properly on other machines.

