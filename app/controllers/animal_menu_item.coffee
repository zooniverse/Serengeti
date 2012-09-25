{Controller} = require 'spine'
template = require 'views/animal_menu_item'

class AnimalMenuItem extends Controller
  @getInstanceEl: (model) =>
    new @({model}).el

  model: null

  elements:
    '.name': 'nameNode'

  constructor: ->
    super

    @html template @

    @model.bind 'change', @onModelChange

  onModelChange: =>
    @nameNode.html @model.name

module.exports = AnimalMenuItem
