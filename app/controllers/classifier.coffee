{Controller} = require 'spine'
$ = require 'jqueryify'
SubjectViewer = require './subject_viewer'
AnimalSelector = require './animal_selector'
animals = require 'lib/animals'
characteristics = require 'lib/characteristics'
AnimalMenuItem = require './animal_menu_item'
Subject = require 'models/subject'
User = require 'zooniverse/lib/models/user'
{Tutorial} = require 'zootorial'
tutorialSteps = require 'lib/tutorial_steps'
getTutorialSubject = require 'lib/get_tutorial_subject'
getEmptySubject = require 'lib/get_empty_subject'
Classification = require 'models/classification'

class Classifier extends Controller
  subject: null

  className: 'classifier'

  tutorial: null

  subject: null
  classification: null

  constructor: ->
    super

    @subjectViewer = new SubjectViewer

    @el.append @subjectViewer.el

    @animalSelector = new AnimalSelector
      set: animals
      characteristics: characteristics
      itemController: AnimalMenuItem

    @el.append @animalSelector.el

    @tutorial = new Tutorial
      steps: tutorialSteps

    Subject.bind 'select', @onSubjectSelect
    Subject.bind 'no-local-subjects', @onNoSubjects
    User.bind 'sign-in', @onUserSignIn

    $(window).on 'hashchange', =>
      setTimeout @afterHashChange

    @onUserSignIn()

  onSubjectSelect: (@subject) =>
    @afterHashChange()

    for property in ['tutorial', 'empty']
      @el.toggleClass property, !!@subject.metadata[property]

    @classification = new Classification {@subject}
    @subjectViewer.setClassification @classification
    @animalSelector.setClassification @classification

    if !!@subject.metadata.tutorial
      @tutorial.start()

  onNoSubjects: =>
    getEmptySubject().select()

  onUserSignIn: =>
    tutorialDone = User.current?.project.tutorial_done
    doingTutorial = Subject.current?.metadata.tutorial

    if tutorialDone
      @tutorial.end()
      Subject.next() if doingTutorial or not Subject.current
    else
      getTutorialSubject().select()
      @afterHashChange()

  afterHashChange: =>
    return unless !!@subject.metadata.tutorial

    if @el.is ':visible'
      # @tutorial.show()
    else
      # @tutorial.hide()

module.exports = Classifier
