Subject = require 'models/subject'
User = require 'Zooniverse/lib/models/user'
Api = require 'Zooniverse/lib/api'
Geordi = require 'lib/geordi_and_experiments_setup'
ExperimentServer = Geordi.experimentServerClient

# An Experimental Subject is a specialized subject for use in experiments.
class ExperimentalSubject extends Subject
  @configure "ExperimentalSubject", 'zooniverseId', 'workflowId', 'location', 'coords', 'metadata'

  # override parent as we need additional info
  @fromJSON: (raw) =>
    if !ExperimentServer.sources[raw.zooniverse_id]?
      ExperimentServer.sources[raw.zooniverse_id]=ExperimentServer.SOURCE_NORMAL

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

  # same as parent, but this one logs experimental insertions as they are presented to the user, and marks them as seen
  @selectFirstNonEmptySubject: ->
    first = @first()
    first?.destroy() if first?.metadata.empty
    numberOfSubjectsAlreadyLoaded = @count()
    if numberOfSubjectsAlreadyLoaded is 0
      @trigger 'no-subjects'
    else
      subject = @first()
      Geordi.logEvent {
        type: 'view'
        subjectID: subject.zooniverseId
      }
      if ExperimentServer.ACTIVE_EXPERIMENT=="SerengetiInterestingAnimalsExperiment1"
        if ExperimentServer.currentCohort == ExperimentServer.COHORT_CONTROL
          Geordi.logEvent {
            type: 'control'
            relatedID: 'random'
            data: {
              source:'random'
            }
            userID: Geordi.UserGetter.currentUserID
            subjectID: subject.zooniverseId
          }
        else if ExperimentServer.currentCohort == ExperimentServer.COHORT_INSERTION
          if ExperimentServer.sources[subject.zooniverseId] == ExperimentServer.SOURCE_INSERTED
            Geordi.logEvent {
              type: 'insertion'
              relatedID: 'specific'
              data: {
                source:'specific'
              }
              userID: Geordi.UserGetter.currentUserID
              subjectID: subject.zooniverseId
            }
          else if ExperimentServer.sources[subject.zooniverseId] == ExperimentServer.SOURCE_RANDOM
            Geordi.logEvent {
              type: 'insertion'
              relatedID: 'random'
              data: {
                source:'random'
              }
              userID: Geordi.UserGetter.currentUserID
              subjectID: subject.zooniverseId
            }
        else
          Geordi.logEvent {
            type: 'non-experimental'
            relatedID: 'view'
            data: {
              nonExperimentalEventType:'view'
            }
            userID: Geordi.UserGetter.currentUserID
            subjectID: subject.zooniverseId
          }
        @markAsSeen subject.zooniverseId
      else if ExperimentServer.ACTIVE_EXPERIMENT=="SerengetiBlanksExperiment1"
        if ExperimentServer.currentCohort == ExperimentServer.COHORT_CONTROL
          Geordi.logEvent {
            type: 'control'
            relatedID: 'random'
            data: {
              source:'random'
            }
            userID: Geordi.UserGetter.currentUserID
            subjectID: subject.zooniverseId
          }
        else if ExperimentServer.currentCohort in [ExperimentServer.COHORT_0, ExperimentServer.COHORT_20, ExperimentServer.COHORT_40, ExperimentServer.COHORT_60, ExperimentServer.COHORT_80]
          if ExperimentServer.sources[subject.zooniverseId] == ExperimentServer.SOURCE_BLANK
            Geordi.logEvent {
              type: 'insertion'
              relatedID: 'blank'
              data: {
                source:'blank'
              }
              userID: Geordi.UserGetter.currentUserID
              subjectID: subject.zooniverseId
            }
          else if ExperimentServer.sources[subject.zooniverseId] == ExperimentServer.SOURCE_NON_BLANK
            Geordi.logEvent {
              type: 'insertion'
              relatedID: 'non-blank'
              data: {
                source:'non-blank'
              }
              userID: Geordi.UserGetter.currentUserID
              subjectID: subject.zooniverseId
            }
        else
          Geordi.logEvent {
            type: 'non-experimental'
            relatedID: 'view'
            data: {
              nonExperimentalEventType:'view'
            }
            userID: Geordi.UserGetter.currentUserID
            subjectID: subject.zooniverseId
          }
        @markAsSeen subject.zooniverseId
      subject.select()

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
          ExperimentServer.currentParticipant = response.participant
          nextSubjectIDs = response.nextSubjectIDs
          if nextSubjectIDs? && nextSubjectIDs.length == 0
            # end of experiment
            ExperimentServer.currentParticipant.active = false
          else
            for subjectIDAndBlankness in nextSubjectIDs
              [subjectID, blankness] = subjectIDAndBlankness.split(":")
              if blankness=="blank"
                source = ExperimentServer.SOURCE_BLANK
              else
                source = ExperimentServer.SOURCE_NON_BLANK
              do (subjectID) =>
                if subjectID == "RANDOM"
                  backgroundFetcher.then =>
                    @fetch(1)
                    .then (subject) =>
                      if subject?
                        ExperimentServer.sources[subject[0].zooniverseId]=ExperimentServer.SOURCE_RANDOM
                else
                  backgroundFetcher.then =>
                    @subjectFetch(subjectID)
                    .then (subject) =>
                      if subject?
                        ExperimentServer.sources[subjectID]=source
      .fail =>
        Geordi.logEvent {
          type: "error"
          errorCode: "500"
          errorDescription: "Couldn't load next experimental subjects"
        }
    else
      backgroundFetcher = new $.Deferred
      backgroundFetcher.resolve null
    backgroundFetcher.promise()

  # mark subject as seen in experiment server, and remove any "used" subjects from our queue.
  @markAsSeen: (subjectID) ->
    seenNotifier = new $.Deferred
    try
      if ExperimentServer.sources[subjectID]==ExperimentServer.SOURCE_INSERTED
        url = ExperimentServer.EXPERIMENT_SERVER_URL + 'experiment/' + ExperimentServer.ACTIVE_EXPERIMENT + '/participant/' + Geordi.UserGetter.currentUserID + '/insertion/' + subjectID
      else if ExperimentServer.sources[subjectID]==ExperimentServer.SOURCE_RANDOM
        url = ExperimentServer.EXPERIMENT_SERVER_URL + 'experiment/' + ExperimentServer.ACTIVE_EXPERIMENT + '/participant/' + Geordi.UserGetter.currentUserID + '/random'
      if ExperimentServer.sources[subjectID]==ExperimentServer.SOURCE_BLANK || ExperimentServer.sources[subjectID]==ExperimentServer.SOURCE_NON_BLANK
        url = ExperimentServer.EXPERIMENT_SERVER_URL + 'experiment/' + ExperimentServer.ACTIVE_EXPERIMENT + '/participant/' + Geordi.UserGetter.currentUserID + '/' + subjectID
      else if ExperimentServer.sources[subjectID]==ExperimentServer.SOURCE_RANDOM
        url = ExperimentServer.EXPERIMENT_SERVER_URL + 'experiment/' + ExperimentServer.ACTIVE_EXPERIMENT + '/participant/' + Geordi.UserGetter.currentUserID + '/random'
      else
        Geordi.logEvent {
          type: "error"
          errorCode: "409"
          errorDescription: "Couldn't POST subject "+subjectID+" to mark as seen"
        }
        return null
      $.post(url)
      .then (participant) =>
        ExperimentServer.currentParticipant = participant
        # ensure any previously seen subjects by this participant are removed from the queue if present.
        for queue in [ExperimentServer.currentParticipant.blank_subjects_seen,ExperimentServer.currentParticipant.non_blank_subjects_seen]
          for seenID in queue
            for queuedSubject of ExperimentalSubject.all
              if seenID==queuedSubject.zooniverseId
                ExperimentalSubject.where(zooniverseId: seenID).delete
        seenNotifier.resolve participant
      .fail =>
        Geordi.logEvent {
          type: "error"
          errorCode: "500"
          errorDescription: "Couldn't POST subject "+subjectID+" to mark as seen"
        }
        seenNotifier.resolve null
    catch error
      Geordi.logEvent {
        type: "error"
        errorCode: "409"
        errorDescription: "Couldn't POST subject "+subjectID+" to mark as seen"
      }
      seenNotifier.resolve null
    seenNotifier.promise()

  # get the next subject IDs for the specified user ID from the experiment server	(assumes "interesting" cohort)
  @getNextSubjectIDs: (numberOfSubjects) ->
    subjectIDsFetcher = new $.Deferred
    try
      $.get(ExperimentServer.EXPERIMENT_SERVER_URL + 'experiment/' + ExperimentServer.ACTIVE_EXPERIMENT + '/participant/' + Geordi.UserGetter.currentUserID + '/next/' + numberOfSubjects)
      .then (data) =>
        subjectIDsFetcher.resolve data
      .fail =>
        Geordi.logEvent {
          type: "error"
          errorCode: "500"
          errorDescription: "Couldn't retrieve next subjects"
        }
        subjectIDsFetcher.resolve null
    catch error
      Geordi.logEvent {
        type: "error"
        errorCode: "500"
        errorDescription: "Couldn't GET nextsubjects"
      }
      subjectIDsFetcher.resolve null
    subjectIDsFetcher.promise()

  # for experimental cohort users, determine next subjects accordingly
  @next: (callback) =>
    if ExperimentServer.ACTIVE_EXPERIMENT == "SerengetiBlanksExperiment1"
      @current.destroy() if @current?
      count = @count()

      # If empty, try to prepare one random "current" quickly
      if count == 0
        fetcher = @fetch 1

      # for experimental cohort, load up the right subjects
      ExperimentServer.getParticipant()
      .then (participant) =>
        if participant?
          ExperimentServer.currentParticipant = participant
          #ExperimentServer.currentCohort = participant.cohort
          toFetch = (@queueLength - @count()) + 1
          if ExperimentServer.currentParticipant.active && ExperimentServer.currentCohort != ExperimentServer.COHORT_CONTROL && ExperimentServer.currentCohort != ExperimentServer.COHORT_INELIGIBLE
            @loadMoreRandomSubjects toFetch
          else
            # Fill the rest of the queue in the background according to the experiment server's instructions
            @loadMoreExperimentalSubjects toFetch

      # background work kicked off if needed, now we can advance
      if fetcher is null
        fakeFetcher = new $.Deferred
        fetcher = fakeFetcher
      @advance fetcher, callback
      if fakeFetcher?
        fakeFetcher.resolve()
    else
      # InterestingAnimals experiment not running - revert to parent
      super callback

module.exports = ExperimentalSubject
