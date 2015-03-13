$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
Subject = require 'models/subject'
Experiments = require 'lib/experiments'
getIP = require 'lib/getip'
currentUserID = null

iteration = 0

buildEventData = (type, related_id = null, subject_id = Subject.current?.zooniverseId) ->
  eventData = {}
  eventData['time'] = Date.now()
  eventData['projectToken'] = 'serengeti'
  eventData['subjectID'] = subject_id
  eventData['type'] = type
  eventData['relatedID'] = related_id
  eventData['experiment'] = Experiments.ACTIVE_EXPERIMENT
  eventData['errorCode'] = ""
  eventData['errorDescription'] = ""
  eventData['cohort'] = Experiments.currentCohort
  eventData['userID'] = "(anonymous)"
  eventData

addUserDetailsToEventData = (eventData, user_id = User.current?.zooniverse_id) ->
  eventualEventData = new $.Deferred
  eventData['userID'] = if user_id? then user_id else if currentUserID? then currentUserID else null
  if eventData['userID']?
    eventualEventData.resolve eventData
  else
    getIP.getClientOrigin()
    .then (data) =>
      if data?
        currentUserID = getIP.getNiceOriginString data
        eventData['userID'] = currentUserID
    .always =>
      eventualEventData.resolve eventData
  eventualEventData.promise()

addCohortToEventData = (eventData) ->
  eventualEventData = new $.Deferred
  Experiments.getCohort()
  .then (cohort) =>
    if cohort?
      eventData['cohort'] = cohort
  .always =>
    eventualEventData.resolve eventData
  eventualEventData.promise()

###
log event with Geordi v2
###
logToGeordi = (eventData) =>
  $.ajax {
    url: 'http://geordi.zooniverse.org/api/events/',
    type: 'POST',
    contentType: 'application/json; charset=utf-8',
    data: JSON.stringify(eventData),
    dataType: 'json'
  }

###
log event with Google Analytics
###
logToGoogle = (eventData) =>
  dataLayer.push {
    event: "gaTriggerEvent"
    project_token: eventData['projectToken']
    user_id: eventData['userID']
    subject_id: eventData['subjectID']
    geordi_event_type: eventData['type']
    classification_id: eventData['relatedID']
  }

###
This will log a user interaction both in the Geordi analytics API and in Google Analytics.
###
logEvent = (type, related_id = '', user_id = User.current?.zooniverse_id, subject_id = Subject.current?.zooniverseId) =>
  eventData = buildEventData(type, related_id, subject_id)
  addUserDetailsToEventData(eventData, user_id)
  .always (eventData) =>
    if Experiments.currentCohort?
      logToGeordi eventData
      logToGoogle eventData
    else
      addCohortToEventData(eventData)
      .always (eventData) =>
        logToGeordi eventData
        logToGoogle eventData

###
This will log an error in Geordi only. In order to guarantee that this works, no new AJAX calls for cohort or user IP are initiated
###
logError = (error_code, error_description, type, related_id = '', user_id = User.current?.zooniverse_id, subject_id = Subject.current?.zooniverseId) ->
  eventData = buildEventData(type, related_id, subject_id)
  eventData['errorCode'] = error_code
  eventData['errorDescription'] = error_description
  eventData['userID'] = if currentUserID? then currentUserID else if user_id? then user_id else "(anonymous)"
  logToGeordi eventData

exports.logEvent = logEvent
exports.logError = logError

