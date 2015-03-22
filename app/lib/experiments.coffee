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
When an error is encountered from the experiment server, this is the period, in milliseconds, that the code below will
  wait before any further attempts to contact it.
###
RETRY_INTERVAL = 300000 # (5 minutes) #

###
This determines how many random subjects will be served for every inserted image. For example, a value of 3 means that
  for every inserted subject, there will be three random subjects
###
INSERTION_RATIO = 3

###
Until the experiment server supports user profile storage, the profiles will be hardcoded here for demo purposes.
###
SPECIES_INTEREST_PROFILES = {
  "1821039": ['giraffe','lionmale','lionfemale'] # alexbfree (interesting)
  "1928567": ['giraffe','lionmale','lionfemale'] # alexzootest1 (interesting)
  "1928568": ['leopard','baboon'] # alexzootest2 (interesting)
  "1928569": ['zebra','gazellethomsons'] # alexzootest3 (control)
  "1928585": ['hippopotamus'] # alexzootest17 (control)
}

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
until the experiment server supports storage of viewed and available subjects, we use local variables for storage.
since this will not yet persist across sessions so is only a temporary measure.
Structure of each object element:
  intervention_histories [userID] = { 'active': true, 'interesting_subjects_viewed':['ASD123','ASD134'], .... }
###
interventionHistories = {}

###
This method will contact the experiment server to find the cohort for this user & subject in the specified experiment
###
getCohort = (user_id = User.current?.zooniverse_id, subject_id = ExperimentalSubject.current?.zooniverseId) ->
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
exports.SPECIES_INTEREST_PROFILES = SPECIES_INTEREST_PROFILES
exports.interventionHistories = interventionHistories