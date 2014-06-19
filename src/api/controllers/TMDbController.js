/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var mdb = require('moviedb')(sails.config.TMDb.key);

module.exports = {

  /**
   * `FilesController.readdir()`
   */
  movieInfo: function (req, res) {
    var id = req.param('id') ? req.param('id') : null;
    mdb.movieInfo({id: id}, function(error, result) {
      if(error) return res.serverError(error);
      else return res.json(result);
    });
  }

  /**
   * `FilesController.detectFile()`
   */
  , searchMovie: function (req, res) {
    var query = req.param('query') ? req.param('query') : null;
    sails.log.info("searchMovie: "+query);
    mdb.searchMovie({query: query}, function(error, result) {
      if(error) return res.serverError(error);
      else return res.json(result);
    });
  }

  , movieImages: function (req, res) {
    var id = req.param('id') ? req.param('id') : null;
    mdb.movieImages({id: id}, function(error, result) {
      if(error) return res.serverError(error);
      else return res.json(result);
    });
  }

  , configuration: function (req, res) {
    mdb.configuration(function(error, result) {
      if(error) return res.serverError(error);
      else return res.json(result);
    });
  }

};

