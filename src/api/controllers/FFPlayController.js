/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */



var Ffplay = require('ffplaycontrol');
var Path = require('path')
var ffplay = null;

module.exports = {
  /**
   * `ffplayController.start()`
   */
  start: function (req, res) {
    var path = req.param('id') ? req.param('id') : req.param('filename') ? req.param('filename') : req.param('path') ? req.param('path') : null;
    if(path != null) {
      path = Path.normalize(path);
      sails.log.debug("play "+path);
      sails.sockets.join(req.socket, 'player');
      console.log(sails.sockets.socketRooms(req.socket));

      if(ffplay != null)
        ffplay.stop();
      
      ffplay = new Ffplay(path);
      ffplay.play({fs: '-autoexit'});

      //   function (error) {
      //   sails.sockets.broadcast('player', 'exit', {event: 'exit', error: error, from: req.session.userId, room: 'player', model: 'FFPlay'});
      // });

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
    ffplay.stop();
    return res.ok();
  }

  , resume: function (req, res) {
    sails.log.debug("resume");
    ffplay.resume();
    return res.ok();
  }
};

