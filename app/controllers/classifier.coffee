{Controller} = require 'spine'
ImageSwitcher = require './image_switcher'
AnimalSelector = require './animal_selector'
animals = require 'lib/animals'
characteristics = require 'lib/characteristics'
AnimalMenuItem = require './animal_menu_item'

class Classifier extends Controller
  subject: null

  className: 'classifier'

  constructor: ->
    super

    @imageSwitcher = new ImageSwitcher

    @el.append @imageSwitcher.el

    @animalSelector = new AnimalSelector
      set: animals
      characteristics: characteristics
      itemController: AnimalMenuItem

    @el.append @animalSelector.el

  onSubjectSet: (subject) ->
    @imageSwitcher.setSubject subject

module.exports = Classifier
