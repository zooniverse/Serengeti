{Controller} = require 'spine'
template = require 'views/filter_menu'
$ = require 'jqueryify'
translate = require 't7e'
Subject = require 'models/subject'
Geordi = require 'lib/geordi_and_experiments_setup'

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

  onToggleClick: ->
    @toggle()

  open: ->
    @el.addClass 'open'
    @menu.removeClass 'hidden'
    @trigger 'open'

    $(document).on 'click', @onDocumentClick

  close: ->
    @el.removeClass 'open'
    @menu.addClass 'hidden'
    @trigger 'close'

    $(document).off 'click', @onDocumentClick

  toggle: ->
    if @el.hasClass 'open' then @close() else @open()

  onValueClick: ({currentTarget}) ->
    id = $(currentTarget).val()
    result = {}
    result[@characteristic.id] = id
    subtype = id
    Geordi.logEvent {
      type: 'filter'
      relatedID: id
      data: {
        filterType: id
      }
      subjectID: Subject.current?.zooniverseId
    }
    @set.filter result, false
    @close()

  onClearClick: ->
    subtype = 'clear' + @characteristic.id.charAt(0).toUpperCase() + @characteristic.id.slice(1)
    Geordi.logEvent {
      type: 'clear'
      relatedID: subtype
      data: {
        clearType: subtype
      }
      subjectID: Subject.current?.zooniverseId
    }
    result = {}
    result[@characteristic.id] = null
    @set.filter result, false
    @close()

  onSetFilter: =>
    @el.removeClass 'in-use'
    @toggleButton.html translate 'span', "characteristics.#{@characteristic.id}"
    @menu.children().removeClass 'selected'

    selectedValue = @set.options[@characteristic.id]

    if selectedValue?
      value = (value for value in @characteristic.values when value.id is selectedValue)[0]
      @el.addClass 'in-use'
      @toggleButton.html translate 'span', "characteristicValues.#{value.id}"
      @menu.children("[value='#{value.id}']").addClass 'selected'

  onDocumentClick: ({target}) =>
    @close() unless $(target).parents().andSelf().is @el

module.exports = FilterMenu
