$ = require('jqueryify')
###
This will log a user interaction using the analytics.zooniverse.org API.
eventData should be of the format:
  { time: 1422379082808,  (JSON timestamp)
  user_id: '1234',
  subject_id: '5678',
  type: 'logout',
  related_id: '8901' }
###
logEvent = (user_id,subject_id,type,related_id) ->
  eventData = {}
  eventData['time'] = Date.now()
  eventData['user_id'] = user_id
  eventData['subject_id'] = subject_id
  eventData['type'] = type
  eventData['related_id'] = related_id
  $.ajax {
        url: 'http://localhost:8090/events/',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        contentLength: length,
        data: "{\"events\":[" + JSON.stringify(eventData) + "]}",
        dataType: 'json',
        complete: ->
          #console.log 'finished ajax req'
        beforeSend: ->
          #console.log 'starting ajax req'
        success: ->
          #console.log 'ajax req succeeded'
        error: (xhr, status, error) ->
            #console.log 'finished ajax req with error ' + status + ': ' + error
        }
  true

exports.logEvent = logEvent
