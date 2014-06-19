exports.routeProvider = ($routeProvider) ->
  $routeProvider
  .when "/",
    templateUrl: "index"
    controller: "IndexController"
  .when "/sails",
    templateUrl: "sails"
    controller: "SailsController"
  .when "/server",
    templateUrl: "server"
    controller: "ServerController"
  .when "/files",
    templateUrl: "files"
    controller: "FilesController"
  .otherwise redirectTo: "/"

exports.locationProvider = ($locationProvider) ->
  # use the HTML5 History API
  $locationProvider.html5Mode(true);