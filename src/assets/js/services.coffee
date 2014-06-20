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
    return file.name.charAt(0) == '.'

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

  getMetaDataJsonPath = (fileName, path) ->
    fileName = getMetaDataJsonFileName fileName
    path = getAbsolutePath fileName, path
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