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
    NetService.hasConnection ('tmdb.org', function (connected) {
      if(connected) {
        var id = req.param('id') ? req.param('id') : null;
        mdb.movieInfo({id: id}, function(error, result) {
          if(error) return res.serverError(error);
          else return res.json(result);
        });
      } else {
        return res.serverError("no internet connection");
      }
    });
  }

  , miscPopularMovies: function (req, res) {
    NetService.hasConnection ('tmdb.org', function (connected) {
      if(connected) {
        mdb.miscPopularMovies(function(error, result) {
          if(error) return res.serverError(error);
          else return res.json(result);
        });
      } else {
        return res.serverError("no internet connection");
      }
    });
  }

  , miscPopularTvs: function (req, res) {
    NetService.hasConnection ('tmdb.org', function (connected) {
      if(connected) {
        mdb.miscPopularTvs(function(error, result) {
          if(error) return res.serverError(error);
          else return res.json(result);
        });
      } else {
        return res.serverError("no internet connection");
      }
    });
  }

  /**
   * `FilesController.detectFile()`
   */
  , searchMovie: function (req, res) {
    NetService.hasConnection ('tmdb.org', function (connected) {
      if(connected) {
        var query = req.param('query') ? req.param('query') : null;
        sails.log.info("searchMovie: "+query);
        mdb.searchMovie({query: query}, function(error, result) {
          if(error) return res.serverError(error);
          else return res.json(result);
        });
      } else {
        return res.serverError("no internet connection");
      }
    });
  }

  , movieImages: function (req, res) {
    NetService.hasConnection ('tmdb.org', function (connected) {
      if(connected) {
        var id = req.param('id') ? req.param('id') : null;
        mdb.movieImages({id: id}, function(error, result) {
          if(error) return res.serverError(error);
          else return res.json(result);
        });
      } else {
        return res.serverError("no internet connection");
      }
    });
  }

  , configuration: function (req, res) {
    NetService.hasConnection ('tmdb.org', function (connected) {
      if(connected) {
        mdb.configuration(function(error, result) {
          if(error) return res.serverError(error);
          else return res.json(result);
        });
      } else {
        return res.serverError("no internet connection");
      }
    });
  }

};

