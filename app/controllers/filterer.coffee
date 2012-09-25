{Controller} = require 'spine'
template = require 'views/filterer'

class Filterer extends Controller
  set: null
  characteristic: null

  valueTemplate: (value) -> "<div><button>#{value.label}</button></div>"

  events:
    'click button[name="characteristic"]': 'onClick'
    'click .filterer-menu button[name="clear"]': 'onClickClear'
    'click .filterer-menu [data-value]': 'onSelect'

  elements:
    'button[name="characteristic"] .label': 'characteristicLabel'
    '.filterer-menu': 'menu'

  constructor: ->
    super
    @values ?= []

    @html template @
    for value in @characteristic.values
      valueNode = $(@valueTemplate value)
      valueNode.attr 'data-value': value.id
      @menu.append valueNode

    @characteristic.bind 'change', @onCharacteristicChange

    @set.bind 'filter', @onSetFilter

  onCharacteristicChange: =>
    @characteristicLabel.html @characteristic.label

  onClick: ->

  onClickClear: ->
    result = {}
    result[@characteristic.id] = null
    @set.filter result, false

  onSelect: ({currentTarget}) ->
    id = $(currentTarget).attr 'data-value'
    result = {}
    result[@characteristic.id] = id
    @set.filter result, false

  onSetFilter: =>
    @menu.children().removeClass 'selected'

    selectedValue = @set.options[@characteristic.id]
    return unless selectedValue?

    @menu.children("[data-value='#{selectedValue}']").addClass 'selected'

module.exports = Filterer
