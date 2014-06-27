# mediacenter

a [Sails](http://sailsjs.org) application

# Install

## Dependencies
### To hide the mouse
```sudo apt-get install unclutter```
### To run the mediacenter continuously
```sudo npm install forever -g```

## Raspberry Pi
* Install [Raspbian](http://www.raspbian.org/)
* Set start LXDE on boot
* Setup WiFi/Ethernet
* Set pcmanf to automount devices and but not show them on mount.
* Install the [Ubuntu font](http://packages.ubuntu.com/en/trusty/all/ttf-ubuntu-font-family/download)
* Allow user pi to shutdown and reconnect, use ```sudo visudo``` and add this line:
```
pi ALL=NOPASSWD: /sbin/ifdown, /sbin/ifup, /sbin/shutdown
```

### Autostart
* Modify ```/etc/xdg/lxsession/LXDE/autostart``` to
```
#@lxpanel --profile LXDE
@pcmanfm --desktop --profile LXDE
#@xscreensaver -no-splash
@xset s off
@xset -dpms
@xset s noblank
@unclutter
@forever cleanlogs
@sh -c 'cd /home/pi/mediacenter/src && forever start -l mediacenter.log mediacenter.js'
```

# Control
## ssh
* Restart: ```forever restart -l mediacenter.log mediacenter.js```
* Stop: ```forever stop mediacenter.js```
* Start: ```cd /home/pi/mediacenter/src && forever start -l mediacenter.log mediacenter.js```
* Print logs
```
forever logs
```
Output:
```
info:    Logs for running Forever processes
data:        script         logfile                    
data:    [0] mediacenter.js /home/pi/.forever/5X9Z.log
```
```
forever logs 0
```
Output:
```
data:    mediacenter.js:3601 -    Sails              <|
data:    mediacenter.js:3601 -    v0.10.0-rc8         |\
data:    mediacenter.js:3601 -                       /|.\
data:    mediacenter.js:3601 -                      / || \
data:    mediacenter.js:3601 -                    ,'  |'  \
data:    mediacenter.js:3601 -                 .-'.-==|/_--'
data:    mediacenter.js:3601 -                 `--'-------' 
data:    mediacenter.js:3601 -    __---___--___---___--___---___--___
data:    mediacenter.js:3601 -  ____---___--___---___--___---___--___-__
data:    mediacenter.js:3601 - Server lifted in `/home/pi/mediacenter/src`
data:    mediacenter.js:3601 - To see your app, visit http://localhost:1337
data:    mediacenter.js:3601 - To shut down Sails, press <CTRL> + C at any time.
...
```

## Links
* [Build your own Google TV Using RaspberryPi, NodeJS and Socket.io](http://blog.donaldderek.com/2013/06/build-your-own-google-tv-using-raspberrypi-nodejs-and-socket-io/)
* [Designing For TV](https://developers.google.com/tv/web/docs/design_for_tv)
* [Setting up Node.js](http://blog.blakesimpson.co.uk/read/41-install-node-js-on-debian-wheezy)
* [Boot your Raspberry Pi into a fullscreen browser kiosk](http://blogs.wcode.org/2013/09/howto-boot-your-raspberry-pi-into-a-fullscreen-browser-kiosk/)
* [Raspberry Pi als Kiosk mit resourcenschonendem Browser und VESA Mount](http://repat.de/2013/03/raspberry-pi-als-kiosk-mit-resourcenschonendem-browser-und-vesa-mount/)
* [restart networking](http://codeghar.wordpress.com/2011/07/18/debian-running-etcinit-dnetworking-restart-is-deprecated-because-it-may-not-enable-again-some-interfaces/)
* Similar Projects
 * [PiR.tv](https://github.com/DonaldDerek/PiR.tv)
 * [angular-rpitv](https://github.com/viperfx/angular-rpitv)
 * [ludovision](https://github.com/lamberta/ludovision)

## Bugs
 * https://github.com/fluent-ffmpeg/node-fluent-ffmpeg/issues/261
 * https://github.com/mscdex/mmmagic/issues/24
