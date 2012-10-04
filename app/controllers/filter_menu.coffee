{Controller} = require 'spine'
template = require 'views/filter_menu'

class FilterMenu extends Controller
  set: null
  characteristic: null

  className: 'filter-menu'

  events:
    'click button[name="characteristic"]': 'onToggleClick'
    'click button[name="clear-characteristic"]': 'onClearClick'
    'click button[name="characteristic-value"]': 'onValueClick'

  elements:
    'button[name="characteristic"]': 'toggleButton'
    '.menu': 'menu'
    'button[name="characteristic-value"]': 'valueButtons'

  constructor: ->
    super

    @set.bind 'filter', @onSetFilter

    @html template @
    @close()

    $(document).on 'click', @onDocumentClick

  onToggleClick: ->
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
    if @el.hasClass 'open' then @close() else @open()

  onValueClick: ({currentTarget}) ->
    id = $(currentTarget).val()
    result = {}
    result[@characteristic.id] = id
    @set.filter result, false
    @close()

  onClearClick: ->
    result = {}
    result[@characteristic.id] = null
    @set.filter result, false
    @close()

  onSetFilter: =>
    @el.removeClass 'in-use'
    @toggleButton.html @characteristic.label
    @menu.children().removeClass 'selected'

    selectedValue = @set.options[@characteristic.id]

    if selectedValue?
      value = (value for value in @characteristic.values when value.id is selectedValue)[0]
      @el.addClass 'in-use'
      @toggleButton.html value.label
      @menu.children("[value='#{value.id}']").addClass 'selected'

  onDocumentClick: ({target}) =>
    @close() unless $(target).parents().andSelf().is @el

module.exports = FilterMenu
