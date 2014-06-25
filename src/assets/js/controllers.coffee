exports.IndexController = ($scope, $log, $sails, $http, transport, $interval) ->

  timer = null;

  getUserHome = (callback) ->
    url = "/os/home"
    switch transport
      when 'socket'
        $sails.get url
          .success (response) ->
            callback(null, response)
          .error (response) ->
            callback(response)
      else
        $http {method: 'GET', url: url}
          .success (data, status, headers, config) ->
            callback(null, data)
          .error (data, status, headers, config) ->
            callback(data)

  getDeviceList = () ->
    url = "/fs/readdir?path=/media"
    switch transport
      when 'socket'
        $sails.get "/fs/readdir?path=/media"
          .success (response) ->
            $scope.devices = response.files
            $log.debug response
          .error (response) ->
            $log.error response
      else
        $http {method: 'GET', url: url}
          .success (data, status, headers, config) ->
            $scope.devices = data.files
          .error (data, status, headers, config) ->
            $log.error data

  getDeviceList()

  getUserHome (error, data) ->
    $scope.home = data

  timer = $interval () ->
    getDeviceList()
  , 5000

  $scope.$on '$destroy', () ->
    if timer and timer != null
      $interval.cancel(timer)

exports.SailsController = ($scope) ->
  $scope.test = 'test';

exports.ServerController = ($scope, $sails, $location, $log, $interval) ->
  $sails.get "/os/ifaces"
    .success (response) ->
      $scope.addresses = {}
      angular.forEach response, (dev, name) ->
        if name != 'lo'
          angular.forEach dev, (addressObject, index) ->
            if addressObject.family == 'IPv4'
              $scope.addresses[name] = addressObject

    .error (response) ->
      $log.error if response then angular.toJson response.error else "Can't read file dir "+currentPath

  $scope.port = $location.port()

  
  $interval () ->
    $scope.moment = moment()
  , 1000

exports.FileInfoController = ($rootScope, $scope, $log, FilesService, $routeParams, PlayerService) ->
  # TODO optimieren erst zum schluss
  loadFileFromRootScope = angular.isDefined($routeParams.global) == true
  if loadFileFromRootScope
    $scope.file = $rootScope.file
  else
    path = FilesService.getCurrentPath();
    FilesService.getFile path, (error, file) ->
      if error?
        $log.error(error)
      else
        $scope.file = file
        if file.path != path
          $log.warn file.path+" != "+path

  $scope.start = () ->
    PlayerService.start $scope.file.path, (err) ->
      if err then $log.error(err)

exports.FilesController = ($scope, $sails, $log, FilesService) ->

  currentPath = FilesService.getCurrentPath()
  FilesService.getFileList currentPath, (error, files) ->
    if angular.isDefined(error) and error != null
      $log.error error
    else
      $scope.files = files