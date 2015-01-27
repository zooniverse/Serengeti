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
  dataString = JSON.stringify(eventData)
  headers =
    "Content-Type": "application/json; charset=utf-8"
    "Content-Length": dataString.length + "{\"events\":[".length + "]}".length

  options =
    host: "analytics.zooniverse.org"
    port: 80
    path: "/events/"
    method: "POST"
    headers: headers

  req = http.request(options, (res) ->
    res.setEncoding "utf-8"
    responseString = ""
    res.on "data", (data) ->
      responseString += data
      return

    res.on "end", ->
      resultObject = JSON.parse(responseString)
      true

    return
  )
  req.on "error", (e) ->
    console.log e
    false

  req.write "{\"events\":[" + dataString + "]}"
  req.end()
  return

querystring = require("querystring")
http = require("http")
exports.logEvent = logEvent
