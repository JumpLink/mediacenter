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
