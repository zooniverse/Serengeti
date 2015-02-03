$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
Subject = require 'models/subject'
###
This will log a user interaction both in the Geordi analytics API and in Google Analytics.
###
logEvent = (type, related_id = '', user_id = User.current?.zooniverse_id, subject_id = Subject.current?.zooniverseId) ->
  eventData = {}
  eventData['time'] = Date.now()
  eventData['user_id'] = user_id
  eventData['subject_id'] = subject_id
  eventData['type'] = type
  eventData['related_id'] = related_id

  # log event in Google
  dataLayer.push {
      event: "gaTriggerEvent"
      project_token: "serengeti"
      user_id: user_id
      subject_id: subject_id
      geordi_event_type: type
      classification_id: related_id
    }

  # log event with Geordi
  $.ajax {
    url: 'http://analytics.zooniverse.org/events/',
    type: 'POST',
    contentType: 'application/json; charset=utf-8',
    contentLength: length,
    data: "{\"events\":[" + JSON.stringify(eventData) + "]}",
    dataType: 'json'
  }

exports.logEvent = logEvent
