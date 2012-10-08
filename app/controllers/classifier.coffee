{Controller} = require 'spine'
ImageSwitcher = require './image_switcher'
AnimalSelector = require './animal_selector'
animals = require 'lib/animals'
characteristics = require 'lib/characteristics'
AnimalMenuItem = require './animal_menu_item'
Subject = require 'models/subject'
Classification = require 'models/classification'

class Classifier extends Controller
  subject: null

  className: 'classifier'

  classification: null

  constructor: ->
    super

    @imageSwitcher = new ImageSwitcher

    @el.append @imageSwitcher.el

    @animalSelector = new AnimalSelector
      set: animals
      characteristics: characteristics
      itemController: AnimalMenuItem

    @el.append @animalSelector.el

    Subject.bind 'select', @onSubjectSelect

  onSubjectSelect: (@subject) =>
    @classification = new Classification {@subject}
    @imageSwitcher.setSubject @subject
    @animalSelector.setClassification @classification

module.exports = Classifier
