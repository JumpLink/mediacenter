/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */



var ffplay = require('ffplaycontrol');
var Path = require('path')

module.exports = {
  /**
   * `ffplayController.start()`
   */
  start: function (req, res) {
    var path = req.param('id') ? req.param('id') : req.param('filename') ? req.param('filename') : req.param('path') ? req.param('path') : null;
    if(path != null) {
      path = Path.normalize(path);
      sails.log.debug("start "+path);
      ffplay.start(path);
      return res.ok();
    } else {
      return res.serverError("No path");
    }
  }

  /**
   * `ffplayController.pause()`
   */
  , pause: function (req, res) {
    sails.log.debug("pause");
    ffplay.pause();
    return res.ok();
  }

  , play: function (req, res) {
    sails.log.debug("play");
    ffplay.play();
    return res.ok();
  }

  , quit: function (req, res) {
    sails.log.debug("quit");
    ffplay.quit();
    return res.ok();
  }

  , forward: function (req, res) {
    sails.log.debug("forward");
    ffplay.forward();
    return res.ok();
  }

  , backward: function (req, res) {
    sails.log.debug("backward");
    ffplay.backward();
    return res.ok();
  }

  , next_subtitle: function (req, res) {
    sails.log.debug("next_subtitle");
    ffplay.next_subtitle();
    return res.ok();
  }

  , next_audio: function (req, res) {
    sails.log.debug("next_audio");
    ffplay.next_audio();
    return res.ok();
  }

  , next_video: function (req, res) {
    sails.log.debug("next_video");
    ffplay.next_video();
    return res.ok();
  }

  , full_screen: function (req, res) {
    sails.log.debug("full_screen");
    ffplay.full_screen();
    return res.ok();
  }
};

