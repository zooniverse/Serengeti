$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
ExperimentalSubject = require 'models/experimental_subject'
AnalyticsLogger = require 'lib/analytics'

# CONSTANTS #

###
Define the active experiment here by using a string which exists in http://experiments.zooniverse.org/active_experiments
If no experiments should be running right now, set this to null, false or ""
###
ACTIVE_EXPERIMENT = "SerengetiInterestingAnimalsExperiment1"

###
The URL of the experiment server to use
###
EXPERIMENT_SERVER_URL = "http://experiments.zooniverse.org/"
#EXPERIMENT_SERVER_URL = "http://localhost:4567/"

COHORT_CONTROL = "control"
COHORT_INSERTION = "interesting"

###
When an error is encountered from the experiment server, this is the period, in milliseconds, that the code below will wait before any further attempts to contact it.
###
RETRY_INTERVAL = 300000 # (5 minutes) #

# VARIABLES #

###
Do not modify this initialization, it is used by the code below to keep track of the cohort so as to avoid checking many times
###
currentCohort = null

###
Do not modify this initialization, it is used to keep track of when the last experiment server failure was
###
lastFailedAt = null

###
This method will contact the experiment server to find the participant(experimental data) for this user in the specified experiment
###
getParticipant = (user_id = User.current?.zooniverse_id) ->
  eventualParticipant = new $.Deferred
  if ACTIVE_EXPERIMENT?
    now = new Date().getTime()
    if lastFailedAt?
      timeSinceLastFail = now - lastFailedAt.getTime()
    if lastFailedAt == null || timeSinceLastFail > RETRY_INTERVAL
      try
        $.get('http://experiments.zooniverse.org/experiment/' + ACTIVE_EXPERIMENT + '?user_id=' + user_id)
        .then (data) =>
          eventualParticipant.resolve data
        .fail =>
          lastFailedAt = new Date()
          AnalyticsLogger.logError "500", "Couldn't retrieve experimental participant data", "error"
          eventualParticipant.resolve null
      catch error
        eventualParticipant.resolve null
    else
      eventualParticipant.resolve null
  else
    eventualParticipant.resolve null
  eventualParticipant.promise()

###
This method will contact the experiment server to find the cohort for this user in the specified experiment
###
getCohort = (user_id = User.current?.zooniverse_id) ->
  eventualCohort = new $.Deferred
  if ACTIVE_EXPERIMENT?
    now = new Date().getTime()
    if lastFailedAt?
      timeSinceLastFail = now - lastFailedAt.getTime()
    if lastFailedAt == null || timeSinceLastFail > RETRY_INTERVAL
      try
        $.get('http://experiments.zooniverse.org/experiment/' + ACTIVE_EXPERIMENT + '?userid=' + user_id)
        .then (data) =>
          currentCohort = data.cohort
          eventualCohort.resolve data.cohort
        .fail =>
          lastFailedAt = new Date()
          AnalyticsLogger.logError "500", "Couldn't retrieve experimental cohort data", "error"
          eventualCohort.resolve null
      catch error
        eventualCohort.resolve null
    else
      eventualCohort.resolve null
  else
    eventualCohort.resolve null
  eventualCohort.promise()

exports.getCohort = getCohort
exports.getParticipant = getParticipant
exports.currentCohort = currentCohort
exports.ACTIVE_EXPERIMENT = ACTIVE_EXPERIMENT
exports.EXPERIMENT_SERVER_URL = EXPERIMENT_SERVER_URL
exports.COHORT_CONTROL = COHORT_CONTROL
exports.COHORT_INSERTION = COHORT_INSERTION