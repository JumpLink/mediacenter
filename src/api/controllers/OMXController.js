/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var Omx = require('omxcontrol');
var omx = new Omx();
var Path = require('path')

omx.on('start', function (filename) {
  sails.log.debug('omxplayer event: start');
  PlayerService.onStart(filename);
});

omx.on('pause', function (stream) {
  sails.log.debug('omxplayer event: pause');
  PlayerService.onPause();
});

omx.on('resume', function (stream) {
  sails.log.debug('omxplayer event: resume');
  PlayerService.onResume();
}); 

omx.on('stop', function (stream) {
  sails.log.debug('omxplayer event: stop');
  PlayerService.onStop();
});

omx.on('complete', function (stream) {
  sails.log.debug('omxplayer event: complete');
  PlayerService.onStop();
});

omx.on('volume_up', function (stream) {
  sails.log.debug('omxplayer event: volume_up');
  PlayerService.onVolumeUp();
});

omx.on('volume_down', function (stream) {
  sails.log.debug('omxplayer event: volume_down');
  PlayerService.onVolumeDown();
});

omx.on('forward', function (stream) {
  sails.log.debug('omxplayer event: forward');
  PlayerService.onForward();
});

omx.on('backward', function (stream) {
  sails.log.debug('omxplayer event: backward');
  PlayerService.onBackward();
});

omx.on('next_subtitle', function (stream) {
  sails.log.debug('omxplayer event: next_subtitle');
  PlayerService.onNextSubtitle();
});

omx.on('previous_subtitle', function (stream) {
  sails.log.debug('omxplayer event: previous_subtitle');
  PlayerService.onPreviousSubtitle();
});

omx.on('next_chapter', function (stream) {
  sails.log.debug('omxplayer event: next_chapter');
  PlayerService.onNextChapter();
});

omx.on('previous_chapter', function (stream) {
  sails.log.debug('omxplayer event: previous_chapter');
  PlayerService.onPreviousChapter();
});

omx.on('next_audio', function (stream) {
  sails.log.debug('omxplayer event: next_audio');
  PlayerService.onNextAudio();
});

omx.on('previous_audio', function (stream) {
  sails.log.debug('omxplayer event: previous_audio');
  PlayerService.onPreviousAudio();
});

omx.on('increase_speed', function (stream) {
  sails.log.debug('omxplayer event: increase_speed');
  PlayerService.onIncreaseSpeed();
});

omx.on('decrease_speed', function (stream) {
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

