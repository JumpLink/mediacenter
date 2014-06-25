# mediacenter

a [Sails](http://sailsjs.org) application

# Install

## Hide mouse
```sudo apt-get install unclutter```

## Raspberry Pi
* Install [Raspbian](http://www.raspbian.org/)
* Set start LXDE on boot on install
* Setup WiFi/Ethernet

### Autostart
* Modify ```/etc/xdg/lxsession/LXDE/autostart``` to
```
#@lxpanel --profile LXDE
#@pcmanfm --desktop --profile LXDE
#@xscreensaver -no-splash
@xset s off
@xset -dpms
@xset s noblank
@unclutter
@sh -c 'cd /home/pi/mediacenter/src && node app.js'
```

## Links
* [Build your own Google TV Using RaspberryPi, NodeJS and Socket.io](http://blog.donaldderek.com/2013/06/build-your-own-google-tv-using-raspberrypi-nodejs-and-socket-io/)
* [Designing For TV](https://developers.google.com/tv/web/docs/design_for_tv)
* [Setting up Node.js](http://blog.blakesimpson.co.uk/read/41-install-node-js-on-debian-wheezy)
* [Boot your Raspberry Pi into a fullscreen browser kiosk](http://blogs.wcode.org/2013/09/howto-boot-your-raspberry-pi-into-a-fullscreen-browser-kiosk/)
* [Raspberry Pi als Kiosk mit resourcenschonendem Browser und VESA Mount](http://repat.de/2013/03/raspberry-pi-als-kiosk-mit-resourcenschonendem-browser-und-vesa-mount/)
* Similar Projects
 * [PiR.tv](https://github.com/DonaldDerek/PiR.tv)
 * [angular-rpitv](https://github.com/viperfx/angular-rpitv)

## Bugs
 * https://github.com/fluent-ffmpeg/node-fluent-ffmpeg/issues/261
 * https://github.com/mscdex/mmmagic/issues/24
