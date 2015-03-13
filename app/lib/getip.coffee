getClientOrigin = ->
  eventualIP = new $.Deferred
  $.get('http://jsonip.appspot.com/')
  .then (data) =>
    eventualIP.resolve data
  .fail =>
    eventualIP.resolve {ip: '?.?.?.?', address: '(anonymous)'}
  eventualIP.promise()

getNiceOriginString = (data) ->
  if data.ip? && data.address?
    if data.ip == '?.?.?.?'
      "(anonymous)"
    else if data.ip == data.address
      "(#{ data.ip })"
    else
      "(#{ data.address } [#{ data.ip }])"
  else
    "(anonymous)"

exports.getClientOrigin = getClientOrigin
exports.getNiceOriginString = getNiceOriginString
