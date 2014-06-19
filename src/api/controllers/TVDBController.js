/**
 * FilesController
 *
 * @description :: Server-side logic for managing files
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var TVDB = require("tvdb")
var tvdb = new TVDB({ apiKey: sails.config.TVDB.key });

module.exports = {

  /**
   * `FilesController.readdir()`
   */
  getLanguages: function (req, res) {
    sails.log.info("getLanguages");
    tvdb.getLanguages(function(error, result) {
      if(error) return res.serverError(error);
      else return res.json(result);
    });
  }

  , setLanguage: function (req, res) {
    var lang = req.param('lang') ? req.param('lang') : 'en';
    sails.log.info("setLanguage: "+lang);
    tvdb.setLanguage(lang)
    return res.ok();
  }


  , getMirrors: function (req, res) {
    sails.log.info("getServerTime");
    tvdb.getMirrors(function(error, result) {
      if(error) return res.serverError(error);
      else return res.json(result);
    });
  }

  , getServerTime: function (req, res) {
    sails.log.info("getServerTime");
    tvdb.getServerTime(function(error, result) {
      if(error) return res.serverError(error);
      else return res.json(result);
    });
  }

  /**
   * `FilesController.detectFile()`
   */
  , findTvShow: function (req, res) {
    var query = req.param('query') ? req.param('query') : null;
    sails.log.info("findTvShow: "+query);
    tvdb.findTvShow(query, function(error, result) {
      if(error) return res.serverError(error);
      else return res.json(result);
    });
  }

  /**
   * `FilesController.detectFile()`
   */
  , getInfo: function (req, res) {
    var id = req.param('id') ? req.param('id') : null;
    sails.log.info("getInfo: "+id);
    tvdb.getInfo(id, function(error, result) {
      if(error) return res.serverError(error);
      else return res.json(result);
    });
  }

  /**
   * `FilesController.detectFile()`
   */
  , getInfoTvShow: function (req, res) {
    var query = req.param('id') ? req.param('id') : null;
    sails.log.info("getInfoTvShow: "+id);
    tvdb.getInfoTvShow(id, function(error, result) {
      if(error) return res.serverError(error);
      else return res.json(result);
    });
  }

  /**
   * `FilesController.detectFile()`
   */
  , getInfoEpisode: function (req, res) {
    var id = req.param('id') ? req.param('id') : null;
    sails.log.info("getInfoEpisode: "+id);
    tvdb.getInfoEpisode(id, function(error, result) {
      if(error) return res.serverError(error);
      else return res.json(result);
    });
  }

  /**
   * `FilesController.detectFile()`
   */
  , getUpdates: function (req, res) {
    var period = req.param('period') ? req.param('period') : null;
    sails.log.info("getUpdates: "+id);
    tvdb.getUpdates(period, function(error, result) {
      if(error) return res.serverError(error);
      else return res.json(result);
    });
  }
};

