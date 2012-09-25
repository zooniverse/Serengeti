{Controller} = require 'spine'
animals = require 'lib/animals'
template = require 'views/classifier'
FilteringCombobox = require './filtering_combobox'

class Classifier extends Controller
  elements:
    '.filtering-combobox': 'filteringComboboxNode'

  constructor: ->
    super

    @html template

    @filteringCombobox = new FilteringCombobox
      el: @filteringComboboxNode
      set: animals

module.exports = Classifier
