$ = require('jqueryify')
Subject = require('models/subject')

module.exports = class ExperimentServerClient
  constructor: (@Geordi) ->

  # CONSTANTS #
  ###
  Define the active experiment here by using a string which exists in http://experiments.zooniverse.org/active_experiments
  If no experiments should be running right now, set this to null, false or ""
  ###
  ACTIVE_EXPERIMENT: "SerengetiMessagingExperiment2"
  #ACTIVE_EXPERIMENT: "SerengetiBlanksExperiment1"
  ###
  The URL of the experiment server to use
  ###
  # prod:
  EXPERIMENT_SERVER_URL: "http://experiments.zooniverse.org/"
  # staging:
  #EXPERIMENT_SERVER_URL: "http://experiments.staging.zooniverse.org/"
  # dev:
  #EXPERIMENT_SERVER_URL: "http://localhost:4567/"

  COHORT_CONTROL: "control"
  COHORT_UI_EXPERIMENT: "experimental_ui"
  COHORT_0: "0"
  COHORT_20: "20"
  COHORT_40: "40"
  COHORT_60: "60"
  COHORT_80: "80"
  COHORT_INELIGIBLE: "ineligible"
  COHORT_INSERTION: "interesting"
  SOURCE_INSERTED: "Inserted From Set"
  SOURCE_RANDOM: "Random From Set"
  SOURCE_NORMAL: "Normal Random"
  SOURCE_BLANK: "Blank"
  SOURCE_NON_BLANK: "Non-Blank"
  ###
  When an error is encountered from the experiment server, this is the period, in milliseconds, that the code below will wait before any further attempts to contact it.
  ###
  RETRY_INTERVAL: 300000 # (5 minutes) #
  # VARIABLES #
  ###
  Do not modify this initialization, it is used by the code below to keep track of the current participant
  ###
  currentParticipant: null
  ###
  Do not modify this initialization, it is used by the code below to keep track of the current cohort (which can change for a participant as they progress)
  ###
  currentCohort: null
  ###
  Do not modify this initialization, it is used to keep track of when the last experiment server failure was
  ###
  lastFailedAt: null
  ###
  Do not modify this initialization, it is used to keep track of which subjects are insertions and which are random
  ###
  sources: {}
  ###
  Do not modify this initialization, it is used to track any changes of cohort for this user
  ###
  excludedReason: null
  ###
  Do not modify this initialization, it is used to track when the user has finished the experiment
  ###
  experimentCompleted: false
  ###
  Upon logout, user must be forgotten
  ###
  resetExperimentalFlags: =>
    @experimentCompleted = false
    @excludedReason = null
    @currentCohort = null
    @currentParticipant = null
    @Geordi.UserStringGetter.currentUserID = null

  ###
  This method will contact the experiment server to find the cohort for this user in the specified experiment
  ###
  getCohort: =>
    eventualCohort = new $.Deferred
    if @ACTIVE_EXPERIMENT?
      now = new Date().getTime()
      if @currentCohort?
        eventualCohort.resolve @currentCohort
      else
        if @lastFailedAt?
          timeSinceLastFail = now - @lastFailedAt.getTime()
        if @lastFailedAt == null || timeSinceLastFail > @RETRY_INTERVAL
          try
            $.get(@EXPERIMENT_SERVER_URL+'experiment/' + @ACTIVE_EXPERIMENT + '?userid=' + @Geordi.UserStringGetter.currentUserID)
            .then (participant) =>
              @currentCohort = participant.cohort
              @currentParticipant = participant
              eventualCohort.resolve participant.cohort
            .fail =>
              @lastFailedAt = new Date()
              @Geordi.logEvent {
                type: "error"
                errorCode: "500"
                errorDescription: "Couldn't retrieve experimental cohort data"
              }
              eventualCohort.resolve null
          catch error
            eventualCohort.resolve null
        else
          eventualCohort.resolve null
    else
      eventualCohort.resolve null
    eventualCohort.promise()
