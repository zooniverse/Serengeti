{Controller} = require 'spine'
template = require 'views/filterer'

class Filterer extends Controller
  set: null
  characteristic: null

  valueTemplate: (value) -> "<div><button>#{value.label}</button></div>"

  className: 'filterer'

  events:
    'click button[name="characteristic"]': 'onClick'
    'click .menu button[name="clear"]': 'onClickClear'
    'click .menu [data-value]': 'onSelect'

  elements:
    'button[name="characteristic"] .label': 'characteristicLabel'
    '.menu': 'menu'

  constructor: ->
    super
    @values ?= []

    @html template @
    @close()
    for value in @characteristic.values
      valueNode = $(@valueTemplate value)
      valueNode.attr 'data-value': value.id
      @menu.append valueNode

    @characteristic.bind 'change', @onCharacteristicChange

    @set.bind 'filter', @onSetFilter

  onCharacteristicChange: =>
    @characteristicLabel.html @characteristic.label

  onClick: ->
    @toggle()

  open: ->
    @el.addClass 'open'
    @menu.removeClass 'hidden'

  close: ->
    @el.removeClass 'open'
    @menu.addClass 'hidden'

  toggle: ->
    @el.toggleClass 'open'
    @menu.toggleClass 'hidden'

  onClickClear: ->
    result = {}
    result[@characteristic.id] = null
    @set.filter result, false

  onSelect: ({currentTarget}) ->
    id = $(currentTarget).attr 'data-value'
    result = {}
    result[@characteristic.id] = id
    @set.filter result, false
    @close()

  onSetFilter: =>
    @menu.children().removeClass 'selected'

    selectedValue = @set.options[@characteristic.id]
    return unless selectedValue?

    @menu.children("[data-value='#{selectedValue}']").addClass 'selected'

module.exports = Filterer
