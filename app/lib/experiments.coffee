$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
Subject = require 'models/subject'
AnalyticsLogger = require 'lib/analytics'

###
Define the active experiment here by using a string which exists in http://experiments.zooniverse.org/active_experiments
If no experiments should be running right now, set this to null, false or ""
WARNING: using a non-existent experiment will crash the webapp.
###
activeExperiment = null


currentExperiment = activeExperiment
currentCohorts = []
lastFailedAt = null

###
This will contact the experiment server to find the cohort for this user & subject in the specified experiment
###
getCohortRetriever = (user_id = User.current?.zooniverse_id, subject_id = Subject.current?.zooniverseId) ->
  if typeof activeExperiment=="undefined" || !activeExperiment
    null
  else
    if typeof currentCohorts[currentExperiment] == 'undefined'
      now = new Date().getTime()
      if null!=lastFailedAt
        timeSinceLastFail = now - lastFailedAt.getTime()
      if null==lastFailedAt || timeSinceLastFail > 30000
        try
          $.ajax({
            url: 'http://experiments.zooniverse.org/experiment/' + currentExperiment + '?userid=' + user_id,
            dataType: 'json',
            error: =>
              lastFailedAt = new Date()
          }).promise().done( (data, textStatus, jqXHR) =>
            currentCohorts[currentExperiment] = data.cohort
            AnalyticsLogger.logEvent 'split'
          ).fail( (jqXHR, textStatus, errorThrown) =>
            AnalyticsLogger.logError "500", "Couldn't retrieve experimental split data", "error"
          )
        catch error
          null
      else
        null
    else
      null

exports.getCohortRetriever = getCohortRetriever
exports.currentExperiment = currentExperiment
exports.currentCohorts = currentCohorts
