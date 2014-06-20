exports.file = () ->
  return {
    restrict: "E"
    , scope: {
      file: '='
    }
    , templateUrl: 'directives/file'
    , controller: ($scope, FilesService, $log) ->
      $scope.$watch 'file', (newValue, oldValue) ->
        $log.debug 'file changed: '+newValue.name+' ('+oldValue.name+')'
        if newValue.name != oldValue.name or angular.isUndefined(newValue.path)
          FilesService.extendFile newValue.name, (error, file) ->
            if error != null
              $log.error error
            else
              $scope.file = file
            
      $scope.getINodeLink = () ->
        return FilesService.getINodeLink($scope.file)

      $scope.isHidden = () ->
        return FilesService.isHidden($scope.file)
  }

exports.videofile = () ->
  return {
    restrict: "E"
    , scope: {
      file: '='
    }
    , templateUrl: 'directives/video-file'
    , controller: ($scope, FilesService, $log) ->

      setMetadata = () ->
        FilesService.getMetaDataJson $scope.file, (error, metadata) ->
          if(error == null || angular.isUndefined error )
            $scope.file.metadata = metadata;
            $log.debug $scope.file
          else
            $log.error error


      $scope.$watch 'file', (newValue, oldValue) ->
        $log.debug 'video file changed: '+newValue.name+' ('+oldValue.name+')'
        if newValue.name != oldValue.name or angular.isUndefined(newValue.metadata)
          setMetadata()

      $scope.$watch 'file.metadata', (newValue, oldValue) ->
        $log.debug 'video metadata changed'

  }

  # gaskocher fur 2 platten
  # rockharz
  # zeld