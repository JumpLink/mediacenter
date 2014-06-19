/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */



var omx = require('omxcontrol');

module.exports = {
  /**
   * `OMXController.start()`
   */
  start: function (req, res) {
    var filename = req.param('id') ? req.param('id') : req.param('filename') ? req.param('filename') : req.param('path') ? req.param('path') : null;
    if(filename != null) {
      sails.log.debug("start "+filename);
      omx.start(filename);
      return res.ok();
    } else {
      return res.serverError("No filename");
    }
  }

  /**
   * `OMXController.pause()`
   */
  , pause: function (req, res) {
    sails.log.debug("pause");
    omx.pause();
    return res.ok();
  }

  , play: function (req, res) {
    sails.log.debug("play");
    omx.play();
    return res.ok();
  }

  , volume_up: function (req, res) {
    sails.log.debug("volume_up");
    omx.volume_up();
    return res.ok();
  }

  , volume_down: function (req, res) {
    sails.log.debug("volume_down");
    omx.volume_down();
    return res.ok();
  }

  , quit: function (req, res) {
    sails.log.debug("quit");
    omx.quit();
    return res.ok();
  }

  , forward: function (req, res) {
    sails.log.debug("forward");
    omx.forward();
    return res.ok();
  }

  , backward: function (req, res) {
    sails.log.debug("backward");
    omx.backward();
    return res.ok();
  }

};

