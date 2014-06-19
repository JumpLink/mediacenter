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

  getMetaDataJsonPath = (file) ->
    fileName = "." + file.name + ".json";
    path = getAbsolutePath fileName
    return path

  return {
    getCurrentPath: getCurrentPath
    getAbsolutePath: getAbsolutePath
    getINodeLink: getINodeLink
    getPathUrl: getPathUrl
    extendFile: extendFile
    isHidden: isHidden
    exists: exists
    getJson: getJson
    getMetaDataJsonPath: getMetaDataJsonPath
  }