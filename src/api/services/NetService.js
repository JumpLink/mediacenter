var dns = require('dns');
    
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