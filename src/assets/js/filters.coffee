# from https://gist.github.com/thomseddon/3511330
exports.bytes = ->
  (bytes, precision) ->
    return "-"  if isNaN(parseFloat(bytes)) or not isFinite(bytes)
    precision = 1  if typeof precision is "undefined"
    units = [
      "bytes"
      "kB"
      "MB"
      "GB"
      "TB"
      "PB"
    ]
    number = Math.floor(Math.log(bytes) / Math.log(1024))
    (bytes / Math.pow(1024, Math.floor(number))).toFixed(precision) + " " + units[number]