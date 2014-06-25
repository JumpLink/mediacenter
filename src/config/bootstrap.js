/**
 * Bootstrap
 * (sails.config.bootstrap)
 *
 * An asynchronous bootstrap function that runs before your Sails app gets lifted.
 * This gives you an opportunity to set up your data model, run jobs, or perform some special logic.
 *
 * For more information on bootstrapping your app, check out:
 * http://links.sailsjs.org/docs/config/bootstrap
 */

var exec = require('child_process').exec;
var os=require('os');
var qrcode = require('qrcode-terminal');
var Path = require('path');
var spawn = require('child_process').spawn

var checkConfig = function (cb) {
  if(typeof sails.config.TMDb == 'undefined')
    sails.config.TMDb = { key: 'not set'};
  if(sails.config.TMDb == 'not set' || sails.config.TMDb == 'insert your TMDb api key here' || sails.config.TMDb == '')
    sails.log.warn("Your TMDb Key is not set, for more information see https://www.themoviedb.org/documentation/api");

  if(typeof sails.config.TVDB == 'undefined')
    sails.config.TVDB = { key: 'not set'};
  if(sails.config.TVDB == 'not set' || sails.config.TVDB == 'insert your TVDB api key here' || sails.config.TVDB == '')
    sails.log.warn("Your TVDB Key is not set, for more information see http://thetvdb.com/?tab=apiregister");

  if(typeof sails.config.kioskBrowser == 'undefined') {
    sails.config.kioskBrowser = { start: false, timeout: 50000 }
    sails.log.warn("sails.config.kioskBrowser is not defined, please check your config/local.js");
  }
  if(typeof sails.config.printServerDetails == 'undefined') {
    sails.config.printServerDetails = { start: true, timeout: 5000 }
    sails.log.warn("sails.config.printServerDetails is not defined, please check your config/local.js");
  }
  cb(null);
}

var getCPUArch = function (cb) {
  exec('uname -m', function (error, stdout, stderr) { 
    if (error) return cb(error);
    else return cb(null, stdout.trim().replace(/\n$/, ''));
  });
}

var startKioskBrowser = function () {
  if(sails.config.kioskBrowser.start) {
    setTimeout(function(){
      getCPUArch(function(error, arch) {
        if (error) return sails.log.error(error);
        else {
          sails.log.debug(arch);
          var browser = Path.normalize(__dirname + "/../../bin/browser_"+arch);
          spawn(browser, ['http://localhost:'+sails.config.port+"/server"], {stdio: [ 'ignore', 'ignore', 'ignore' ]});
        } 
      });
    }, sails.config.kioskBrowser.timeout);
  }

  
  // var browser = __dirname + "../bin/"

}

var printServerDetails = function () {
  if(sails.config.printServerDetails.start) {
    setTimeout(function(){
      var ifaces = os.networkInterfaces();
      // sails.log.debug(ifaces);
      Object.keys(ifaces).forEach(function(key) {
        if(key != 'lo') {
          var dev = ifaces[key];
          // sails.log.debug(key);
          // sails.log.debug(dev);

          dev.forEach(function(addressObject) {
            // sails.log.debug(addressObject);
            if(addressObject.family == 'IPv4') {
              console.log("");
              sails.log.info("To control your mediacenter, visit http://"+addressObject.address+":"+sails.config.port+" with your browser.");
              sails.log.info("")
              sails.log.info("Or scan this QR-Code:");
              qrcode.generate("http://"+addressObject.address+":"+sails.config.port, function (qrcode) {
                  // console.log(qrcode);
                  var lines = qrcode.split(/\r\n|[\n\r\u0085\u2028\u2029]/g);
                  lines.forEach(function(line) {
                    sails.log.info(line);
                  });
              });
            }
          });
        }
      });
    }, sails.config.printServerDetails.timeout);
  }
}

module.exports.bootstrap = function(cb) {

  // It's very important to trigger this callack method when you are finished
  // with the bootstrap!  (otherwise your server will never lift, since it's waiting on the bootstrap)

  printServerDetails();
  startKioskBrowser();
  checkConfig(function (error) {
    cb();
  })
  
};
