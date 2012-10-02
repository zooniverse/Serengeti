{Controller} = require 'spine'
template = require 'views/animal_menu_item'

class AnimalMenuItem extends Controller
  @getInstanceEl: (model) =>
    new @({model}).el

  model: null

  elements:
    '.label': 'labelNode'

  constructor: ->
    super

    @html template @

    @model.bind 'change', @onModelChange

  onModelChange: =>
    @labelNode.html @model.label

module.exports = AnimalMenuItem
