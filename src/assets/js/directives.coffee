exports.file = () ->
  return {
    restrict: "E"
    , scope: {
      file: '='
    }
    , templateUrl: 'directives/file'
    , controller: ($scope, FilesService, $log) ->
      $scope.$watch 'file', (newValue, oldValue) ->
        # $log.debug 'file changed: '+newValue.name+' ('+oldValue.name+')'
        # $log.debug newValue
        # $log.debug oldValue
        if newValue.name != oldValue.name or angular.isUndefined(oldValue.path)
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
        jsonPath = FilesService.getMetaDataJsonPath($scope.file)
        $log.debug "jsonPath: "+jsonPath
        FilesService.getJson jsonPath, (error, result) ->
          if error != null
            $log.warn(error)
            $scope.file.metadata = {}
          else
            $scope.file.metadata = result
          $log.debug $scope.file

      $scope.$watch 'file', (newValue, oldValue) ->
        $log.debug 'file changed: '+newValue.name+' ('+oldValue.name+')'
        # $log.debug newValue
        # $log.debug oldValue
        if newValue.name != oldValue.name or angular.isUndefined(oldValue.metadata)
          setMetadata()

  }

  # gaskocher fur 2 platten
  # rockharz
  # zeld