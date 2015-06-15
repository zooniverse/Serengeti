$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
ExperimentalSubject = require 'models/experimental_subject'
AnalyticsLogger = require 'lib/analytics'

# CONSTANTS #

###
Define the active experiment here by using a string which exists in http://experiments.zooniverse.org/active_experiments
If no experiments should be running right now, set this to null, false or ""
###
ACTIVE_EXPERIMENT = "SerengetiBlanksExperiment1"

###
The URL of the experiment server to use
###
# prod:
EXPERIMENT_SERVER_URL = "http://experiments.staging.zooniverse.org/"
# dev:
#EXPERIMENT_SERVER_URL = "http://localhost:4567/"

COHORT_CONTROL = "control"
COHORT_0 = "0"
COHORT_20 = "20"
COHORT_40 = "40"
COHORT_60 = "60"
COHORT_80 = "80"
COHORT_INELIGIBLE = "ineligible"
COHORT_INSERTION = "interesting"
SOURCE_INSERTED = "Inserted From Set"
SOURCE_RANDOM = "Random From Set"
SOURCE_NORMAL = "Normal Random"
SOURCE_BLANK = "Blank"
SOURCE_NON_BLANK = Non-Blank"

###
When an error is encountered from the experiment server, this is the period, in milliseconds, that the code below will wait before any further attempts to contact it.
###
RETRY_INTERVAL = 300000 # (5 minutes) #

# VARIABLES #

###
Do not modify this initialization, it is used by the code below to keep track of the current participant
###
currentParticipant = null

###
Do not modify this initialization, it is used by the code below to keep track of the current cohort (which can change for a participant as they progress)
###
currentCohort = null

###
Do not modify this initialization, it is used to keep track of when the last experiment server failure was
###
lastFailedAt = null

###
Do not modify this initialization, it is used to keep track of which subjects are insertions and which are random
###
sources = {}

###
Do not modify this initialization, it is used to track any changes of cohort for this user
###
excludedReason = null

###
when we first get participant, and the user has not started experiment in a previous sessions, we'll need to log it to Geordi
###
checkForExperimentStartAndLogIt = (participant) ->
  if participant.blank_subjects_seen.length==0 && participant.non_blank_subjects_seen.length==0
    AnalyticsLogger.logEvent 'experimentStart'

###
  TODO fix this
when we get cohort, and it has changed from interesting to control, must be end of experiment, we'll need to log it to Geordi
###
checkForExperimentEndAndLogIt = (oldCohort,newCohort) ->
  if oldCohort==COHORT_INSERTION && newCohort==COHORT_CONTROL
    AnalyticsLogger.logEvent 'experimentEnd'

###
when we get participant, we need to log to Geordi if the user's cohort was changed
###
checkForExcludedAndLogIt = (participant) ->
  if !excludedReason? && participant.excluded
    # if not previously logged, log it.
    excludedReason = participant.excluded_reason
    AnalyticsLogger.logEvent 'experimentExcluded',participant.excluded_reason

###
This method will contact the experiment server to find the participant(experimental data) for this user in the specified experiment
###
getParticipant = () ->
  currentUserID = "(unknown)"
  AnalyticsLogger.getUserIDorIPAddress()
  .then (data) =>
    if data?
      currentUserID = data
  .fail (data) =>
    currentUserID = "(anonymous)"
  .always =>
    user_id = currentUserID
    eventualParticipant = new $.Deferred
    if ACTIVE_EXPERIMENT?
      now = new Date().getTime()
      if lastFailedAt?
        timeSinceLastFail = now - lastFailedAt.getTime()
      if lastFailedAt == null || timeSinceLastFail > RETRY_INTERVAL
        try
          $.get(EXPERIMENT_SERVER_URL+ 'experiment/' + ACTIVE_EXPERIMENT + '?user_id=' + user_id)
          .then (participant) =>
            checkForExcludedAndLogIt participant
            checkForExperimentEndAndLogIt currentCohort,participant.cohort
            currentCohort = participant.cohort
            if !currentParticipant?
              AnalyticsLogger.logEvent 'experimentResume'
              checkForExperimentStartAndLogIt participant
            currentParticipant = participant
            eventualParticipant.resolve participant
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
        $.get(EXPERIMENT_SERVER_URL+'experiment/' + ACTIVE_EXPERIMENT + '?user_id=' + user_id)
        .then (participant) =>
          checkForExperimentEndAndLogIt currentCohort, participant.cohort
          currentCohort = participant.cohort
          if !currentParticipant?
            AnalyticsLogger.logEvent 'experimentResume'
            checkForExperimentStartAndLogIt(participant)
          currentParticipant = participant
          eventualCohort.resolve participant.cohort
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
exports.currentParticipant = currentParticipant
exports.ACTIVE_EXPERIMENT = ACTIVE_EXPERIMENT
exports.EXPERIMENT_SERVER_URL = EXPERIMENT_SERVER_URL
exports.COHORT_CONTROL = COHORT_CONTROL
exports.COHORT_INSERTION = COHORT_INSERTION
exports.SOURCE_INSERTED = SOURCE_INSERTED
exports.SOURCE_RANDOM = SOURCE_RANDOM
exports.SOURCE_NORMAL = SOURCE_NORMAL
exports.SOURCE_BLANK = SOURCE_BLANK
exports.SOURCE_NON_BLANK = SOURCE_NON_BLANK
exports.COHORT_0 = COHORT_0
exports.COHORT_20 = COHORT_20
exports.COHORT_40 = COHORT_40
exports.COHORT_60 = COHORT_60
exports.COHORT_80 = COHORT_80
exports.COHORT_INELIGIBLE = COHORT_INELIGIBLE
exports.sources = sources