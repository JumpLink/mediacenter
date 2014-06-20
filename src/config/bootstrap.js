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

module.exports.bootstrap = function(cb) {

  // It's very important to trigger this callack method when you are finished
  // with the bootstrap!  (otherwise your server will never lift, since it's waiting on the bootstrap)

  setTimeout(function(){
    var os=require('os');
    var ifaces = os.networkInterfaces();
    var qrcode = require('qrcode-terminal');
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
  }, 10000);

  cb();
};
