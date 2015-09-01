$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
ExperimentalSubject = require 'models/experimental_subject'
Experiments = require 'lib/experiments'
Geordi = require 'lib/geordi'

iteration = 0

buildEventData = (type, related_id = null, subject_id = ExperimentalSubject.current?.zooniverseId) ->
  eventData = {}
  eventData['time'] = Date.now()
  eventData['projectToken'] = 'serengeti'
  eventData['subjectID'] = subject_id
  eventData['type'] = type
  eventData['relatedID'] = related_id
  eventData['experiment'] = Experiments.ACTIVE_EXPERIMENT
  eventData['errorCode'] = ""
  eventData['errorDescription'] = ""
  if Experiments.currentCohort?
    eventData['cohort'] = Experiments.currentCohort
  eventData['userID'] = "(anonymous)"
  eventData

addUserDetailsToEventData = (eventData) ->
  eventualUserIdentifier = new $.Deferred
  Geordi.UserGetter.getUserIDorIPAddress()
  .then (data) =>
    if data?
      Geordi.UserGetter.currentUserID = data
  .fail =>
    Geordi.UserGetter.currentUserID = "(anonymous)"
  .always =>
    eventData['userID'] = Geordi.UserGetter.currentUserID
    eventualUserIdentifier.resolve eventData
  eventualUserIdentifier.promise()


addCohortToEventData = (eventData) ->
  eventualEventData = new $.Deferred
  Experiments.getCohort()
  .then (cohort) =>
    if cohort?
      eventData['cohort'] = cohort
      Experiments.currentCohort = cohort
  .always =>
    eventualEventData.resolve eventData
  eventualEventData.promise()

###
log event with Geordi v2
###
logToGeordi = (eventData) =>
  $.ajax {
    url: 'http://geordi.staging.zooniverse.org/api/events/',
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
logEvent = (type, related_id = '', subject_id = ExperimentalSubject.current?.zooniverseId) =>
  eventData = buildEventData(type, related_id, subject_id)
  addUserDetailsToEventData(eventData)
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
logError = (error_code, error_description, type, related_id = '', subject_id = ExperimentalSubject.current?.zooniverseId) ->
  eventData = buildEventData(type, related_id, subject_id)
  eventData['errorCode'] = error_code
  eventData['errorDescription'] = error_description
  eventData['userID'] = if Geordi.UserGetter.currentUserID? then Geordi.UserGetter.currentUserID else if User.current?.zooniverse_id? then User.current?.zooniverse_id else "(anonymous)"
  logToGeordi eventData

exports.logEvent = logEvent
exports.logError = logError