{Controller} = require 'spine'
template = require 'views/filtering_select'

class FilteringSelect extends Controller
  set: null
  itemTemplate: (item) -> "<span>#{item.name}</span>"

  className: 'filtering-select'

  events:
    'keyup input': 'onKeyUpInput'

  elements:
    'input': 'input'
    '.possible-values': 'possibleValues'
    '.filtering-select-menu': 'menu'

  constructor: ->
    super
    throw new Error 'FilteringSelect needs a FilteringSet' unless @set?

    @html template @

    @set.bind 'filter', @onSetFilter

  onSetFilter: (matches) =>
    @el.toggleClass 'no-matches', matches.length is 0

    @possibleValues.html matches.length

    matchIds = (match.id for match in matches)
    for itemNode in @menu.children()
      itemNode = $(itemNode)
      itemNode.toggleClass 'hidden', itemNode.attr('data-item') not in matchIds

  onKeyUpInput: (e) ->
    @set.filter name: new RegExp @input.val(), 'i'

module.exports = FilteringSelect
