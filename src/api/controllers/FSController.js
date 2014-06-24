/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var extend = require("extend"); // https://github.com/justmoon/node-extend
var fs = require("fs");
var Path = require('path')

module.exports = {
	


  /**
   * `FilesController.readdir()`
   */
  readdir: function (req, res) {
    var dirToRead = req.param('id') ? req.param('id') : req.param('path') ? req.param('path') : '/';
    dirToRead = Path.normalize(dirToRead);
    fs.exists(dirToRead, function (exists) {
      if(!exists) return res.notFound('path not found');
      else {
        fs.readdir(dirToRead, function (err, files) {
          if (err) return res.badRequest(err);
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
      else return res.notFound("Json not found");
    });
  }

  /**
   * `FilesController.detectFile()`
   */
  , detectFile: function (req, res) {
    var filePath = req.param('id') ? req.param('id') : req.param('path') ? req.param('path') : '/';
    FSService.detectFile(filePath, function (error, file) {
      if(error != null) return res.serverError(error);
      else return res.json(file);
    });
  }
};

