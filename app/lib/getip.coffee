User = require 'zooniverse/lib/models/user'

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

getUserIDorIPAddress = (user_id = User.current?.zooniverse_id) ->
  eventualUserID = new $.Deferred
  if user_id?
    eventualUserID.resolve user_id
  else
    getIP.getClientOrigin()
    .then (data) =>
      if data?
        user_id = getNiceOriginString data
    .always =>
      eventualUserID.resolve user_id
  eventualUserID.promise()

exports.getClientOrigin = getClientOrigin
exports.getNiceOriginString = getNiceOriginString
exports.getUserIDorIPAddress = getUserIDorIPAddress