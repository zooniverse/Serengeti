ZooUserStringGetter = require 'zoo-user-getter'

###
dummy NOOP experiment server to ensure Geordi client still works even when
no experiment server client specified.
###
DummyExperimentServerClient = class ExperimentServerClient
  currentCohort: null
  ACTIVE_EXPERIMENT: null
  getCohort: ->
    eventualCohort = new $.Deferred()
    eventualCohort
    .then ->
      eventualCohort.resolve null
    eventualCohort.promise()

module.exports = class Geordi

  GEORDI_STAGING_SERVER_URL:
    'http://geordi.staging.zooniverse.org/api/events/'
  GEORDI_PRODUCTION_SERVER_URL:
    'http://geordi.zooniverse.org/api/events/'

  defaultSubjectGetter: ->
    "(unknown)"

  defaultLastKnownCohortGetter: ->
    null

  defaultZooUserIDGetter: ->
    null

  defaultProjectToken: "unspecified"
  defaultExperimentServerClient: new DummyExperimentServerClient()

  getCurrentSubject: @defaultSubjectGetter
  getCurrentUserID: @defaultZooUserIDGetter

  constructor: (config) ->
    config["server"] = "staging" if not "server" of config
    config["projectToken"] = @defaultProjectToken if (not "projectToken" of config) or (not config["projectToken"] instanceof String) or (not config["projectToken"].length>0)
    config["zooUserIDGetter"] = @defaultZooUserIDGetter if (not "zooUserIDGetter" of config) or (not config["zooUserIDGetter"] instanceof Function)
    config["experimentServerClient"] = @defaultExperimentServerClient if not "experimentServerClient" of config
    config["subjectGetter"] = @defaultSubjectGetter if (not "subjectGetter" of config) or (not config["subjectGetter"] instanceof Function)
    if config["server"] == "production"
      @GEORDI_SERVER_URL = @GEORDI_PRODUCTION_SERVER_URL
    else
      @GEORDI_SERVER_URL = @GEORDI_STAGING_SERVER_URL
    @experimentServerClient = config["experimentServerClient"]
    @getCurrentSubject = config["subjectGetter"]
    @getCurrentUserID = config["zooUserIDGetter"]
    @projectToken = config["projectToken"]
    @UserStringGetter = new ZooUserStringGetter(@getCurrentUserID)

  ###
  log event with Google Analytics
  ###
  logToGoogle: (eventData) ->
    dataLayer.push {
      event: "gaTriggerEvent"
      project_token: eventData['projectToken']
      user_id: eventData['userID']
      subject_id: eventData['subjectID']
      geordi_event_type: eventData['type']
      classification_id: eventData['relatedID']
    }

  ###
  log event with Geordi v2.1
  ###
  logToGeordi: (eventData) =>
    $.ajax {
      url: @GEORDI_SERVER_URL,
      type: 'POST',
      contentType: 'application/json; charset=utf-8',
      data: JSON.stringify(eventData),
      dataType: 'json'
    }

  addUserDetailsToEventData: (eventData) =>
    eventualUserIdentifier = new $.Deferred
    @UserStringGetter.getUserIDorIPAddress()
    .then (data) =>
      if data?
        @UserStringGetter.currentUserID = data
    .fail =>
      @UserStringGetter.currentUserID = "(anonymous)"
    .always =>
      eventData['userID'] = @UserStringGetter.currentUserID
      eventualUserIdentifier.resolve eventData
    eventualUserIdentifier.promise()

  addCohortToEventData: (eventData) =>
    eventualEventData = new $.Deferred
    @experimentServerClient.getCohort()
    .then (cohort) =>
      if cohort?
        eventData['cohort'] = cohort
        @experimentServerClient.currentCohort = cohort
    .always ->
      eventualEventData.resolve eventData
    eventualEventData.promise()

  buildEventData: (type, related_id = null,
                   subject_id = @getCurrentSubject()) =>
    eventData = {}
    eventData['browserTime'] = Date.now()
    eventData['projectToken'] = @projectToken
    eventData['subjectID'] = subject_id
    eventData['type'] = type
    eventData['relatedID'] = related_id
    eventData['serverURL'] = location.origin
    eventData['data'] = JSON.stringify({})
    eventData['experiment'] = @experimentServerClient.ACTIVE_EXPERIMENT
    eventData['errorCode'] = ""
    eventData['errorDescription'] = ""
    if @experimentServerClient.currentCohort?
      eventData['cohort'] = @experimentServerClient.currentCohort
    eventData['userID'] = "(anonymous)"
    eventData

  ###
  This will log a user interaction both in the Geordi
  analytics API and in Google Analytics.
  ###
  logEvent: (type, related_id = '', subject_id = @getCurrentSubject()) =>
    eventData = @buildEventData(type, related_id, subject_id)
    @addUserDetailsToEventData(eventData)
    .always (eventData) =>
      if @experimentServerClient.ACTIVE_EXPERIMENT==null or @experimentServerClient.currentCohort?
        @logToGeordi eventData
        @logToGoogle eventData
      else
        @addCohortToEventData(eventData)
        .always (eventData) =>
          @logToGeordi eventData
          @logToGoogle eventData

  ###
  This will log an error in Geordi only.
  In order to guarantee that this works, no new AJAX
  calls for cohort or user IP are initiated
  ###
  logError: (error_code, error_description, type,
             related_id = '', subject_id = @getCurrentSubject()) =>
    eventData = buildEventData(type, related_id, subject_id)
    eventData['errorCode'] = error_code
    eventData['errorDescription'] = error_description
    if @UserStringGetter.currentUserID?
      eventData['userID'] = @UserStringGetter.currentUserID
    else
      eventData['userID'] = @UserStringGetter.ANONYMOUS
    @logToGeordi eventData

