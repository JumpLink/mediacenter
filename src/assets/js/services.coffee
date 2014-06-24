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

exports.FilesService = ($log, $routeParams, $sails, async) ->

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
    $sails.get "/fs/detectFile"+getPathQueryString(path)
      .success (response) ->
        if angular.isDefined response.error
          cb(response.error)
        else
          $log.debug response;
          cb(null, response)
      .error (response) ->
        $log.error if response then angular.toJson response.error else "Can't detect file: "+path
        cb(response.error, null)

  isHidden = (file) ->
    return angular.isUndefined(file) or angular.isUndefined(file.name) or file.name.charAt(0) == '.'

  exists = (path, cb) ->
    $sails.get "/fs/exists"+getPathQueryString(path)
      .success (response) ->
        cb(null, response.exists)
      .error (response) ->
        cb(response, null)

  getFileList = (path, finalCallback) ->
    # $log.debug "/fs/readdir?id="+path
    $sails.get "/fs/readdir?id="+path
      .success (response) ->
        async.map response.files
        , (fileName, callback) ->
          callback null, {name: fileName}
        , finalCallback
      .error (response) ->
        error = if response and response.error then response.error else "Can't read file dir "+path
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

  toogle_pause = (cb) ->
    # $log.debug "/omx/pause
    $sails.get "/omx/pause"
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
    toogle_pause: toogle_pause
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

  quit = (cb) ->
    # $log.debug "/ffplay/quit
    $sails.get "/ffplay/quit"
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
    quit: quit
    resume: resume
  }

exports.PlayerService = ($rootScope, $sails, $log, $interval, OmxPlayerService, FfplayPlayerService) ->

  $rootScope.player = {
    program: null # omxplayer | ffplay
    status: 'stop' # stop | play | pause
    duration: null
    start: null
  }

  timer = null

  humanizeDuration = (duration) ->
    return duration.hours() + ":" + duration.minutes() + ":" + duration.seconds()

  updateTimer = () ->
    $rootScope.duration = humanizeDuration($rootScope.player.duration)

  startTimer = () ->
    timer = $interval ()->
      second = moment.duration(1, 's')
      $rootScope.player.duration.add(second)
      updateTimer()
    , 1000

  stopTimer = () ->
    if(timer != null)
      $interval.cancel(timer);

  updatePlayer = (newValue) ->
    $log.debug "updatePlayer: "
    $log.debug newValue.duration
    
    newValue.duration = moment.duration(newValue.duration._milliseconds);
    $log.debug newValue.duration

    angular.extend $rootScope.player, newValue
    $log.debug $rootScope.player

    updateTimer()

  $rootScope.$watch 'player.status', (newValue, oldValue) ->
    $log.debug "player.status update: "+newValue
    switch newValue
      when 'play' then startTimer()
      when 'pause' then stopTimer()
      when 'stop' then stopTimer()
      
  $sails.get "/ffplay/info"
    .success (response) ->
      $log.debug response
      updatePlayer (response.player)
    .error (response) -> # FIXME
      updatePlayer (response.player)

  $sails.on 'start', (message) ->
    $log.debug '$sails.on start in PlayerService'
    updatePlayer (message.player)

  $sails.on 'pause', (message) ->
    $log.debug '$sails.on pause in PlayerService'
    updatePlayer (message.player)

  $sails.on 'resume', (message) ->
    $log.debug '$sails.on resume in PlayerService'
    updatePlayer (message.player)

  $sails.on 'stop', (message) ->
    $log.debug '$sails.on stop in PlayerService'
    updatePlayer (message.player)

  setAvailablePlayer = () ->
    $sails.get "/os/program_exists?name=omxplayer"
      .success (response) ->
        if angular.isDefined(response) and angular.isDefined(response.exists) and response.exists == true
          $rootScope.player.program = "omxplayer";
          $log.debug "omxplayer is used"
        else
          $log.debug "omxplayer is not installed"
          $sails.get "/os/program_exists?name=ffplay"
            .success (response) ->
              if angular.isDefined(response) and angular.isDefined(response.exists) and response.exists == true
                $rootScope.player.program = "ffplay";
                $log.debug "ffplay is used"
              else
                $log.debug "ffplay is not installed"

  start = (path, cb) ->
    # $log.debug "/ffplay/start?id="+path
    if $rootScope.player.program == "omxplayer"
      OmxPlayerService.start(path, cb)
      $rootScope.player.status = 'play'
    else if $rootScope.player.program == "ffplay"
      FfplayPlayerService.start(path, cb)
      $rootScope.player.status = 'play'
    else
      $log.error "no media player installed, please install omxplayer or ffplay"

  toogle_pause = () ->
    # $log.debug "/ffplay/pause
    if $rootScope.player.program == "omxplayer"
      OmxPlayerService.toogle_pause (error) ->
    else if $rootScope.player.program == "ffplay"
      FfplayPlayerService.toggle_pause (error) ->
    else
      $log.error "no media player installed, please install omxplayer or ffplay"
     
  quit = () ->
    # $log.debug "/ffplay/quit
    if $rootScope.player.program == "omxplayer"
      OmxPlayerService.quit (error) ->
    else if $rootScope.player.program == "ffplay"
      $log.error "command not available for ffplay";
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
    toogle_pause: toogle_pause
    quit: quit
    forward: forward
    backward: backward
    next_subtitle: next_subtitle
    next_audio: next_audio
  }