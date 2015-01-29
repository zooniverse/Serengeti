$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
Subject = require 'models/subject'
###
This will log a user interaction using the analytics.zooniverse.org API.
###
logEvent = (type, related_id = '', user_id = User.current?.zooniverse_id, subject_id = Subject.current?.zooniverseId) ->
  eventData = {}
  eventData['time'] = Date.now()
  eventData['user_id'] = user_id
  eventData['subject_id'] = subject_id
  eventData['type'] = type
  eventData['related_id'] = related_id
  $.ajax {
    url: 'http://analytics.zooniverse.org/events/',
    type: 'POST',
    contentType: 'application/json; charset=utf-8',
    contentLength: length,
    data: "{\"events\":[" + JSON.stringify(eventData) + "]}",
    dataType: 'json'
  }

exports.logEvent = logEvent
