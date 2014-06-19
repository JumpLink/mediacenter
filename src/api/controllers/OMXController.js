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

  , next_subtitle: function (req, res) {
    sails.log.debug("next_subtitle");
    omx.next_subtitle();
    return res.ok();
  }

  , previous_subtitle: function (req, res) {
    sails.log.debug("previous_subtitle");
    omx.previous_subtitle();
    return res.ok();
  }

  , next_chapter: function (req, res) {
    sails.log.debug("next_chapter");
    omx.next_chapter();
    return res.ok();
  }

  , previous_chapter: function (req, res) {
    sails.log.debug("previous_chapter");
    omx.previous_chapter();
    return res.ok();
  }

  , next_audio: function (req, res) {
    sails.log.debug("next_audio");
    omx.next_audio();
    return res.ok();
  }

  , previous_audio: function (req, res) {
    sails.log.debug("previous_audio");
    omx.previous_audio();
    return res.ok();
  }

  , increase_speed: function (req, res) {
    sails.log.debug("increase_speed");
    omx.increase_speed();
    return res.ok();
  }

  , decrease_speed: function (req, res) {
    sails.log.debug("decrease_speed");
    omx.decrease_speed();
    return res.ok();
  }
};

