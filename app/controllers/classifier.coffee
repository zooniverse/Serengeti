{Controller} = require 'spine'
animals = require 'lib/animals'
template = require 'views/classifier'
FilteringCombobox = require './filtering_combobox'
AnimalMenuItem = require './animal_menu_item'
characteristics = require 'lib/characteristics'
Filterer = require './filterer'
CharacteristicMenuItem = require './characteristic_menu_item'

class Classifier extends Controller
  className: 'classifier'

  elements:
    '.filtering-combobox': 'filteringComboboxNode'
    '.filterers': 'filterersNode'

  constructor: ->
    super

    @html template

    @filteringCombobox = new FilteringCombobox
      el: @filteringComboboxNode
      set: animals
      itemTemplate: AnimalMenuItem.getInstanceEl

    @filteringCombobox.bind 'select', @onSelect

    for characteristic in characteristics
      filterer = new Filterer
        set: animals
        characteristic: characteristic
        valueTemplate: CharacteristicMenuItem.getInstanceEl

      @filterersNode.append filterer.el

  onSelect: (animal) =>
    console.log 'Selected', animal

module.exports = Classifier
