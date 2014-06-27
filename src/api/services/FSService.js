var extend = require("extend"); // https://github.com/justmoon/node-extend
var fs = require("fs");
var Path = require('path')
var mmm = require('mmmagic');
var Magic = mmm.Magic;
var Ffmpeg = require('fluent-ffmpeg');

var mime = require('mime'); // WORKAROUND for https://github.com/mscdex/mmmagic/issues/24

var getJson = function (path, callback) {
  path = Path.normalize(path);
  fs.exists(path, function (exists) {
    if(exists) return callback(null, require(path));
    else return callback("Json not found");
  });
}
exports.getJson = getJson;

var getMetaDataJsonFileName = function (fileName) {
  return "." + fileName + ".json"
}

var getMetaDataJson = function (fileName, dirname, callback) {
  var name = getMetaDataJsonFileName(fileName);
  var path = dirname + "/" + name
  fs.exists(path, function (exists) {
    if(exists) {
      getJson(path, function (error, file) {
        callback(error, file);
      });
    } else {
      callback("not found");
    }
  });
}

exports.ffprobe = function (filePath, callback) {
  filePath = Path.normalize(filePath);
  fs.exists(filePath, function (exists) {
    if(exists) {
      Ffmpeg.ffprobe(file.path, callback);
    } else {
      callback("File not found")
    }
  });
}
    
exports.detectFile = function(filePath, options, callback) {
  var opt = {
    ffprobe: false, // load metadata with ffprobe
  }
  extend(opt, options);

  filePath = Path.normalize(filePath);
  var dirname = Path.dirname(filePath);
  var name = Path.basename(filePath);
  var extension = Path.extname(filePath);

  var file = {name: name, path: filePath, dirname: dirname, extension: extension};

  var magic = new Magic(mmm.MAGIC_MIME_TYPE);
  sails.log.debug ("detectFile "+file.path);
  sails.log.debug (opt);

  fs.exists(file.path, function (exists) {
    if (!exists) return callback('File not found');
    fs.stat(file.path, function (err, stats) {
      if (err) return callback(err);
      extend(file, stats);

      magic.detectFile(file.path, function(err, mime_type) {
        if (err) return callback(err);
        else {
          // WORKAROUND for https://github.com/mscdex/mmmagic/issues/24
          switch (mime_type) {
            case 'application/ogg':
              mime_type = mime.lookup(file.extension);
            break;
          }
          types = mime_type.split('/');
          if(types.length != 2) return callback('Corrupt MIME-Type');
           
          extend(file, {mimetype: mime_type, mediatype: types[0], subtype: types[1]});

          if(file.mediatype == 'video') {
            file.metadata = {};
            getMetaDataJson(file.name, file.dirname, function (error, json) {
              if(!error) extend(file.metadata, json);
              if(opt.ffprobe) {
                Ffmpeg.ffprobe(file.path, function(err, metadata) {
                  if (err) {
                    err.note = "Be sure you have ffmpeg installed."
                    return callback(err);
                  }
                  if(typeof file.metadata != 'undefined')
                    extend(file.metadata, metadata);
                  else
                    file.metadata = metadata;
                  return callback(null, file);
                });
              } else {
                callback(null, file);
              }
            });
          } else {
            return callback(null, file);
          }
        }
      });
    });
  });
};