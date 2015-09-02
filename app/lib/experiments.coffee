$ = require('jqueryify')
ExperimentalSubject = require 'models/experimental_subject'
Geordi = (require 'lib/analytics').Geordi

module.exports = class ExperimentServerClient

  # CONSTANTS #

  ###
  Define the active experiment here by using a string which exists in http://experiments.zooniverse.org/active_experiments
  If no experiments should be running right now, set this to null, false or ""
  ###
  ACTIVE_EXPERIMENT:null
  #ACTIVE_EXPERIMENT: "SerengetiBlanksExperiment1"

  ###
  The URL of the experiment server to use
  ###
  # prod:
  EXPERIMENT_SERVER_URL: "http://experiments.zooniverse.org/"
  # dev:
  #EXPERIMENT_SERVER_URL = "http://localhost:4567/"

  COHORT_CONTROL: "control"
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
    Geordi.UserGetter.currentUserID = null

  ###
  when we first get participant, and the user has not started experiment in a previous sessions, we'll need to log it to Geordi
  ###
  checkForExperimentStartAndLogIt: (participant) ->
    if participant.blank_subjects_seen.length==0 && participant.non_blank_subjects_seen.length==0
      Geordi.logEvent 'experimentStart'

  ###
  when we first discover that a user has ended the experiment, we log it to Geordi
  ###
  checkForExperimentEndAndLogIt: (participant) ->
    if !experimentCompleted && participant? && !participant.active && participant.blank_subjects_available && participant.blank_subjects_available.length==0 && participant.non_blank_subjects_available && participant.non_blank_subjects_available.length==0
      @experimentCompleted = true
      Geordi.logEvent 'experimentEnd'

  ###
  when we get participant, we need to log to Geordi if the user's was excluded
  ###
  checkForExcludedAndLogIt: (participant) ->
    if !@excludedReason? && participant.excluded
      # if not previously logged, log it.
      @excludedReason = participant.excluded_reason
      Geordi.logEvent 'experimentExcluded',participant.excluded_reason

  ###
  This method will contact the experiment server to find the participant(experimental data) for this user in the specified experiment
  ###
  getParticipant: () ->
    Geordi.UserGetter.currentUserID = "(unknown)"
    Geordi.UserGetter.getUserIDorIPAddress()
    .then (data) =>
      if data?
        Geordi.UserGetter.currentUserID = data.toString()
    .fail =>
      Geordi.UserGetter.currentUserID = "(anonymous)"
    .always =>
      eventualParticipant = new $.Deferred
      if @ACTIVE_EXPERIMENT?
        now = new Date().getTime()
        if @lastFailedAt?
          timeSinceLastFail = now - @lastFailedAt.getTime()
        if @lastFailedAt == null || timeSinceLastFail > @RETRY_INTERVAL
          try
            $.get(@EXPERIMENT_SERVER_URL+ 'experiment/' + @ACTIVE_EXPERIMENT + '?user_id=' + Geordi.UserGetter.currentUserID)
            .then (participant) =>
              @checkForExcludedAndLogIt participant
              @checkForExperimentEndAndLogIt participant
              @currentCohort = participant.cohort
              if !@currentParticipant?
                Geordi.logEvent 'experimentResume'
                @checkForExperimentStartAndLogIt participant
              @currentParticipant = participant
              eventualParticipant.resolve participant
            .fail =>
              @lastFailedAt = new Date()
              Geordi.logError "500", "Couldn't retrieve experimental participant data", "error"
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
  getCohort: =>
    eventualCohort = new $.Deferred
    if @ACTIVE_EXPERIMENT?
      now = new Date().getTime()
      if @lastFailedAt?
        timeSinceLastFail = now - @lastFailedAt.getTime()
      if @lastFailedAt == null || timeSinceLastFail > @RETRY_INTERVAL
        try
          $.get(@EXPERIMENT_SERVER_URL+'experiment/' + @ACTIVE_EXPERIMENT + '?user_id=' + Geordi.UserGetter.currentUserID)
          .then (participant) =>
            @checkForExperimentEndAndLogIt participant
            @currentCohort = participant.cohort
            if !currentParticipant?
              Geordi.logEvent 'experimentResume'
              @checkForExperimentStartAndLogIt(participant)
            @currentParticipant = participant
            eventualCohort.resolve participant.cohort
          .fail =>
            @lastFailedAt = new Date()
            Geordi.logError "500", "Couldn't retrieve experimental cohort data", "error"
            eventualCohort.resolve null
        catch error
          eventualCohort.resolve null
      else
        eventualCohort.resolve null
    else
      eventualCohort.resolve null
    eventualCohort.promise()
