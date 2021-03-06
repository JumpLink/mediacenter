# Benthe's MediaCenter

A MediaCenter controlled from your smartphone tested on Ubuntu / Raspbian (Raspberry Pi) and developed as a birthday gift for Benthe ;)

![Screenshot](https://raw.githubusercontent.com/JumpLink/mediacenter/master/screenshots.png "Screenshot")

# Technical Background

This project it written in Javascript using [Node.js](http://nodejs.org/) and [Sails.js](http://sailsjs.org/) (a realtime MVC Framework for Node.js). To play media files it is using [OMXPlayer](http://omxplayer.sconde.net/) (on Raspian) or [ffplay](https://www.ffmpeg.org/ffplay.html) (on Ubuntu).

# Install

## Dependencies

### [Node.js](http://nodejs.org/)

* On Ubuntu:
```sudo apt-get install nodejs```
* On Raspbian follow [this instructions](https://learn.adafruit.com/raspberry-pi-hosting-node-red/setting-up-node-dot-js).

### [Bower](http://bower.io/) to install cliend site dependencies
```sudo npm install -g bower```

### [Forever](https://github.com/nodejitsu/forever) for run the mediacenter as daemon
```sudo npm install forever -g```

### [Unclutter](http://manpages.ubuntu.com/manpages/trusty/man1/unclutter.1.html) for hide the mouse if unused
```sudo apt-get install unclutter```

### Ffmpeg for media file parsing and ffplay for play audio/video files

```
sudo apt-get install ffmpeg
```

* If you can't find this package on Ubuntu use [this ppa](https://launchpad.net/~jon-severinsson/+archive/ffmpeg):
```
sudo apt-add-repository ppa:jon-severinsson/ffmpeg
sudo apt-get update
sudo apt-get install ffmpeg
```

### [Ubuntu font](http://packages.ubuntu.com/en/trusty/all/ttf-ubuntu-font-family/download)

* On Ubuntu:
```
sudo apt-get install ttf-ubuntu-font-family
```
* On Raspbian:
```
wget http://de.archive.ubuntu.com/ubuntu/pool/main/u/ubuntu-font-family-sources/ttf-ubuntu-font-family_0.80-0ubuntu6_all.deb
sudo dpkg -i ttf-ubuntu-font-family_*.deb
```

## Build the mediacenter itself
* Clone this repo and change directory:
```
git clone git@github.com:JumpLink/mediacenter.git
cd mediacenter/src
```
* Install server side dependencies:
```npm install```
* Install client side dependencies:
```bower install```

## Configure
* Get movie database keys on
 * TMDb Key: https://www.themoviedb.org/documentation/api
 * TVDB Key: http://thetvdb.com/?tab=apiregister
* Copy the config/local.js.example to config/local.js and modify to insert the keys:
```
cp config/local.js.example config/local.js
[your favourite editor] config/local.js
```

## Try to start
* Be sure to be in mediacenter/src and run:
```node mediacenter.js```
* Scan the QR-Code or type the Address in your Browser

## Setup Raspberry Pi with Raspbian (optional)
* Install [Raspbian](http://www.raspbian.org/)
* Set start LXDE on boot
* Setup WiFi/Ethernet
* Set pcmanf to automount devices and but not show them on mount.
* Setup autostart
* Modify ```/etc/xdg/lxsession/LXDE/autostart``` to
```
# show all gui apps on mediacenter
export DISPLAY=:0.0
#@lxpanel --profile LXDE
# we need pcmanfm for automount devices
@pcmanfm --desktop --profile LXDE
# turn off the screen saver
#@xscreensaver -no-splash
@xset s off
# disable the power management using dpms to power the monitor down
@xset -dpms
# turn off blanking
@xset s noblank
# hide the mouse if unused
@unclutter
# remove old logs
@forever cleanlogs
# start mediacenter
@sh -c 'cd /home/pi/mediacenter/src && forever start -l mediacenter.log mediacenter.js'
```

# Control
* Restart mediacenter: ```forever restart -l mediacenter.log mediacenter.js```
* Stop mediacenter: ```forever stop mediacenter.js```
* Start mediacenter: ```cd /home/pi/mediacenter/src && forever start -l mediacenter.log mediacenter.js```
* Print logs
```
forever logs
```
Output:
```
info:    Logs for running Forever processes
data:        script         logfile                    
data:    [0] mediacenter.js /home/pi/.forever/mediacenter.log
```
```
forever logs 0
```
Output:
```
[...]
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
[...]
```

## Links
* [Build your own Google TV Using RaspberryPi, NodeJS and Socket.io](http://blog.donaldderek.com/2013/06/build-your-own-google-tv-using-raspberrypi-nodejs-and-socket-io/)
* [Designing For TV](https://developers.google.com/tv/web/docs/design_for_tv)
* [Setting up Node.js](http://blog.blakesimpson.co.uk/read/41-install-node-js-on-debian-wheezy)
* [Boot your Raspberry Pi into a fullscreen browser kiosk](http://blogs.wcode.org/2013/09/howto-boot-your-raspberry-pi-into-a-fullscreen-browser-kiosk/)
* [Raspberry Pi als Kiosk mit resourcenschonendem Browser und VESA Mount](http://repat.de/2013/03/raspberry-pi-als-kiosk-mit-resourcenschonendem-browser-und-vesa-mount/)
* [restart networking](http://codeghar.wordpress.com/2011/07/18/debian-running-etcinit-dnetworking-restart-is-deprecated-because-it-may-not-enable-again-some-interfaces/)
* [Sails.js](http://sailsjs.org)
* [52 movies APIs](http://www.programmableweb.com/news/52-movies-apis-rovi-rotten-tomatoes-and-internet-video-archive/2013/01/22)
* Similar Projects
 * [PiR.tv](https://github.com/DonaldDerek/PiR.tv)
 * [angular-rpitv](https://github.com/viperfx/angular-rpitv)
 * [ludovision](https://github.com/lamberta/ludovision)

## Bugs
 * https://github.com/mscdex/mmmagic/issues/24
