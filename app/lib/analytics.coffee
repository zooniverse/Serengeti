$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
Subject = require 'models/subject'
Experiments = require 'lib/experiments'
eventData = {}
iteration = 0

buildEventData = (type, related_id = null, user_id = User.current?.zooniverse_id, subject_id = Subject.current?.zooniverseId) ->
  eventData['time'] = Date.now()
  eventData['projectToken'] = 'serengeti'
  eventData['userID'] = user_id
  eventData['subjectID'] = subject_id
  eventData['type'] = type
  eventData['relatedID'] = related_id
  eventData['experiment'] = Experiments.currentExperiment
  eventData['errorCode'] = ""
  eventData['errorDescription'] = ""
  eventData['cohort'] = Experiments.currentCohorts[eventData['experiment']]
  if typeof eventData['cohort'] == 'undefined'
    cohortRetriever = Experiments.getCohortRetriever()
    if cohortRetriever
      cohortRetriever.then( =>
         eventData['cohort'] = Experiments.currentCohorts[eventData['experiment']]
      )
    else
      null
  else
    null

###
log event with Geordi v2
###
logToGeordi = =>
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
logToGoogle = =>
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
  deferred = buildEventData(type, related_id, user_id, subject_id)
  deferredType = type
  if deferred == null
    # cohort already retrieved once for this user, no need to wait
    logToGeordi eventData
    logToGoogle eventData
    true
  else
    # log to geordi when ajax request is completed
    deferred.then( =>
      eventData.type = deferredType
      logToGeordi eventData
      logToGoogle eventData
      true
    )
    false

###
This will log an error in Geordi only
###
logError = (error_code, error_description, type, related_id = '', user_id = User.current?.zooniverse_id, subject_id = Subject.current?.zooniverseId) ->
  deferred = buildEventData(type, related_id, user_id, subject_id)
  eventData['errorCode'] = error_code
  eventData['errorDescription'] = error_description
  if deferred == null
    # cohort already retrieved once for this user, no need to wait
    logToGeordi eventData
    true
  else
    # log to geordi when ajax request is completed
    deferred.then( =>
      logToGeordi eventData
      true
    )
    false

exports.logEvent = logEvent
exports.logError = logError

