/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */



var Ffplay = require('ffplaycontrol');
var Path = require('path')
var ffplay = null;

var player = {
  status: 'stop' // stop | play | pause
}

module.exports = {

  info: function (req, res) {
    return res.json(player);
  },

  /**
   * `ffplayController.start()`
   */
  start: function (req, res) {
    var path = req.param('id') ? req.param('id') : req.param('filename') ? req.param('filename') : req.param('path') ? req.param('path') : null;
    if(path != null) {
      path = Path.normalize(path);
      sails.log.debug("play "+path);

      if(ffplay != null) {
        ffplay._resume();
        ffplay._stop();
      }
      
      ffplay = new Ffplay(path);
      ffplay.start({fs: '-autoexit'});

      // TODO FIXME
      // ffplay.on('start', function (stream) {
      //   sails.log.debug('Event: start');
      //   player.status = 'play';
      //   sails.sockets.broadcast('player', 'start', {room: 'player', model: 'FFPlay'});
      // });

      // WORKAROUND for bug on top
      player.status = 'play';
      sails.sockets.broadcast('player', 'start', {room: 'player', model: 'FFPlay'});
      

      ffplay.on('complete', function (stream) {
        sails.log.debug('Event: complete');
        player.status = 'stop';
        sails.sockets.broadcast('player', 'complete', {room: 'player', model: 'FFPlay'});
      });

      ffplay.on('pause', function (stream) {
        sails.log.debug('Event: pause');
        player.status = 'pause';
        sails.sockets.broadcast('player', 'pause', {room: 'player', model: 'FFPlay'});
      });

      ffplay.on('resume', function (stream) {
        sails.log.debug('Event: resume');
        player.status = 'play';
        sails.sockets.broadcast('player', 'resume', {room: 'player', model: 'FFPlay'});
      });

      ffplay.on('stop', function (stream) {
        sails.log.debug('Event: stop');
        player.status = 'stop';
        sails.sockets.broadcast('player', 'stop', {room: 'player', model: 'FFPlay'});
      });
      
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

  , toggle_pause: function (req, res) {
    sails.log.debug("toggle_pause");
    ffplay.toggle_pause();
    return res.ok();
  }

  , stop: function (req, res) {
    sails.log.debug("stop");
    ffplay._resume();
    ffplay.stop();
    return res.ok();
  }

  , resume: function (req, res) {
    sails.log.debug("resume");
    ffplay.resume();
    return res.ok();
  }
};

