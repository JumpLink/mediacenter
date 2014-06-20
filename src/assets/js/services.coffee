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

exports.FilesService = ($log, $routeParams, $sails) ->

  getCurrentPath = () ->
    return if angular.isDefined($routeParams.path) then $routeParams.path else '/'

  # erzeugt anhand des Dateinamens und des aktuellen Verzeichnisses einen absoluten Pfad zu Datei
  getAbsolutePath = (fileName) ->
    path = getCurrentPath()
    if path.charAt(path.length - 1) != '/' # if last char is '/' 
      path += '/';
    path += fileName
    return path

  getPathUrl = (path) ->
    return '?path=' + path

  getINodeLink = (file) ->
    link = if file.path then file.path else getAbsolutePath(file.name)
    return getPathUrl(link)

  extendFile = (fileName, cb) ->
    file = {name: fileName}
    file.path = getAbsolutePath(file.name);
    $sails.get "/fs/detectFile"+getINodeLink(file)
      .success (response) ->
        if angular.isDefined response.error
          cb(response.error, file)
        else
          angular.extend(file, response);
          $log.debug file;
          cb(null, file)
      .error (response) ->
        $log.error if response then angular.toJson response.error else "Can't detect file "+path+file
        cb(response.error, null)

  isHidden = (file) ->
    return file.name.charAt(0) == '.'

  exists = (path, cb) ->
    $sails.get "/fs/exists"+getPathUrl(path)
      .success (response) ->
        cb(null, response.exists)
      .error (response) ->
        cb(response, null)

  getJson = (path, cb) ->
    $sails.get "/fs/getJson"+getPathUrl(path)
      .success (response) ->
        if angular.isDefined response.error
          cb(response.error, {})
        else
          cb(null, response)
      .error (response) ->
        cb(response, {})

  getMetaDataJsonFileName = (file) ->
    return "." + file.name + ".json"

  getMetaDataJsonPath = (file) ->
    fileName = getMetaDataJsonFileName file
    path = getAbsolutePath fileName
    return path

  getMetaDataJson = (file, cb) ->
    jsonPath = getMetaDataJsonPath file
    $log.debug "jsonPath: "+jsonPath
    getJson jsonPath, (error, metadata) ->
      if error != null
        $log.warn(error)
        return cb(error, {})
      else
        return cb(null, metadata)

  return {
    getCurrentPath: getCurrentPath
    getAbsolutePath: getAbsolutePath
    getINodeLink: getINodeLink
    getPathUrl: getPathUrl
    extendFile: extendFile
    isHidden: isHidden
    exists: exists
    getJson: getJson
    getMetaDataJson: getMetaDataJson
  }