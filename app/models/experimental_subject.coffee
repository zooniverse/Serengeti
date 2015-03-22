Api = require 'zooniverse/lib/api'
Subject = require 'models/subject'
Experiments = require 'lib/experiments'
Intervention = require 'lib/intervention_agent'

class ExperimentalSubject extends Subject
  @agent = null

  # since we don't get hold of a random subject's ID until time of GETting it, we use a placeholder to represent that random subject.
  @PLACEHOLDER = "(random-ID)"

  constructor: ->
    if Experiments.ACTIVE_EXPERIMENT? && Experiments.currentCohort?
      @agent = Intervention.agents[Experiments.currentCohort]
      if Experiments.currentCohort == "interesting"
        history = @agent.data.interventionHistory
        if history.active
          # initialize experimental subject sets when first starting experiment
          if not history.intervention_subjects_viewed?
            history.intervention_subjects_viewed = []
          if not history.control_subjects_viewed?
            history.control_subjects_viewed = []
          if history.intervention_subjects_available.length == 0
            mostInterestingSpecies = @agent.getMostInterestingSpecies 2
            for species in mostInterestingSpecies
              @agent.addInterventionSubjectsFor species
          if history.control_subjects_available.length == 0
            # add placeholders for future retrieval of INSERTION_RATIO times as many random subjects as there are insertions
            controlSubjectsToAddForThisExperiment = Experiments.INSERTION_RATIO * history.intervention_subjects_available.length
            history.control_subjects_available = []
            for [1..controlSubjectsToAddForThisExperiment]
              history.control_subjects_available.push @PLACEHOLDER
          if history.control_subjects_available.length == 0 && history.intervention_subjects_available.length == 0
            # TODO log the end of the experiment for this user & fall back to control agent
            history.active = false
    else
      # TODO log problem with getting cohort

  # randomly select a subject from across control & intervention subjects, update the intervention history, and return it
  @extractSubjectAtRandom: =>
    subjectID = null
    if @agent not instanceof Intervention.ControlAgent
      history = @agent.data.interventionHistory
      selectionSet = history.control_subjects_available.concat history.intervention_subjects_available
      if selectionSet.length > 0
        subjectID = selectionSet[Math.floor(Math.random() * selectionSet.length)]
        if subjectID == @PLACEHOLDER
          # random subject
          history.control_subjects_available = history.control_subjects_available.slice(0, -1)
          history.control_subjects_viewed.push @PLACEHOLDER
        else
          # intervention subject
          history.intervention_subjects_available = history.intervention_subjects_available.filter (value) -> value isnt subjectID
          history.intervention_subjects_viewed.push subjectID
    subjectID

  # for interesting cohort users, we will randomly show either a known interesting or random unknown image. Always fetch one at a time to avoid subject loss.
  @next: (callback) =>
    if Experiments.ACTIVE_EXPERIMENT? && Experiments.currentCohort?
      if Experiments.currentCohort == "interesting"
        # pick one randomly across control & intervention subjects
        subjectID = @extractSubjectAtRandom
        if subjectID?
          @current.destroy() if @current?
          if subjectID == @PLACEHOLDER
            fetcher = @fetch 1
          else
            fetcher = @subjectFetch subjectID
          @advance fetcher, callback
        else
          # user has exhausted all their subjects in the experiment; fall back to control
          super callback
    else
      # TODO: log that failed to run experimental split for interesting user - fall back to control
      super callback

  # get a specific subject by ID from the API and instantiate it as a model
  @subjectFetch: (subjectID) =>
    subjectFetcher = new $.Deferred

    getter = Api.get("/projects/serengeti/subjects/#{subjectID}").deferred

    getter.done (rawSubject) =>
      subjectFetcher.resolve (@fromJSON rawSubject)

    getter.fail ->
      subjectFetcher.resolve null

    subjectFetcher.promise()

module.exports = ExperimentalSubject
