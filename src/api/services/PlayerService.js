/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

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
  if(player.status != 'stop') player.status = 'stop';
  else sails.log.warn("Player is already stopped!");

  player.start = null;
  player.duration = moment.duration(0);

  sails.log.debug("duration: "+humanizeDuration(player.duration));

  sails.sockets.broadcast('player', 'stop', {room: 'player', player: player});
}

var onStart = function (path) {
  if(player.status != 'play') player.status = 'play';
  else sails.log.warn("Player is already on playing!");

  // on video start duration is 0 and start is now
  var now = moment();
  player.duration = moment.duration(0);
  player.start = now;

  sails.log.debug("duration: "+humanizeDuration(player.duration));

  FSService.detectFile(path, {ffprobe:true}, function (error, file) {
    if(error) sails.log.error(error);
    else player.file = file;
    sails.sockets.broadcast('player', 'start', {room: 'player', player: player});
  });
}

var onPause = function () {
  if(player.status != 'pause') player.status = 'pause';
  else sails.log.warn("Player is already in pause!");

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

  sails.sockets.broadcast('player', 'pause', {room: 'player', player: player});
  
}

var onResume = function () {
  if(player.status != 'play') player.status = 'play';
  else sails.log.warn("Player is already resumed!");

  // play time is now because the duration before is saved in player.duration
  var now = moment();
  player.start = now;

  sails.log.debug("duration: "+humanizeDuration(player.duration));

  sails.sockets.broadcast('player', 'resume', {room: 'player', player: player});
}

var info = function (cb) {
  sails.log.debug("Player info ");
  updateDuration();
  return cb(player);
}

module.exports = {
  info: info,
  onResume: onResume,
  onPause: onPause,
  onStart: onStart,
  onStop: onStop,
  updateDuration: updateDuration,
  humanizeDuration: humanizeDuration
};

