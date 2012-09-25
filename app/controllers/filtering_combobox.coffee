{Controller} = require 'spine'
template = require 'views/filtering_combobox'

class FilteringCombobox extends Controller
  set: null

  itemTemplate: (item) -> "<div>#{item.name || item.id}</div>"

  className: 'filtering-combobox'

  events:
    'keyup input': 'onKeyUpInput'
    'click button[name="clear-options"]': 'onClickClearOptions'

  elements:
    'input': 'input'
    '.possible-values': 'possibleValues'
    '.filtering-combobox-menu': 'menu'
    '.filtering-combobox-menu header .total': 'total'

  constructor: ->
    super
    throw new Error 'FilteringCombobox needs a FilteringSet' unless @set?

    @html template @
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

  onKeyUpInput: (e) ->
    @set.filter name: new RegExp(@input.val(), 'i'), false

  onClickClearOptions: ->
    @set.filter name: new RegExp @input.val(), 'i', true

module.exports = FilteringCombobox
