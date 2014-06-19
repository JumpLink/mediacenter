/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var fs = require("fs");
var mmm = require('mmmagic');
var Magic = mmm.Magic;

var mime = require('mime'); // WORKAROUND for https://github.com/mscdex/mmmagic/issues/24

module.exports = {
	


  /**
   * `FilesController.readdir()`
   */
  readdir: function (req, res) {
    var dirToRead = req.param('id') ? req.param('id') : req.param('path') ? req.param('path') : '/';
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
    fs.exists(dirToRead, function (exists) {
      return res.json({exists:exists});
    });
  }

  , getJson: function (req, res) {
    var path = req.param('id') ? req.param('id') : req.param('path') ? req.param('path') : '/';
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
    var magic = new Magic(mmm.MAGIC_MIME_TYPE);
    sails.log.debug (filePath);
    magic.detectFile(filePath, function(err, mime_type) {
      if (err) return res.serverError(err);
      else {
        // WORKAROUND for https://github.com/mscdex/mmmagic/issues/24
        switch (mime_type) {
          case 'application/ogg':
            mime_type = mime.lookup(filePath);
          break;
        }
        types = mime_type.split('/');
        if(types.length === 2) return res.json({mimetype: mime_type, mediatype: types[0], subtype: types[1]});
        else return res.serverError('Corrupt MIME-Type');
      }
    });
  }

};

