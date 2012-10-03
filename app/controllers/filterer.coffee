{Controller} = require 'spine'
template = require 'views/filterer'

class Filterer extends Controller
  set: null
  characteristic: null

  valueController: null

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
      controller = new @valueController model: value
      controller.el.attr 'data-value': value.id
      @menu.append controller.el

    @characteristic.bind 'change', @onCharacteristicChange

    @set.bind 'filter', @onSetFilter

    $(document).on 'click', @onDocumentClick

  onCharacteristicChange: =>
    @characteristicLabel.html @characteristic.label

  onClick: ->
    @toggle()

  open: ->
    @el.addClass 'open'
    @menu.removeClass 'hidden'
    @trigger 'open'

  close: ->
    @el.removeClass 'open'
    @menu.addClass 'hidden'
    @trigger 'close'

  toggle: ->
    if @el.hasClass 'open'
      @close()
    else
      @open()

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

  onDocumentClick: ({target}) =>
    @close() unless (@el.has(target).length > 0) or @el.is target

module.exports = Filterer
