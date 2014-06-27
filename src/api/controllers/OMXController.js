/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var Omx = require('omxcontrol');
var omx = Omx.player;
var emitter = Omx.emitter;
var Path = require('path')

emitter.on('start', function (filename) {
  sails.log.debug('omxplayer event: start');
  PlayerService.onStart(filename);
});

emitter.on('pause', function (stream) {
  sails.log.debug('omxplayer event: pause');
  PlayerService.onPause();
});

emitter.on('resume', function (stream) {
  sails.log.debug('omxplayer event: resume');
  PlayerService.onResume();
}); 

emitter.on('stop', function (stream) {
  sails.log.debug('omxplayer event: stop');
  PlayerService.onStop();
});

emitter.on('complete', function (stream) {
  sails.log.debug('omxplayer event: complete');
  PlayerService.onStop();
});

emitter.on('volume_up', function (stream) {
  sails.log.debug('omxplayer event: volume_up');
  PlayerService.onVolumeUp();
});

emitter.on('volume_down', function (stream) {
  sails.log.debug('omxplayer event: volume_down');
  PlayerService.onVolumeDown();
});

emitter.on('forward', function (stream) {
  sails.log.debug('omxplayer event: forward');
  PlayerService.onForward();
});

emitter.on('backward', function (stream) {
  sails.log.debug('omxplayer event: backward');
  PlayerService.onBackward();
});

emitter.on('next_subtitle', function (stream) {
  sails.log.debug('omxplayer event: next_subtitle');
  PlayerService.onNextSubtitle();
});

emitter.on('previous_subtitle', function (stream) {
  sails.log.debug('omxplayer event: previous_subtitle');
  PlayerService.onPreviousSubtitle();
});

emitter.on('next_chapter', function (stream) {
  sails.log.debug('omxplayer event: next_chapter');
  PlayerService.onNextChapter();
});

emitter.on('previous_chapter', function (stream) {
  sails.log.debug('omxplayer event: previous_chapter');
  PlayerService.onPreviousChapter();
});

emitter.on('next_audio', function (stream) {
  sails.log.debug('omxplayer event: next_audio');
  PlayerService.onNextAudio();
});

emitter.on('previous_audio', function (stream) {
  sails.log.debug('omxplayer event: previous_audio');
  PlayerService.onPreviousAudio();
});

emitter.on('increase_speed', function (stream) {
  sails.log.debug('omxplayer event: increase_speed');
  PlayerService.onIncreaseSpeed();
});

emitter.on('decrease_speed', function (stream) {
  sails.log.debug('omxplayer event: decrease_speed');
  PlayerService.onDecreaseSpeed();
});

module.exports = {
  /**
   * `OMXController.start()`
   */
  start: function (req, res) {
    var path = req.param('id') ? req.param('id') : req.param('filename') ? req.param('filename') : req.param('path') ? req.param('path') : null;
    if(path != null) {
      path = Path.normalize(path);
      sails.log.debug("start "+path);
      omx.start(path);
      return res.ok();
    } else {
      return res.serverError("No path");
    }
  }

  /**
   * `OMXController.pause()`
   */
  , pause: function (req, res) {
    sails.log.debug("OMXController.pause");
    omx.pause();
    return res.ok();
  }

  , resume: function (req, res) {
    sails.log.debug("OMXController.resume");
    omx.resume();
    return res.ok();
  }

  , toggle_pause: function (req, res) {
    sails.log.debug("OMXController.toggle_pause");
    PlayerService.info(function (player) {
      if(player.status === 'play') omx.pause();
      if(player.status === 'pause') omx.resume();
      return res.ok();
    });
  }

  , play: function (req, res) {
    sails.log.debug("OMXController.play");
    omx.play();
    return res.ok();
  }

  , volume_up: function (req, res) {
    sails.log.debug("OMXController.volume_up");
    omx.volume_up();
    return res.ok();
  }

  , volume_down: function (req, res) {
    sails.log.debug("OMXController.volume_down");
    omx.volume_down();
    return res.ok();
  }

  , quit: function (req, res) {
    sails.log.debug("OMXController.quit");
    omx.quit();
    return res.ok();
  }

  // Alias
  , stop: function (req, res) {
    sails.log.debug("OMXController.stop");
    omx.stop();
    return res.ok();
  }

  , forward: function (req, res) {
    sails.log.debug("OMXController.forward");
    omx.forward();
    return res.ok();
  }

  , backward: function (req, res) {
    sails.log.debug("OMXController.backward");
    omx.backward();
    return res.ok();
  }

  , next_subtitle: function (req, res) {
    sails.log.debug("OMXController.next_subtitle");
    omx.next_subtitle();
    return res.ok();
  }

  , previous_subtitle: function (req, res) {
    sails.log.debug("OMXController.previous_subtitle");
    omx.previous_subtitle();
    return res.ok();
  }

  , next_chapter: function (req, res) {
    sails.log.debug("OMXController.next_chapter");
    omx.next_chapter();
    return res.ok();
  }

  , previous_chapter: function (req, res) {
    sails.log.debug("OMXController.previous_chapter");
    omx.previous_chapter();
    return res.ok();
  }

  , next_audio: function (req, res) {
    sails.log.debug("OMXController.next_audio");
    omx.next_audio();
    return res.ok();
  }

  , previous_audio: function (req, res) {
    sails.log.debug("OMXController.previous_audio");
    omx.previous_audio();
    return res.ok();
  }

  , increase_speed: function (req, res) {
    sails.log.debug("OMXController.increase_speed");
    omx.increase_speed();
    return res.ok();
  }

  , decrease_speed: function (req, res) {
    sails.log.debug("OMXController.decrease_speed");
    omx.decrease_speed();
    return res.ok();
  }
};

