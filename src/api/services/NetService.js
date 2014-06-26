var dns = require('dns');
var exec = require('child_process').exec;
    
exports.hasConnection = function(testUrl, callback) {
  dns.resolve(testUrl, function (err) {
    if (err) {
      sails.log.error(err);
      callback (false);
    } else {
      callback (true);
    }
  });
};

exports.reconnect = function (dev, cb) {
  // for raspian
  exec('sudo ifdown '+dev+'; sudo ifup '+dev, function (error, stdout, stderr) { 
    sails.log.debug(stdout);
    if (error || stderr) {
      sails.log.error(error);
      sails.log.error(stderr);
      return cb({error:error,stderr:stderr});
    } else return cb(null);
  });
}
