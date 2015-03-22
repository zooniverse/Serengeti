{Model} = require 'spine'
$ = require 'jqueryify'
Api = require 'zooniverse/lib/api'
Experiments = require 'lib/experiments'
User = require 'zooniverse/lib/models/user'
seasons = require 'lib/seasons'
Intervention = require 'lib/intervention_agent'

class Subject extends Model
  @configure 'Subject', 'zooniverseId', 'workflowId', 'location', 'coords', 'metadata', 'cohort', 'source','testFn','initializeAgent','ensureCohortIsKnown'

  @queueLength: 3
  @current: null
  @cohort = null
  @agent = null
  @testFn = =>
    console.log 'testFn'

  @initializeAgent = =>
    if Experiments.ACTIVE_EXPERIMENT? && @cohort?
      if @cohort == 'interesting'
        @agent = new Intervention.InterestingAgent
      else
        if @cohort != 'control'
          # TODO log unknown/unset cohort
          console.log 'unknown or unset cohort'
        @agent = new Intervention.ControlAgent
      if @cohort == "interesting"
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

  @ensureCohortIsKnown = =>
    self = @
    eventualCohort = new $.Deferred
    Experiments.getCohort()
    .then (cohort) =>
      if cohort?
        self.cohort = cohort
      else
        # TODO log problem with cohort
        self.cohort = 'control'
    .fail =>
      # TODO log problem with cohort
      self.cohort = 'control'
    .always =>
      eventualCohort.resolve self.cohort
    eventualCohort.promise()

  # since we don't get hold of a random subject's ID until time of GETting it, we use a placeholder to represent that random subject.
  @PLACEHOLDER = "(random-ID)"

  constructor: ->
    @source = "Random"

    debugger

    @ensureCohortIsKnown()
      .then (
        console.log 'then'
        @initializeAgent()
      )
    super


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
    console.log 'updated arrays:'
    console.log history
    subjectID

  @nextForControlCohort: (callback) =>
    @current.destroy() if @current?
    numberOfSubjectsAlreadyLoaded = @count()

    # Prepare one "current" and fill the rest of the queue.
    numberOfSubjectsToFetch = (@queueLength - numberOfSubjectsAlreadyLoaded) + 1
    fetcher = @loadMoreRandomSubjects numberOfSubjectsAlreadyLoaded, numberOfSubjectsToFetch
    @advance fetcher, callback

  @next: (callback) =>
    console.log 'nexting'
    debugger
    @.constructor.ensureCohortIsKnown()
    .then(
      if Experiments.ACTIVE_EXPERIMENT? && @cohort?
        if @cohort == "interesting"
          # pick one randomly across control & intervention subjects
          subjectID = @extractSubjectAtRandom
          console.log 'experimental pick:'
          console.log subjectID
          if subjectID?
            @current.destroy() if @current?
            if subjectID == @PLACEHOLDER
              fetcher = @fetch 1
            else
              @source = "Chosen due to interest"
              fetcher = @subjectFetch subjectID
            @advance fetcher, callback
          else
            # user has exhausted all their subjects in the experiment; fall back to control
            @nextForControlCohort callback
      else
        console.log 'falling back to control'
        console.log '(because cohort is:'
        console.log @cohort
        console.log ')'
        # TODO: log that failed to run experimental split for interesting user - fall back to control
        @nextForControlCohort callback
    )

  # after subjects have been loaded, this method actually selects the first (or triggers out of subjects event)
  @selectFirstNonEmptySubject: =>
    first = @first()
    first?.destroy() if first?.metadata.empty
    numberOfSubjectsAlreadyLoaded = @count()
    if numberOfSubjectsAlreadyLoaded is 0
      @trigger 'no-subjects'
    else
      @source = "Random"
      @first().select()

  # ensures that the next subject is selected, either now or once deferred chain is complete
  @advance: (deferred, callback) =>
    numberOfSubjectsAlreadyLoaded = @count()
    if numberOfSubjectsAlreadyLoaded is 0
      nexter = deferred.pipe =>
        @selectFirstNonEmptySubject()
    else
      nexter = new $.Deferred
      nexter.done =>
        @selectFirstNonEmptySubject()
      nexter.resolve()
    nexter.then callback
    nexter

  # retrieves more subjects, but does not do anything with them
  @loadMoreRandomSubjects: (numberOfSubjectsAlreadyLoaded, numberOfSubjectsToFetch) =>
    @fetch numberOfSubjectsToFetch unless numberOfSubjectsToFetch < 1

  # get random subjects from the API and instantiate them as models
  @fetch: (count) =>
    fetcher = new $.Deferred

    # Grab subjects randomly.
    getter = Api.get("/projects/serengeti/groups/subjects?limit=#{count}").deferred

    getter.done (rawSubjects) =>
      fetcher.resolve (@fromJSON rawSubject for rawSubject in rawSubjects)

    getter.fail =>
      fetcher.resolve []

    fetcher.promise() # Resolves with all fetched subjects

  # get a specific subject by ID from the API and instantiate it as a model
  @subjectFetch: (subjectID) =>
    subjectFetcher = new $.Deferred

    getter = Api.get("/projects/serengeti/subjects/#{subjectID}").deferred

    getter.done (rawSubject) =>
      subjectFetcher.resolve (@fromJSON rawSubject)

    getter.fail ->
      subjectFetcher.resolve null

    subjectFetcher.promise()

  # instantiate model from raw JSON API response
  @fromJSON: (raw) =>
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

  select: ->
    @constructor.current = @
    @trigger 'select'

  satelliteImage: (width = 640, height = 480, zoom = 10, type = 'hybrid') ->
    # TODO: Fix lat/lng!
    coords = ['Serengeti', 'Tanzania']

    """
      //maps.googleapis.com/maps/api/staticmap
      ?center=#{coords.join ','}
      &zoom=#{zoom}
      &size=#{width}x#{height}
      &maptype=#{type}
      &markers=size:tiny|#{coords.join ','}
      &sensor=false
    """.replace '\n', '', 'g'

  talkHref: ->
    "http://talk.snapshotserengeti.org/#/subjects/#{@zooniverseId}"

  facebookHref: ->
    title = 'Snapshot Serengeti'
    summary = 'I just classified this image on Snapshot Serengeti!'
    image = $("<a href='#{@location.standard[0]}'></a>").get(0).href
    """
      https://www.facebook.com/sharer/sharer.php
      ?s=100
      &p[url]=#{encodeURIComponent @talkHref()}
      &p[title]=#{encodeURIComponent title}
      &p[summary]=#{encodeURIComponent summary}
      &p[images][0]=#{image}
    """.replace '\n', '', 'g'

  twitterHref: ->
    message = "Classifying animals in the Serengeti! #{@talkHref()} via @snapserengeti"
    "http://twitter.com/home?status=#{encodeURIComponent message}"

  pinterestHref: ->
    image = $("<a href='#{@location.standard[0]}'></a>").get(0).href
    summary = 'I just classified this image on Snapshot Serengeti!'
    """
      http://pinterest.com/pin/create/button/
      ?url=#{encodeURIComponent @talkHref()}
      &media=#{encodeURIComponent image}
      &description=#{encodeURIComponent summary}
    """.replace '\n', '', 'g'

module.exports = Subject
