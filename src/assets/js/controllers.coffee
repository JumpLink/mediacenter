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

exports.ServerController = ($scope, $rootScope, $sails, $http, $location, $log, $interval, TMDBService, PlayerService) ->

  timer = null
  popularTimer = null

  getIPs = () ->
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


  $scope.openWiFiConfig = () ->
    $sails.get "/os/exec?name=/usr/sbin/wpa_gui"
      .success (response) ->
        $log.info "openen WiFi Config"

  getQuoteOfTheDay = () ->
    url = "http://www.iheartquotes.com/api/v1/random?format=json";
    $http {method: 'GET', url: url}
    .success (data) ->
      $scope.quote = data
      $log.debug data

  getPopularMovie = () ->
    TMDBService.miscPopularMovies (error, data) ->
      if error != null
        $log.error error
      else if angular.isDefined data.results
        randomIndex = Math.floor((Math.random() * data.results.length))
        TMDBService.normalize data.results[randomIndex], (error, movie) ->
          $scope.movie = movie
          $log.debug $scope.movie

  miscPopularTvs = () ->
    TMDBService.miscPopularTvs (error, data) ->
      if error != null
        $log.error error
      else if angular.isDefined data.results
        randomIndex = Math.floor((Math.random() * data.results.length))
        TMDBService.normalize data.results[randomIndex], (error, tv) ->
          $scope.tv = tv
          $log.debug $scope.tv

  play = () ->
    $rootScope.bodylayout = "server play";

    if(timer != null)
      $interval.cancel(timer);

    if(popularTimer != null)
      $interval.cancel(popularTimer);

  stop = () ->
    $rootScope.bodylayout = "server stop";

    timer = $interval () ->
      $scope.moment = moment()
    , 1000

    popularTimer = $interval () ->
      getPopularMovie()
      miscPopularTvs()
    , 60000

  pause = () ->
    $rootScope.bodylayout = "server pause";

  resume = () ->
    $rootScope.bodylayout = "server play";

  stop()
  getPopularMovie()
  miscPopularTvs()
  getIPs()

  # getQuoteOfTheDay()

  $scope.port = $location.port()


  ### IMPORTANT NOTE you need to have PlayerService injected to watch this scope ###
  $rootScope.$watch 'player.status', (newValue, oldValue) ->
    $log.debug newValue
    switch newValue
      when 'play'
        play()
      when 'pause'
        pause()
      when 'stop'
        stop()
    
  # $sails.on 'start', (message) ->
  #   $log.debug '$sails.on start in ServerController'
  #   play()
  #   $rootScope.$apply()

  # $sails.on 'pause', (message) ->
  #   $log.debug '$sails.on pause in ServerController'
  #   pause()
  #   $rootScope.$apply()

  # $sails.on 'resume', (message) ->
  #   $log.debug '$sails.on resume in ServerController'
  #   resume()
  #   $rootScope.$apply()

  # $sails.on 'stop', (message) ->
  #   $log.debug '$sails.on stop in ServerController'
  #   stop()
  #   $rootScope.$apply()

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