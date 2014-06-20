/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var extend = require("extend"); // https://github.com/justmoon/node-extend
var fs = require("fs");
var Path = require('path')
var mmm = require('mmmagic');
var Magic = mmm.Magic;
var Ffmpeg = require('fluent-ffmpeg');

var mime = require('mime'); // WORKAROUND for https://github.com/mscdex/mmmagic/issues/24

module.exports = {
	


  /**
   * `FilesController.readdir()`
   */
  readdir: function (req, res) {
    var dirToRead = req.param('id') ? req.param('id') : req.param('path') ? req.param('path') : '/';
    dirToRead = Path.normalize(dirToRead);
    fs.exists(dirToRead, function (exists) {
      if(!exists) return res.serverError('path not found');
      else {
        fs.readdir(dirToRead, function (err, files) {
          if (err) return res.serverError(err);
          else return res.json({files:files});
        });
      }
    });
  }

  , exists: function (req, res) {
    var dirToRead = req.param('id') ? req.param('id') : req.param('path') ? req.param('path') : '/';
    dirToRead = Path.normalize(dirToRead);
    fs.exists(dirToRead, function (exists) {
      return res.json({exists:exists});
    });
  }

  , getJson: function (req, res) {
    var path = req.param('id') ? req.param('id') : req.param('path') ? req.param('path') : '/';
    path = Path.normalize(path);
    fs.exists(path, function (exists) {
      if(exists) return res.json(require(path));
      else return res.serverError("Json not found");
    });
    
    
  }

  /**
   * `FilesController.detectFile()`
   */
  , detectFile: function (req, res) {

    var filePath = req.param('id') ? req.param('id') : req.param('path') ? req.param('path') : '/';
    filePath = Path.normalize(filePath);
    var dirname = Path.dirname(filePath);
    var name = Path.basename(filePath);
    var extension = Path.extname(filePath);

    var file = {name: name, path: filePath, dirname: dirname, extension: extension};

    var magic = new Magic(mmm.MAGIC_MIME_TYPE);
    sails.log.debug ("detectFile "+file.path);

    fs.exists(file.path, function (exists) {
      if (!exists) return res.serverError('File not found');
      fs.stat(file.path, function (err, stats) {
        if (err) return res.serverError(err);
        extend(file, stats);

        magic.detectFile(file.path, function(err, mime_type) {
          if (err) return res.serverError(err);
          else {
            // WORKAROUND for https://github.com/mscdex/mmmagic/issues/24
            switch (mime_type) {
              case 'application/ogg':
                mime_type = mime.lookup(file.extension);
              break;
            }
            types = mime_type.split('/');
            if(types.length != 2) return res.serverError('Corrupt MIME-Type');
             
            extend(file, {mimetype: mime_type, mediatype: types[0], subtype: types[1]});

            if(file.mediatype == 'video') {
              Ffmpeg.ffprobe(file.path, function(err, metadata) {
                if (err) {
                  err.note = "Be sure you have ffmpeg installed."
                  return res.serverError(err);
                }
                file.metadata = metadata;
                return res.json(file);
              });
            } else {
              return res.json(file);
            }
          }
        });
      });
    });

  }

};

