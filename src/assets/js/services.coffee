exports.TMDBService = ($log, $sails, $rootScope) ->

  _normalize = (video, cb) ->
    angular.forEach video, (value, key) ->
      if key == 'backdrop_path' && value?
        video[key] = $rootScope.tmdb.config.images.base_url + $rootScope.tmdb.config.images.backdrop_sizes[$rootScope.tmdb.config.images.backdrop_sizes.length - 2] + value
      if key == 'poster_path' && value?
        video[key] = $rootScope.tmdb.config.images.base_url + $rootScope.tmdb.config.images.poster_sizes[3] + value
      if key == 'logo_path' && value?
        video[key] = $rootScope.tmdb.config.images.base_url + $rootScope.tmdb.config.images.logo_sizes[$rootScope.tmdb.config.images.logo_sizes.length - 2] + value
      if key == 'profile_path' && value?
        video[key] = $rootScope.tmdb.config.images.base_url + $rootScope.tmdb.config.images.profile_sizes[$rootScope.tmdb.config.images.profile_sizes.length - 2] + value
      if key == 'still_path' && value?
        video[key] = $rootScope.tmdb.config.images.base_url + $rootScope.tmdb.config.images.still_sizes[$rootScope.tmdb.config.images.still_sizes.length - 2] + value
    cb null, video

  normalize = (video, cb) ->
    configuration (error, config) ->
      if error?
        cb error
      else
        _normalize video, cb

  configuration = (cb) ->
    if angular.isUndefined $rootScope.tmdb
      $sails.get "/tmdb/configuration"
        .success (response) ->
          if angular.isDefined response.error
            $log.error response.error
            cb(response)
          else
            $rootScope.tmdb = {
              config: response
            }
            cb(null, $rootScope.tmdb.config) # okay
        .error (response) ->
          $log.error if response then angular.toJson response.error else "Can't get popular tv shows"
          cb(response.error, null)
    else
      cb null, $rootScope.tmdb.config

  miscPopularMovies = (cb) ->
    $sails.get "/tmdb/miscPopularMovies"
      .success (response) ->
        if angular.isDefined response.error
          $log.error response.error
          cb(response)
        else
          cb(null, response) # okay
      .error (response) ->
        $log.error if response then angular.toJson response.error else "Can't get popular movies"
        cb(response.error, null)

  miscPopularTvs = (cb) ->
    $sails.get "/tmdb/miscPopularTvs"
      .success (response) ->
        if angular.isDefined response.error
          $log.error response.error
          cb(response)
        else
          cb(null, response) # okay
      .error (response) ->
        $log.error if response then angular.toJson response.error else "Can't get popular tv shows"
        cb(response.error, null)

  return {
    miscPopularMovies: miscPopularMovies
    miscPopularTvs: miscPopularTvs
    configuration: configuration
    normalize: normalize
  }

exports.TVDBService = ($log, $sails) ->

  getLanguages = (cb) ->
    $sails.get "/tvdb/getLanguages"
      .success (response) ->
        if angular.isDefined response.error
          $log.error response.error
          cb(response)
        else
          cb(null, response) # okay
      .error (response) ->
        $log.error if response then angular.toJson response.error else "Can't get languages"
        cb(response.error, null)

  setLanguage = (lang, cb) ->
    $sails.get "/tvdb/setLanguage?lang="+lang
      .success (response) ->
        if angular.isDefined response.error
          $log.error response.error
          cb(response)
        else
          cb(null, response) # okay
      .error (response) ->
        $log.error if response then angular.toJson response.error else "Can't set languages "+lang
        cb(response.error, null)

  getMirrors = (lang, cb) ->
    $sails.get "/tvdb/getMirrors"
      .success (response) ->
        if angular.isDefined response.error
          $log.error response.error
          cb(response)
        else
          cb(null, response) # okay
      .error (response) ->
        $log.error if response then angular.toJson response.error else "Can't get mirrors"
        cb(response.error, null)

  getServerTime = (lang, cb) ->
    $sails.get "/tvdb/getServerTime"
      .success (response) ->
        if angular.isDefined response.error
          $log.error response.error
          cb(response)
        else
          cb(null, response) # okay
      .error (response) ->
        $log.error if response then angular.toJson response.error else "Can't get server time"
        cb(response.error, null)

  findTvShow = (query, cb) ->
    $sails.get "/tvdb/findTvShow?query="+query
      .success (response) ->
        if angular.isDefined response.error
          $log.error response.error
          cb(response)
        else
          cb(null, response) # okay
      .error (response) ->
        error = if response then angular.toJson response.error else "Can't call findTvShow with query: "+query
        $log.error error
        cb(error, null)

  getInfo = (id, cb) ->
    $sails.get "/tvdb/getInfo?id="+id
      .success (response) ->
        if angular.isDefined response.error
          $log.error response.error
          cb(response)
        else
          cb(null, response) # okay
      .error (response) ->
        error = if response then angular.toJson response.error else "Can't call getInfo with id: "+id
        $log.error error
        cb(error, null)

  getInfoTvShow = (id, cb) ->
    $sails.get "/tvdb/getInfoTvShow?id="+id
      .success (response) ->
        if angular.isDefined response.error
          $log.error response.error
          cb(response)
        else
          cb(null, response) # okay
      .error (response) ->
        error = if response then angular.toJson response.error else "Can't call getInfoTvShow with id: "+id
        $log.error error
        cb(error, null)

  getInfoEpisode = (id, cb) ->
    $sails.get "/tvdb/getInfoEpisode?id="+id
      .success (response) ->
        if angular.isDefined response.error
          $log.error response.error
          cb(response)
        else
          cb(null, response) # okay
      .error (response) ->
        error = if response then angular.toJson response.error else "Can't call getInfoEpisode with id: "+id
        $log.error error
        cb(error, null)

  getUpdates = (period, cb) ->
    $sails.get "/tvdb/getUpdates?period="+period
      .success (response) ->
        if angular.isDefined response.error
          $log.error response.error
          cb(response)
        else
          cb(null, response) # okay
      .error (response) ->
        error = if response then angular.toJson response.error else "Can't call getUpdates with period: "+period
        $log.error error
        cb(error, null)

  return {
    getLanguages: getLanguages
    setLanguage: setLanguage
    getMirrors: getMirrors
    getServerTime: getServerTime
    findTvShow: findTvShow
    getInfo: getInfo
    getInfoTvShow: getInfoTvShow
    getInfoEpisode: getInfoEpisode
    getUpdates: getUpdates
  }

exports.FilesService = ($log, $routeParams, $sails, $http, async, transport) ->

  getCurrentPath = () ->
    return if angular.isDefined($routeParams.path) then $routeParams.path else '/'

  # erzeugt anhand des Dateinamens und des aktuellen Verzeichnisses einen absoluten Pfad zu Datei
  getAbsolutePath = (fileName, dirname) ->
    # path = getCurrentPath()
    if dirname.charAt(dirname.length - 1) != '/' # if last char is '/' 
      dirname += '/';
    path = dirname + fileName
    return path

  getPathQueryString = (path) ->
    return '?path=' + path

  getFile = (path, cb) ->

    url = "/fs/detectFile"+getPathQueryString(path)
    # $log.debug url

    switch transport
      when 'socket'
        $sails.get url
          .success (response) ->
            if angular.isDefined response.error
              cb(response.error)
            else
              $log.debug response;
              cb(null, response)
          .error (response) ->
            $log.error if response then angular.toJson response.error else "Can't detect file: "+path
            cb(response.error, null)
      else # http
        $http {method: 'GET', url: url}
          .success (data, status, headers, config) ->
            if angular.isDefined data.error
              cb(data.error)
            else
              # $log.debug data;
              cb(null, data)
          .error (data, status, headers, config) ->
            error = "Can't detect file: "+path
            cb(error, null)

  isHidden = (file) ->
    return angular.isUndefined(file) or angular.isUndefined(file.name) or file.name.charAt(0) == '.'

  exists = (path, cb) ->
    url = "/fs/exists"+getPathQueryString(path)
    # $log.debug url
    switch transport
      when 'socket'
        $sails.get url
          .success (response) ->
            cb(null, response.exists)
          .error (response) ->
            cb(response, null)
      else
        $http {method: 'GET', url: url}
          .success (data, status, headers, config) ->
            cb(null, data.exists)
          .error (data, status, headers, config) ->
            cb(data, null)

  getFileList = (path, finalCallback) ->
    url = "/fs/readdir?path="+path
    # $log.debug url
    switch transport
      when 'socket'
        $sails.get url
          .success (response) ->
            async.map response.files
            , (fileName, callback) ->
              callback null, {name: fileName}
            , finalCallback
          .error (response) ->
            error = if response and response.error then response.error else "Can't read file dir "+path
            finalCallback error
      else
        $http {method: 'GET', url: url}
          .success (data, status, headers, config) ->
            async.map data.files
            , (fileName, callback) ->
              callback null, {name: fileName}
            , finalCallback
          .error (data, status, headers, config) ->
            error = "Can't read file dir "+path
            finalCallback error

  getJson = (path, cb) ->
    $sails.get "/fs/getJson"+getPathQueryString(path)
      .success (response) ->
        if angular.isDefined response.error
          cb(response.error, {})
        else
          cb(null, response)
      .error (response) ->
        cb(response, {})

  getMetaDataJsonFileName = (fileName) ->
    return "." + fileName + ".json"

  getMetaDataJsonPath = (fileName, dirname) ->
    fileName = getMetaDataJsonFileName fileName
    path = getAbsolutePath fileName, dirname
    return path

  getMetaDataJson = (file, path, cb) ->
    jsonPath = getMetaDataJsonPath file.name, path
    $log.debug "jsonPath: "+jsonPath
    getJson jsonPath, (error, metadata) ->
      if error != null
        return cb(error, {})
      else
        return cb(null, metadata)

  return {
    getCurrentPath: getCurrentPath
    getAbsolutePath: getAbsolutePath
    getPathQueryString: getPathQueryString
    getFile: getFile
    isHidden: isHidden
    exists: exists
    getFileList: getFileList
    getJson: getJson
    getMetaDataJson: getMetaDataJson
  }

exports.OmxPlayerService = ($log, $sails) ->

  start = (path, cb) ->
    $log.debug "/omx/start?id="+path
    $sails.get "/omx/start?id="+path
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  toggle_pause = (cb) ->
    # $log.debug "/omx/toggle_pause
    $sails.get "/omx/toggle_pause"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  play = (cb) ->
    # $log.debug "/omx/start
    $sails.get "/omx/play"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  volume_up = (cb) ->
    # $log.debug "/omx/volume_up
    $sails.get "/omx/volume_up"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  volume_down = (cb) ->
    # $log.debug "/omx/volume_down
    $sails.get "/omx/volume_down"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  quit = (cb) ->
    # $log.debug "/omx/quit
    $sails.get "/omx/quit"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  forward = (cb) ->
    # $log.debug "/omx/forward
    $sails.get "/omx/forward"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  backward = (cb) ->
    # $log.debug "/omx/backward
    $sails.get "/omx/backward"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  next_subtitle = (cb) ->
    # $log.debug "/omx/next_subtitle
    $sails.get "/omx/next_subtitle"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  previous_subtitle = (cb) ->
    # $log.debug "/omx/previous_subtitle
    $sails.get "/omx/previous_subtitle"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  next_chapter = (cb) ->
    # $log.debug "/omx/next_chapter
    $sails.get "/omx/next_chapter"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  previous_chapter = (cb) ->
    # $log.debug "/omx/previous_chapter
    $sails.get "/omx/previous_chapter"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  next_audio = (cb) ->
    # $log.debug "/omx/next_audio
    $sails.get "/omx/next_audio"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  previous_audio = (cb) ->
    # $log.debug "/omx/previous_audio
    $sails.get "/omx/previous_audio"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  increase_speed = (cb) ->
    # $log.debug "/omx/increase_speed
    $sails.get "/omx/increase_speed"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  decrease_speed = (cb) ->
    # $log.debug "/omx/decrease_speed
    $sails.get "/omx/decrease_speed"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  return {
    start: start
    toggle_pause: toggle_pause
    quit: quit
    forward: forward
    backward: backward
    next_subtitle: next_subtitle
    next_audio: next_audio
  }

exports.FfplayPlayerService = ($log, $sails) ->

  start = (path, cb) ->
    $log.debug "/ffplay/start?id="+path
    $sails.get "/ffplay/start?id="+path
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  pause = (cb) ->
    # $log.debug "/ffplay/pause
    $sails.get "/ffplay/pause"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  toggle_pause = (cb) ->
    # $log.debug "/ffplay/pause
    $sails.get "/ffplay/toggle_pause"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  stop = (cb) ->
    # $log.debug "/ffplay/quit
    $sails.get "/ffplay/stop"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  resume = (cb) ->
    # $log.debug "/ffplay/resume
    $sails.get "/ffplay/resume"
      .success (response) ->
        cb(null);
      .error (response) ->
        cb(response);

  return {
    start: start
    pause: pause
    toggle_pause: toggle_pause
    quit: stop
    stop: stop
    resume: resume
  }

exports.PlayerService = ($rootScope, $sails, $http, $log, $interval, transport, OmxPlayerService, FfplayPlayerService) ->

  $rootScope.player = {
    program: null # omxplayer | ffplay
    status: 'stop' # stop | play | pause
    isPlay: false
    isStop: true
    isPause: false
    duration: null
    start: null
  }

  timer = null

  humanizeDuration = (duration) ->
    hours = duration.hours()
    minutes = duration.minutes()
    seconds = duration.seconds()

    if(hours == 0)
      hours = "";
    else
      hours += ":"

    if(minutes <= 9)
      minutes = "0" + minutes
    minutes += ":"

    if(seconds <= 9)
      seconds = "0" + seconds

    timeString = hours + minutes + seconds;

    if(timeString == "0:0")
      timeString = "";

    return timeString

  durationIsValid = (duration) ->
    if angular.isDefined(duration) and duration != null and angular.isDefined(duration._milliseconds) 
      return true

  durationChanged = (d1, d2) ->
    if not durationIsValid(d1)
      return false
    if durationIsValid(d1) and not durationIsValid(d2)
      return true
    if durationIsValid(d1) and durationIsValid(d2)
      if d1._milliseconds != d2._milliseconds
        return true
      else
        return false
    else
      return false

  startTimer = () ->
    timer = $interval () =>
      $rootScope.player.duration = moment.duration($rootScope.player.duration._milliseconds)
      second = moment.duration(1, 's')
      $rootScope.player.duration.add(second)
    , 1000

  stopTimer = () ->
    if(timer != null)
      $interval.cancel(timer);

  updatePlayer = (newValue) ->
    angular.extend $rootScope.player, newValue
    switch newValue.status
      when 'stop'
        $rootScope.player.isStop = true
        $rootScope.player.isPause = false
        $rootScope.player.isPlay = false
      when 'play'
        $rootScope.player.isStop = false
        $rootScope.player.isPause = false
        $rootScope.player.isPlay = true
      when 'pause'
        $rootScope.player.isStop = false
        $rootScope.player.isPause = true
        $rootScope.player.isPlay = false
    

  $rootScope.$watch 'player.file.metadata.format.duration', (newValue, oldValue) ->
    $log.debug 'change player.file.metadata.format.duration' 
    $log.debug newValue
    if angular.isDefined newValue
      if not angular.equals newValue, oldValue
        if angular.isDefined newValue._milliseconds
          newValue = moment.duration(newValue._milliseconds)
        else
          newValue = moment.duration(parseInt(newValue), 'seconds')
        $rootScope.length = humanizeDuration(newValue)
        $rootScope.player.file.metadata.format.duration = newValue

  $rootScope.$watch 'player.file', (newValue, oldValue) ->
    $log.debug 'change player.file'
    $log.debug newValue

  $rootScope.$watchCollection 'player.duration', (newValue, oldValue) ->
    # $log.debug 'change player.duration'
    # $log.debug newValue
    if durationChanged(newValue, oldValue)
      $rootScope.player.duration = moment.duration(newValue._milliseconds)
      $rootScope.duration = humanizeDuration($rootScope.player.duration)

  $rootScope.$watch 'player.status', (newValue, oldValue) ->
    $log.debug 'change player.status'
    $log.debug newValue
    if angular.isDefined newValue
      switch newValue
        when 'play' then startTimer()
        when 'pause' then stopTimer()
        when 'stop' then stopTimer()
      
  switch transport
    when 'socket'
      $sails.get "/ffplay/info"
        .success (response) ->
          # $log.debug response
          updatePlayer (response.player)
        .error (response) ->
          $log.error response
    else
      $http {method: 'GET', url: "/ffplay/info"}
        .success (data, status, headers, config) ->
          # $log.debug data
          updatePlayer (data.player)
        .error (data, status, headers, config) ->
          $log.error data

  $sails.on 'start', (message) ->
    $log.debug '$sails.on start in PlayerService'
    updatePlayer (message.player)
    $rootScope.$apply()

  $sails.on 'pause', (message) ->
    $log.debug '$sails.on pause in PlayerService'
    updatePlayer (message.player)
    $rootScope.$apply()

  $sails.on 'resume', (message) ->
    $log.debug '$sails.on resume in PlayerService'
    updatePlayer (message.player)
    $rootScope.$apply()

  $sails.on 'stop', (message) ->
    $log.debug '$sails.on stop in PlayerService'
    updatePlayer (message.player)
    $rootScope.$apply()

  setAvailablePlayer = () ->
    urlOmx = "/os/program_exists?name=omxplayer";
    urlFfplay = "/os/program_exists?name=ffplay";
    switch transport
      when 'socket'
        $sails.get urlOmx
          .success (response) ->
            if angular.isDefined(response) and angular.isDefined(response.exists) and response.exists == true
              $rootScope.player.program = "omxplayer";
              $log.debug "omxplayer is used"
            else
              # $log.debug "omxplayer is not installed"
              $sails.get urlFfplay
                .success (response) ->
                  if angular.isDefined(response) and angular.isDefined(response.exists) and response.exists == true
                    $rootScope.player.program = "ffplay";
                    $log.debug "ffplay is used"
                  else
                    $log.error "ffplay is not installed"
      else
        $http {method: 'GET', url: urlOmx}
          .success (response, status, headers, config) ->
            if angular.isDefined(response) and angular.isDefined(response.exists) and response.exists == true
              $rootScope.player.program = "omxplayer";
              $log.debug "omxplayer is used"
            else
              # $log.debug "omxplayer is not installed"
              $http {method: 'GET', url: urlFfplay}
                .success (response, status, headers, config) ->
                  if angular.isDefined(response) and angular.isDefined(response.exists) and response.exists == true
                    $rootScope.player.program = "ffplay";
                    $log.debug "ffplay is used"
                  else
                    $log.error "ffplay is not installed"

  _start = (path, cb) ->
    if $rootScope.player.program == "omxplayer"
      OmxPlayerService.start(path, cb)
      $rootScope.player.status = 'play'
    else if $rootScope.player.program == "ffplay"
      FfplayPlayerService.start(path, cb)
      $rootScope.player.status = 'play'
    else
      $log.error "no media player installed, please install omxplayer or ffplay"               

  start = (path, cb) ->
    if $rootScope.player.status != 'stop'
      quit (error) ->
        if error
          cb
        else
          _start path, cb
    else
      _start path, cb

  toggle_pause = () ->
    if $rootScope.player.status != 'stop'
      # $log.debug "/ffplay/pause
      if $rootScope.player.program == "omxplayer"
        OmxPlayerService.toggle_pause (error) ->
      else if $rootScope.player.program == "ffplay"
        FfplayPlayerService.toggle_pause (error) ->
      else
        $log.error "no media player installed, please install omxplayer or ffplay"
    else
     $log.error "no video to play"

  quit = (cb) ->
    # $log.debug "/ffplay/quit
    if $rootScope.player.program == "omxplayer"
      OmxPlayerService.quit cb
    else if $rootScope.player.program == "ffplay"
      FfplayPlayerService.quit cb
    else
      $log.error "no media player installed, please install omxplayer or ffplay"
     
  forward = () ->
    # $log.debug "/ffplay/forward
    if $rootScope.player.program == "omxplayer"
      OmxPlayerService.forward (error) ->
    else if $rootScope.player.program == "ffplay"
      $log.error "command not available for ffplay";
    else
      $log.error "no media player installed, please install omxplayer or ffplay"
     
  backward = () ->
    # $log.debug "/ffplay/backward
    if $rootScope.player.program == "omxplayer"
      OmxPlayerService.backward (error) ->
    else if $rootScope.player.program == "ffplay"
      $log.error "command not available for ffplay";
    else
      $log.error "no media player installed, please install omxplayer or ffplay"
     
  next_subtitle = () ->
    # $log.debug "/ffplay/next_subtitle
    if $rootScope.player.program == "omxplayer"
      OmxPlayerService.next_subtitle (error) ->
    else if $rootScope.player.program == "ffplay"
      $log.error "command not available for ffplay";
    else
      $log.error "no media player installed, please install omxplayer or ffplay"
     
  next_audio = () ->
    # $log.debug "/ffplay/next_audio
    if $rootScope.player.program == "omxplayer"
      OmxPlayerService.next_audio (error) ->
    else if $rootScope.player.program == "ffplay"
      $log.error "command not available for ffplay";
    else
      $log.error "no media player installed, please install omxplayer or ffplay"

  setAvailablePlayer();

  return {
    start: start
    toggle_pause: toggle_pause
    quit: quit
    forward: forward
    backward: backward
    next_subtitle: next_subtitle
    next_audio: next_audio
  }