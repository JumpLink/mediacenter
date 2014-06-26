/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */



var Ffplay = require('ffplaycontrol');
var Path = require('path')
var ffplay = new Ffplay();
var moment = require('moment');

ffplay.on('start', function (filename) {
  sails.log.debug('Event: start');
  PlayerService.onStart(filename);
});

ffplay.on('pause', function (stream) {
  sails.log.debug('Event: pause');
  PlayerService.onPause();
});

ffplay.on('resume', function (stream) {
  sails.log.debug('Event: resume');
  PlayerService.onResume();
}); 

ffplay.on('stop', function (stream) {
  sails.log.debug('Event: stop');
  PlayerService.onStop();
});

ffplay.on('complete', function (stream) {
  sails.log.debug('Event: complete');
  PlayerService.onStop();
});

module.exports = {

  info: function (req, res) {
    PlayerService.info(function (player){
      return res.json({player:player});
    });
  },

  /**
   * `ffplayController.start()`
   */
  start: function (req, res) {
    var path = req.param('id') ? req.param('id') : req.param('filename') ? req.param('filename') : req.param('path') ? req.param('path') : null;
    if(path != null) {
      PlayerService.info(function (player) {
        if(player.status == 'play' || player.status == 'pause') ffplay.stop();

        path = Path.normalize(path);
        sails.log.debug("play "+path);
        
        ffplay.start(path, {fs: '-autoexit'});

        // TODO use event
        PlayerService.onStart(path);
        return res.ok();
      });
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

  , toggle_pause: function (req, res) {
    sails.log.debug("toggle_pause");
    ffplay.toggle_pause();
    return res.ok();
  }

  , stop: function (req, res) {
    sails.log.debug("stop");
    ffplay.stop();
    return res.ok();
  }

  , quit: function (req, res) {
    sails.log.debug("quit");
    ffplay.quit();
    return res.ok();
  }

  , resume: function (req, res) {
    sails.log.debug("resume");
    ffplay.resume();
    return res.ok();
  }
};

