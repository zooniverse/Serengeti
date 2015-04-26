Subject = require('models/subject')
User = require 'zooniverse/lib/models/user'
Experiments = require 'lib/experiments'
Api = require 'zooniverse/lib/api'
AnalyticsLogger = require 'lib/analytics'

# An Experimental Subject is the combination of Subject & experimental Participant
class ExperimentalSubject extends Subject
  @configure "ExperimentalSubject", 'zooniverseId', 'workflowId', 'location', 'coords', 'metadata', 'participant'

  # override parent as we need additional info
  @fromJSON: (raw) =>
    if !Experiments.sources[raw.zooniverse_id]?
      Experiments.sources[raw.zooniverse_id]="RandomFill"

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

  # get a specific subject by ID from the API and instantiate it as a model
  @subjectFetch: (subjectID) =>
    subjectFetcher = new $.Deferred

    getter = Api.get("/projects/serengeti/subjects/#{subjectID}").deferred

    getter.done (rawSubject) =>
      subjectFetcher.resolve (@fromJSON rawSubject)

    getter.fail =>
      # resort to a random image
      @fetch(1).done (rawSubject) =>
        rawSubject.missing = true
        subjectFetcher.resolve (@fromJSON rawSubject)

    subjectFetcher.promise()

  # instantiates more subjects, at random but does not do anything with them
  @loadMoreRandomSubjects: (numberOfSubjectsToFetch) =>
    @fetch numberOfSubjectsToFetch unless numberOfSubjectsToFetch < 1

  # instantiates more subjects, according to experiment, but doesn't do anything with them
  @loadMoreExperimentalSubjects: (numberOfSubjectsToFetch) =>
    if numberOfSubjectsToFetch >= 1
      backgroundFetcher = @getNextSubjectIDs numberOfSubjectsToFetch
      backgroundFetcher
      .then (response) =>
        if response?
          Experiments.currentParticipant = response.participant
          nextSubjectIDs = response.nextSubjectIDs
          if nextSubjectIDs? && nextSubjectIDs.length == 0
            # TODO add some fallback code here (end of experiment)
          else
            for subjectID in nextSubjectIDs
              do (subjectID) =>
                if subjectID == "RANDOM"
                  backgroundFetcher.then =>
                    @fetch(1)
                    .then (subject) =>
                      if subject?
                        Experiments.sources[subject[0].zooniverseId]="RandomFromSet"
                else
                  backgroundFetcher.then =>
                    @subjectFetch(subjectID)
                    .then (subject) =>
                      if subject?
                        Experiments.sources[subjectID]="InsertFromSet"
      .fail =>
        AnalyticsLogger.logError "500", "Couldn't load next experimental subjects", "error"
    else
      backgroundFetcher = new $.Deferred
      backgroundFetcher.resolve null
    backgroundFetcher.promise()

  # get the next subject IDs for the specified user ID from the experiment server	(assumes "interesting" cohort)
  @getNextSubjectIDs: (numberOfSubjects) ->
    userID = User.current?.zooniverse_id
    subjectIDsFetcher = new $.Deferred
    try
      $.get(Experiments.EXPERIMENT_SERVER_URL + 'experiment/' + Experiments.ACTIVE_EXPERIMENT + '/participant/' + userID + '/next/' + numberOfSubjects)
      .then (data) =>
        subjectIDsFetcher.resolve data
      .fail =>
        AnalyticsLogger.logError "500", "Couldn't retrieve next subjects", "error"
        subjectIDsFetcher.resolve null
    catch error
      AnalyticsLogger.logError "500", "Couldn't GET next subjects", "error"
      subjectIDsFetcher.resolve null
    subjectIDsFetcher.promise()

  # for interesting cohort users, we will show a selection of known interesting and random unknown subjects.
  @next: (callback) =>
    if Experiments.ACTIVE_EXPERIMENT?
      if Experiments.ACTIVE_EXPERIMENT == "SerengetiInterestingAnimalsExperiment1"
        @current.destroy() if @current?
        count = @count()

        # If empty, try to prepare one random "current" quickly
        if count == 0
          fetcher = @fetch 1

        # for experimental cohort, load up the right subjects
        Experiments.getParticipant()
        .then (participant) =>
          if participant?
            Experiments.currentParticipant = participant
            Experiments.currentCohort = participant.cohort
            toFetch = (@queueLength - @count()) + 1
            if Experiments.currentParticipant.active && Experiments.currentCohort == Experiments.COHORT_INSERTION
              # Fill the rest of the queue in the background according to the experiment server's instructions
              @loadMoreExperimentalSubjects toFetch
            else
              @loadMoreRandomSubjects toFetch

        # background work kicked off if needed, now we can advance
        if fetcher is null
          fakeFetcher = new $.Deferred
          fetcher = fakeFetcher
        @current.destroy() if @current?
        @advance fetcher, callback
        if fakeFetcher?
          fakeFetcher.resolve()
      else
        # wrong experiment running - revert to parent
        super.next callback
    else
      # no experiment running - revert to parent
      super.next callback

module.exports = ExperimentalSubject
