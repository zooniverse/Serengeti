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


currentExperiment = activeExperiment
currentCohorts = []

###
This will contact the experiment server to find the cohort for this user & subject in the specified experiment
###
getCohortRetriever = (user_id = User.current?.zooniverse_id, subject_id = Subject.current?.zooniverseId) ->
  if typeof activeExperiment=="undefined" || !activeExperiment
    null
  else
    if typeof currentCohorts[currentExperiment] == 'undefined'
      $.ajax({
        url: 'http://experiments.zooniverse.org/experiment/' + currentExperiment + '?userid=' + user_id,
        dataType: 'json'
      }).promise().done( (data, textStatus, jqXHR) ->
        currentCohorts[currentExperiment] = data.cohort
        AnalyticsLogger.logEvent 'split'
      ).fail( (jqXHR, textStatus, errorThrown) ->
        AnalyticsLogger.logError errorThrown, textStatus, 'split'
      )
    else
      null

exports.getCohortRetriever = getCohortRetriever
exports.currentExperiment = currentExperiment
exports.currentCohorts = currentCohorts
