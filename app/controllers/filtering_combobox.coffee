{Controller} = require 'spine'
template = require 'views/filtering_combobox'

class FilteringCombobox extends Controller
  set: null
  itemTemplate: (item) -> "<span>#{item.name}</span>"

  className: 'filtering-combobox'

  events:
    'keyup input': 'onKeyUpInput'

  elements:
    'input': 'input'
    '.possible-values': 'possibleValues'
    '.filtering-combobox-menu': 'menu'

  constructor: ->
    super
    throw new Error 'FilteringCombobox needs a FilteringSet' unless @set?

    @html template @

    @onSetFilter()
    @set.bind 'filter', @onSetFilter

  onSetFilter: =>
    @el.toggleClass 'no-matches', @set.matches.length is 0

    @possibleValues.html @set.matches.length

    matchIds = (match.id for match in @set.matches)
    for itemNode in @menu.children()
      itemNode = $(itemNode)
      itemNode.toggleClass 'hidden', itemNode.attr('data-item') not in matchIds

  onKeyUpInput: (e) ->
    @set.filter name: new RegExp @input.val(), 'i'

module.exports = FilteringCombobox
