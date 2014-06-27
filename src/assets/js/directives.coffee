exports.file = () ->
  return {
    restrict: "E"
    , scope: {
      file: '='
    }
    , templateUrl: 'directives/file'
    , controller: ($scope, FilesService, $log) ->
      currentPath = FilesService.getCurrentPath();
      $scope.$watch 'file', (newValue, oldValue) ->
        if angular.isDefined(newValue) and angular.isDefined(newValue.name)
          $log.debug 'file changed: '+newValue.name+' ('+oldValue.name+')'
          if newValue.name != oldValue.name or angular.isUndefined(newValue.path)
            path = FilesService.getAbsolutePath(newValue.name, currentPath);
            FilesService.getFile path, {ffprobe: false}, (error, file) ->
              if error != null
                $log.warn error
              else
                $scope.file = file
        else
          $log.error 'invalid file: '
          $log.error newValue
            
      $scope.getPathQueryString = () ->
        return FilesService.getPathQueryString($scope.file.path)

      $scope.isHidden = () ->
        return FilesService.isHidden($scope.file)

      $scope.show = () ->
        return !$scope.isHidden() && $scope.file.mediatype

      $scope.start = () ->
        PlayerService.start($scope.file.path);
  }

exports.videofile = () ->
  return {
    restrict: "E"
    , scope: {
      file: '='
    }
    , templateUrl: 'directives/video-file'
    , controller: ($scope, FilesService, $log) ->

      $scope.getPathQueryString = () ->
        return FilesService.getPathQueryString($scope.file.path)

      # setMetadata = () ->
      #   currentPath = FilesService.getCurrentPath();
      #   FilesService.getMetaDataJson $scope.file, currentPath, (error, metadata) ->
      #     if(error == null || angular.isUndefined error )
      #       angular.extend($scope.file.metadata, metadata);
      #       $log.debug $scope.file
      #     else
      #       $scope.file.metadata.type = "unknown"
      #       $log.warn error


      $scope.$watch 'file', (newValue, oldValue) ->
        if angular.isDefined(newValue) and angular.isDefined(newValue.name)
          $log.debug 'video file changed: '+newValue.name+' ('+oldValue.name+')'
          # if newValue.name != oldValue.name or angular.isUndefined(newValue.metadata.type)
          #   setMetadata()

      $scope.$watch 'file.metadata', (newValue, oldValue) ->
        $log.debug 'video metadata changed'

  }

exports.playcontrol = () ->
  return {
    restrict: "E"
    , templateUrl: 'directives/playcontrol'
    , controller: ($scope, $sails, $rootScope, $log, $interval, PlayerService) ->

      # $sails.on 'start', (message) ->
      #   $log.debug '$sails.on start in playcontrol directive'

      # $sails.on 'pause', (message) ->
      #   $log.debug '$sails.on pause in playcontrol directive'

      # $sails.on 'resume', (message) ->
      #   $log.debug '$sails.on resume in playcontrol directive'

      # $sails.on 'stop', (message) ->
      #   $log.debug '$sails.on stop in playcontrol directive'

      $scope.toggle_pause = () ->
        PlayerService.toggle_pause();

      $scope.stop = () ->
        PlayerService.quit();

  }