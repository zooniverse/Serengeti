Api = require 'zooniverse/lib/api'
Subject = require 'models/subject'
Experiments = require 'lib/experiments'
Intervention = require 'lib/intervention_agent'
User = require 'zooniverse/lib/models/user'

class ExperimentalSubject extends Subject
  @agent = null

  # since we don't get hold of a random subject's ID until time of GETting it, we use a placeholder to represent that random subject.
  @PLACEHOLDER = "(random-ID)"

  # instantiate model from raw JSON API response
  @fromJSON: (raw) =>
    console.log 'child version of fromJSON'
    subject = @create
      id: raw.id
      zooniverseId: raw.zooniverse_id
      workflowId: raw.workflow_ids[0]
      location: raw.location
      coords: raw.coords
      metadata: raw.metadata

    # Preload images.
    (new Image).src = src for src in subject.location.standard

    subject

  @create: (attributes) ->
    console.log 'experimental subject create, passing up'
    super attributes

  constructor: ->
    console.log 'in experimental subject constructor'
    Experiments.getCohort()
      .then =>
        console.log 'got cohort'
      .fail =>
        console.log 'not got cohort'
      .always =>
        debugger
        if Experiments.ACTIVE_EXPERIMENT? && Experiments.currentCohort?
          if Experiments.currentCohort == 'interesting'
            @agent = new Intervention.InterestingAgent
          else
            if Experiments.currentCohort != 'control'
              # TODO log unknown/unset cohort
              console.log 'unknown or sunset cohort'
            @agent = new Intervention.ControlAgent
          debugger
          console.log @agent
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
      #tryAgain = => @next callback
      #setTimeout tryAgain, 500
      #console.log 'trying again in 0.5s'
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
