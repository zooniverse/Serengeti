{Controller} = require 'spine'
animals = require 'lib/animals'
template = require 'views/classifier'
FilteringSelect = require './filtering_select'
AnimalMenuItem = require './animal_menu_item'
characteristics = require 'lib/characteristics'
Filterer = require './filterer'
CharacteristicMenuItem = require './characteristic_menu_item'

class Classifier extends Controller
  className: 'classifier'

  elements:
    '.filtering-select': 'filteringSelectNode'

  constructor: ->
    super

    @html template

    @filteringSelect = new FilteringSelect
      el: @filteringSelectNode
      set: animals
      characteristics: characteristics
      itemController: AnimalMenuItem

    @filteringSelect.bind 'select', @onSelect

  onSelect: (animal) =>
    console.log 'Selected', animal

module.exports = Classifier
