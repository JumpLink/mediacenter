exports.FilesService = ($log, $routeParams, $sails) ->

  getAbsolutePath = (file) ->
    path = if angular.isDefined($routeParams.path) then $routeParams.path else '/'
    if path.charAt(path.length - 1) != '/' # if last char is '/' 
      path += '/';
    path += file.name
    return path

  getINodeLink = (file) ->
    link = if file.path then file.path else getAbsolutePath(file)
    return '?path=' + link


  extendFile = (fileName, cb) ->
    file = {name: fileName}
    file.path = getAbsolutePath(file);
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

  isHidden = (file)->
    return file.name.charAt(0) == '.'

  return {
    getAbsolutePath: getAbsolutePath
    getINodeLink: getINodeLink
    extendFile: extendFile
    isHidden: isHidden
  }