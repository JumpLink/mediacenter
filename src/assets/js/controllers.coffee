exports.IndexController = ($scope) ->
  $scope.test = 'test';

exports.SailsController = ($scope) ->
  $scope.test = 'test';

exports.FilesController = ($scope, $sails, $log, $routeParams, FilesService) ->

  $sails.on 'message', (message) ->
    $log.debug '$sails.on'
    $log.debug message

  currentPath = if angular.isDefined($routeParams.path) then $routeParams.path else '/'
  $log.debug "/fs/readdir?id="+currentPath;

  $sails.get "/fs/readdir?id="+currentPath
    .success (response) ->
      $log.debug response;
      $scope.files = [];

      angular.forEach response.files, (fileName, index) ->
        $scope.files.push {name: fileName}

    .error (response) ->
      $log.error if response then angular.toJson response.error else "Can't read file dir "+currentPath
