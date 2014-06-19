/**
 * SystemController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var os=require('os');

module.exports = {
  


  /**
   * `SystemController.readdir()`
   */
  ifaces: function (req, res) {
    var ifaces = os.networkInterfaces();
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


};

