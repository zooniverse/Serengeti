$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
Subject = require 'models/subject'
AnalyticsLogger = require 'analytics'
currentExperiment = null
currentCohort = null

###
This will contact the experiment server to find the cohort for this user & subject
###
getExperiment = (experiment, user_id = User.current?.zooniverse_id, subject_id = Subject.current?.zooniverseId) ->
  currentExperiment = experiment;
  currentCohort = null;
  promise = $.ajax({
    url: 'http://experiments.zooniverse.org/experiment/' + experiment + '?userid=' + user_id,
    dataType: 'json'
  }).promise().done( (response) ->
    currentCohort = getCohortFromResponse response
    AnalyticsLogger.logEvent 'split'
  ).fail( () ->
    AnalyticsLogger.logEvent 'splitError'
  )
  promise

getCohortFromResponse = (response) ->
  response.cohort

exports.getCohortFromResponse = getCohortFromResponse
exports.getExperiment = getExperiment
exports.currentExperiment = currentExperiment
exports.currentCohort = currentCohort
