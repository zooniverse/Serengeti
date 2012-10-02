{Controller} = require 'spine'
template = require 'views/filtering_combobox'

class FilteringCombobox extends Controller
  set: null
  itemTemplate: (item) -> "<span>#{item.label}</span>"

  className: 'filtering-combobox'

  events:
    'keyup input': 'onKeyUpInput'
    'click button[name="toggle"]': 'onClickToggle'
    'click .menu > [data-item]': 'onClickItem'
    'click button[name="clear-options"]': 'onClickClearOptions'

  elements:
    'input': 'input'
    '.possible-values': 'possibleValues'
    '.menu': 'menu'
    '.menu header .total': 'total'

  constructor: ->
    super
    throw new Error 'FilteringCombobox needs a FilteringSet' unless @set?

    @html template @
    @close()
    for item in @set.items
      itemNode = $(@itemTemplate item)
      itemNode.attr 'data-item': item.id
      @menu.append itemNode

    setTimeout @onSetFilter
    @set.bind 'filter', @onSetFilter

  onSetFilter: =>
    @el.toggleClass 'no-matches', @set.matches.length is 0

    @possibleValues.html @set.matches.length

    matchIds = (match.id for match in @set.matches)
    for itemNode in @menu.children('[data-item]')
      itemNode = $(itemNode)
      itemNode.toggleClass 'hidden', itemNode.attr('data-item') not in matchIds

  DELETE = 8
  ENTER = 13

  onKeyUpInput: (e) ->
    inputValue = @input.val()
    @set.filter label: new RegExp(inputValue, 'i'), false

    prefixMatch = @set.find(label: new RegExp("^#{inputValue}.*", 'i'))[0]
    if prefixMatch
      changed = inputValue isnt prefixMatch?.label

      if e.which is ENTER
        @select prefixMatch
      else if changed and e.which isnt DELETE
        @input.val prefixMatch.label
        @input.get(0).setSelectionRange inputValue.length, 999

  onClickItem: ({currentTarget}) =>
    itemId = $(currentTarget).attr 'data-item'
    item = @set.find(id: itemId)[0]
    @select item
    @close()

  select: (item) ->
    @input.val item.label
    @trigger 'select', item

  onClickClearOptions: ->
    @set.filter label: new RegExp @input.val(), 'i', true

  onClickToggle: ->
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

module.exports = FilteringCombobox
