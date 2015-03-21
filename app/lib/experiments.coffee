$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
Subject = require 'models/experimental_subject'
AnalyticsLogger = require 'lib/analytics'

# CONSTANTS #

###
Define the active experiment here by using a string which exists in http://experiments.zooniverse.org/active_experiments
If no experiments should be running right now, set this to null, false or ""
###
ACTIVE_EXPERIMENT = null

###
When an error is encountered from the experiment server, this is the period, in milliseconds, that the code below will wait before any further attempts to contact it.
###
RETRY_INTERVAL = 300000 # (5 minutes) #

###
This determines how many random subjects will be served for every inserted image. For example, a value of 3 means that for every inserted subject, there will be three random subjects
###
INSERTION_RATIO = 3

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
This method will contact the experiment server to find the cohort for this user & subject in the specified experiment
###
getCohort = (user_id = User.current?.zooniverse_id, subject_id = Subject.current?.zooniverseId) ->
  eventualCohort = new $.Deferred
  if currentCohort?
    eventualCohort.resolve currentCohort
  else
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
            AnalyticsLogger.logError "500", "Couldn't retrieve experimental split data", "error"
            eventualCohort.resolve null
        catch error
          eventualCohort.resolve null
      else
        eventualCohort.resolve null
    else
      eventualCohort.resolve null
  eventualCohort.promise()

exports.getCohort = getCohort
exports.currentCohort = currentCohort
exports.ACTIVE_EXPERIMENT = ACTIVE_EXPERIMENT
exports.INSERTION_RATIO = INSERTION_RATIO
