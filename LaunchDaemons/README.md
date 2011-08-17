**Instructions.**

Put these files into /Library/LaunchDaemons and then execute

    launchctl load org.skyview.controller.plist 
    launchctl load org.skyview.aggregator.plist 

or reboot the machine.

Problems with Lion:

tail -f /private/var/log/system.log

Aug 17 10:21:11 emit org.skyview.controller[4493]: Traceback (most recent call last):
Aug 17 10:21:11 emit org.skyview.controller[4493]:   File "/Users/kelley/school-sky-light/LaunchDaemons/skyview_controller.py", line 2, in <module>
Aug 17 10:21:11 emit org.skyview.controller[4493]:     import serial
Aug 17 10:21:11 emit org.skyview.controller[4493]: ImportError: No module named serial
Aug 17 10:21:11 emit com.apple.launchd[1] (org.skyview.controller[4493]): Exited with code: 1
Aug 17 10:21:11 emit com.apple.launchd[1] (org.skyview.controller): Throttling respawn: Will start in 10 seconds

