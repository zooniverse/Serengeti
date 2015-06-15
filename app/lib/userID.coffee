User = require 'zooniverse/lib/models/user'
currentUserID = null

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

getUserIDorIPAddress = =>
  eventualUserID = new $.Deferred
  if currentUserID?
    eventualUserID.resolve user_id
  else if User.current?.zooniverse_id
    eventualUserID.resolve User.current?.zooniverse_id
  else
    getClientOrigin()
    .then (data) =>
      if data?
        currentUserID = getNiceOriginString data
    .always =>
      eventualUserID.resolve currentUserID
  eventualUserID.promise()

exports.getClientOrigin = getClientOrigin
exports.getNiceOriginString = getNiceOriginString
exports.getUserIDorIPAddress = getUserIDorIPAddress
exports.currentUserID = currentUserID