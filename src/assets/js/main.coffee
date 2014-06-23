
require '../third-party/angular/angular.js'
require '../third-party/angular-route/angular-route.js'

#io = require '../third-party/socket.io-client/socket.io.js'
# require './dependencies/socket.io.js'
# console.log io

# sailsio = require './dependencies/sails.io.js'
# io = sailsio.SailsIOClient(io)
# console.log io

require '../third-party/angular-sails/dist/angular-sails.js'
# require '../third-party/qrcode-generator/js/qrcode.js' see script tag in index.jade
require '../third-party/angular-qrcode/qrcode.js'
# require '../third-party/moment/moment.js' see script tag in index.jade
require '../third-party/angular-moment/angular-moment.js'


routes = require './routes.coffee'
controllers = require './controllers.coffee'
directives = require './directives.coffee'
services = require './services.coffee'
filters = require './filters.coffee'

MediaCenter = angular.module 'MediaCenter', [
  'ngSails'
  'ngRoute'
  'monospaced.qrcode'
  'angularMoment'
]

MediaCenter.config routes.routeProvider
MediaCenter.config routes.locationProvider 

# MediaCenter.provider '$sails', services.sails(io)
MediaCenter.service 'FilesService', services.FilesService
MediaCenter.service 'TVDBService', services.TVDBService
MediaCenter.service 'OmxPlayerService', services.OmxPlayerService
MediaCenter.service 'FfplayPlayerService', services.FfplayPlayerService
MediaCenter.service 'PlayerService', services.PlayerService
MediaCenter.service 'async', () ->
  return require '../third-party/async/lib/async.js'

MediaCenter.filter 'bytes', filters.bytes

MediaCenter.controller 'IndexController', controllers.IndexController
MediaCenter.controller 'SailsController', controllers.SailsController
MediaCenter.controller 'FilesController', controllers.FilesController
MediaCenter.controller 'ServerController', controllers.ServerController
MediaCenter.controller 'FileInfoController', controllers.FileInfoController

MediaCenter.directive 'file', directives.file
MediaCenter.directive 'videofile', directives.videofile
MediaCenter.directive 'playcontrol', directives.playcontrol