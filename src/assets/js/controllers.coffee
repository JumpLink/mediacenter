exports.IndexController = ($scope) ->
  $scope.test = 'test';

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

exports.FileInfoController = ($rootScope, $scope, $log, FilesService, $routeParams) ->
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

exports.FilesController = ($scope, $sails, $log, FilesService) ->

  $sails.on 'message', (message) ->
    $log.debug '$sails.on'
    $log.debug message

  currentPath = FilesService.getCurrentPath()
  FilesService.getFileList currentPath, (error, files) ->
    if angular.isDefined(error) and error != null
      $log.error error
    else
      $scope.files = files