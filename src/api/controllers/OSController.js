/**
 * SystemController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var os=require('os');
var exec = require('child_process').exec;

module.exports = {
  


  /**
   * `SystemController.readdir()`
   */
  ifaces: function (req, res) {
    var ifaces = null;
    try {
      ifaces = os.networkInterfaces();
    } catch (error) {
      return res.serverError(error);
    }
    return res.json(ifaces);
  }

  /**
   * `SystemController.halt()`
   * TODO http://linux.byexamples.com/archives/315/how-to-shutdown-and-reboot-without-sudo-password/
   */
  , halt: function (req, res) {
    return res.ok();
  }
  , reboot: function (req, res) {
    return res.ok();
  }
  , exec: function (req, res) {
    var name = req.param('name');
    exec(name, function (error, stdout, stderr) {
      if(error) sails.log.error(error);
    });
    return res.ok();
  }
  , program_exists: function (req, res) {
    var name = req.param('id') ? req.param('id') : req.param('name') ? req.param('name') : null;
    if (name != null) {
      var child = exec("command -v "+name, {env: {DISPLAY: ':0.0'}}, function (error, stdout, stderr) {
        // sails.log.debug(error);
        return res.json({exists:!error});
      });
    } else {
      return res.serverError("No program");
    }
  }

  , home: function (req, res) {
    return res.json({dirname: process.env[(process.platform == 'win32') ? 'USERPROFILE' : 'HOME'], username: process.env['USER']});
  }
};

