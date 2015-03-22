User = require 'zooniverse/lib/models/user'
Experiments = require 'lib/experiments'
$ = require('jqueryify')

class InterventionAgent
  constructor: (userID, experiment, cohort, data) ->
    @userID = userID
    @experiment = experiment
    @cohort = cohort
    @data = data
    @connection = null

  # abstract method to be implemented by children
  saveInterventionHistory: ->
    return

  getUserProfile: (scoreType) ->
    if scoreType == "interestInSpecies"
      Experiments.SPECIES_INTEREST_PROFILES[@userID]
    else
      []

  updateInterventionHistory: (history) =>
    Experiments.interventionHistories[@userID] = {
      'active': history.active
      'control_subjects_viewed': history.control_subjects_viewed
      'control_subjects_available': history.control_subjects_available
      'intervention_subjects_viewed': history.intervention_subjects_viewed
      'intervention_subjects_available': history.intervention_subjects_available
    }

  createInterventionHistory: =>
    Experiments.interventionHistories[@userID] = {
      'active': true
      'control_subjects_viewed': []
      'control_subjects_available': []
      'intervention_subjects_viewed': []
      'intervention_subjects_available': []
    }

  getInterventionHistory: =>
    history = Experiments.interventionHistories[@userID]
    if not history?
      @createInterventionHistory()
      history = @getInterventionHistory()
    history

class ControlAgent extends InterventionAgent
  constructor: ->
    @userID = User.current?.zooniverse_id
    @experiment = Experiments.ACTIVE_EXPERIMENT
    @cohort = 'control'
    @data = null

class InterestingAgent extends InterventionAgent
  constructor: ->
    @userID = User.current?.zooniverse_id
    @experiment = Experiments.ACTIVE_EXPERIMENT
    @cohort = 'interesting'
    profile = @getUserProfile "interestInSpecies"
    interventionHistory = @getInterventionHistory()
    @data = {
      profile: profile
      interventionHistory: interventionHistory
    }

  getMostInterestingSpecies: (n) ->
    @data.profile.slice(0, n)

  addInterventionSubjectsFor: (species) ->
    if species not in Experiments.EXCLUDED_SPECIES
      @data.interventionHistory.intervention_subjects_available.push Experiments.SPECIES_SUBJECTS[species]
    else
      # TODO log the fact we skipped a species for this user.

  saveInterventionHistory: (history) ->
    updateInterventionHistory(history)

exports.agents = {
  'control': new ControlAgent()
  'interesting': new InterestingAgent()
}

exports.InterventionAgent = InterventionAgent
exports.ControlAgent = ControlAgent
exports.InterestingAgent = InterestingAgent