{Controller} = require 'spine'
animals = require 'lib/animals'
template = require 'views/classifier'
ImageSwitcher = require './image_switcher'
FilteringSelect = require './filtering_select'
AnimalMenuItem = require './animal_menu_item'
characteristics = require 'lib/characteristics'
Filterer = require './filterer'
CharacteristicMenuItem = require './characteristic_menu_item'
Classification = require 'models/classification'

class Classifier extends Controller
  subject: null

  className: 'classifier'

  elements:
    '.image-switcher': 'imageSwitcherNode'
    '.filtering-select': 'filteringSelectNode'

  constructor: ->
    super

    @html template

    @imageSwitcher = new ImageSwitcher
      el: @imageSwitcherNode

    @filteringSelect = new FilteringSelect
      el: @filteringSelectNode
      set: animals
      characteristics: characteristics
      itemController: AnimalMenuItem

    @filteringSelect.bind 'select', @onSelect

  nextSubjects: =>
    # Subject.next @onChangeSubjects

  onSubjectSet: (@subject) =>
    @imageSwitcher.setSubject @subject
    @classification = new Classification {@subject}

  onSelect: (animal) =>
    console.log 'Selected', animal

module.exports = Classifier
