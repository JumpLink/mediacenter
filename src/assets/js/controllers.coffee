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

exports.FilesController = ($scope, $sails, $log, FilesService) ->

  $sails.on 'message', (message) ->
    $log.debug '$sails.on'
    $log.debug message

  currentPath = FilesService.getCurrentPath()
  $log.debug "/fs/readdir?id="+currentPath;

  $sails.get "/fs/readdir?id="+currentPath
    .success (response) ->
      $log.debug response;
      $scope.files = [];

      angular.forEach response.files, (fileName, index) ->
        $scope.files.push {name: fileName}

    .error (response) ->
      $log.error if response then angular.toJson response.error else "Can't read file dir "+currentPath
