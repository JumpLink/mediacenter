# var io = require('../third-party/socket.io-client/socket.io.js')
# require('./dependencies/sails.io.js')
require '../third-party/angular/angular.js'
require '../third-party/angular-route/angular-route.js'
require '../third-party/angular-sails/dist/angular-sails.js'

routes = require './routes.coffee'
controllers = require './controllers.coffee'
directives = require './directives.coffee'
services = require './services.coffee'

MediaCenter = angular.module 'MediaCenter', [
  'ngSails',
  'ngRoute'
  ]

MediaCenter.config(routes.routeProvider)
MediaCenter.config(routes.locationProvider)

MediaCenter.service('FilesService', services.FilesService)

MediaCenter.controller('IndexController', controllers.IndexController)
MediaCenter.controller('SailsController', controllers.SailsController)
MediaCenter.controller('FilesController', controllers.FilesController)

MediaCenter.directive('file', directives.file)