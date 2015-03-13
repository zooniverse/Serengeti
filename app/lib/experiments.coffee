$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
Subject = require 'models/subject'
AnalyticsLogger = require 'lib/analytics'

###
Define the active experiment here by using a string which exists in http://experiments.zooniverse.org/active_experiments
If no experiments should be running right now, set this to null, false or ""
WARNING: using a non-existent experiment will crash the webapp.
###
activeExperiment = "SerengetiInterestingAnimalsExperiment1"

currentCohort = null
lastFailedAt = null

###
This will contact the experiment server to find the cohort for this user & subject in the specified experiment
###
getCohort = (user_id = User.current?.zooniverse_id, subject_id = Subject.current?.zooniverseId) ->
  if typeof currentCohort == 'undefined' || currentCohort==null
    if typeof activeExperiment!="undefined" && activeExperiment
      now = new Date().getTime()
      if lastFailedAt
        timeSinceLastFail = now - lastFailedAt.getTime()
      else
        if timeSinceLastFail > 30000
          try
            eventualCohort = new $.Deferred
            $.get('http://experiments.zooniverse.org/experiment/' + currentExperiment + '?userid=' + user_id)
              .then (data) =>
                currentCohort = data.cohort
                eventualCohort.resolve data.cohort
                AnalyticsLogger.logEvent 'split'
              .fail (error) =>
                lastFailedAt = new Date()
                AnalyticsLogger.logError "500", "Couldn't retrieve experimental split data", "error"
                eventualCohort.resolve null
            eventualCohort.promise()
          catch error
            null
  else
    currentCohort

exports.getCohort = getCohort
exports.currentCohort = currentCohort
exports.activeExperiment = activeExperiment
