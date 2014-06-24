/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */



var Ffplay = require('ffplaycontrol');
var Path = require('path')
var ffplay = null;
var moment = require('moment');

var player = {
  status: 'stop', // stop | play | pause
  start: null,
  duration: moment.duration(0)
}

var humanizeDuration = function (duration) {
  return duration.hours() + ":" + duration.minutes() + ":" + duration.seconds()
} 

var updateDuration = function () {
  if(player.status == 'play') {
    var now = moment();
    var old_duration = moment.duration(player.duration); // duration before
    if (player.start != null)
      var diff = now.diff(player.start);
    else
      var diff = 0;
    player.duration = moment.duration(diff); // curent duration is the diff from now to start
    player.duration.add(old_duration); // add the duration before
    player.start = now;
  }
}

var onStop = function () {
  if(player.status != 'stop') {
    player.status = 'stop';

    player.start = null;
    player.duration = moment.duration(0);

    sails.log.debug("duration: "+humanizeDuration(player.duration));

    sails.sockets.broadcast('player', 'stop', {room: 'player', model: 'FFPlay', player: player});
  } else
  sails.log.warn("Player is already stopped!");
}

var onStart = function (path) {
  if(player.status != 'play') {
    player.status = 'play';

    // on video start duration is 0 and start is now
    var now = moment();
    player.duration = moment.duration(0);
    player.start = now;

    sails.log.debug("duration: "+humanizeDuration(player.duration));

    FSService.detectFile(path, function (error, file) {
      if(error != null) return res.serverError(error);
      else {
        player.file = file;
        sails.sockets.broadcast('player', 'start', {room: 'player', model: 'FFPlay', player: player});
      }
    });

  } else
  sails.log.warn("Player is already on playing!");
}

var onPause = function () {
  if(player.status != 'pause') {
    player.status = 'pause';

    var now = moment();
    var old_duration = moment.duration(player.duration); // duration before
    if (player.start != null)
      var diff = now.diff(player.start);
    else
      var diff = 0;
    player.duration = moment.duration(diff); // curent duration is the diff from now to start
    player.duration.add(old_duration); // add the duration before
    player.start = null;

    sails.log.debug("duration: "+humanizeDuration(player.duration));

    sails.sockets.broadcast('player', 'pause', {room: 'player', model: 'FFPlay', player: player});
  } else
  sails.log.warn("Player is already in pause!");
}

var onResume = function () {
  if(player.status != 'play') {
    player.status = 'play';

    // play time is now because the duration before is saved in player.duration
    var now = moment();
    player.start = now;

    sails.log.debug("duration: "+humanizeDuration(player.duration));

    sails.sockets.broadcast('player', 'resume', {room: 'player', model: 'FFPlay', player: player});
  } else
  sails.log.warn("Player is already resumed!");
}

module.exports = {

  info: function (req, res) {
    sails.log.debug("ffplay info ");
    updateDuration();
    return res.json({player:player});
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

      // TODO use event
      onStart(path);

      // FIXME
      // ffplay.on('start', function (stream) {
      //   sails.log.debug('Event: start');
      //   onStart();
      // });


      ffplay.on('pause', function (stream) {
        sails.log.debug('Event: pause');
        onPause();
      });

      ffplay.on('resume', function (stream) {
        sails.log.debug('Event: resume');
        onResume();
      }); 

      ffplay.on('stop', function (stream) {
        sails.log.debug('Event: stop');
        onStop();
      });

      ffplay.on('complete', function (stream) {
        sails.log.debug('Event: complete');
        onStop();
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

