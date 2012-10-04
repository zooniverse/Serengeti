{Controller} = require 'spine'
template = require 'views/animal_selector'
FilterMenu = require './filter_menu'
characteristics = require 'lib/characteristics'

class AnimalSelector extends Controller
  set: null
  characteristics: null
  itemController: null

  className: 'animal-selector'

  events:
    'keydown input[name="search"]': 'onSearchKeyDown'
    'click [data-animal]': 'onClickAnimalItem'
    'click button[name="clear-filters"]': 'onClearFiltersClick'

  elements:
    'input[name="search"]': 'searchInput'
    '.items': 'itemsContainer'
    '[data-animal]': 'items'

  constructor: ->
    super
    throw new Error 'AnimalSelector needs a set' unless @set
    throw new Error 'AnimalSelector needs some characteristics' unless @characteristics

    @set.bind 'filter', @onSetFilter
    @set.bind 'search', @onSetSearch

    @html template @
    @createFilterMenus()

    @onSetFilter @set.items
    @onSetSearch @set.items

  createFilterMenus: ->
    for characteristic in characteristics
      new FilterMenu
        el: @el.find(".#{characteristic.id}.filter-menu")
        set: @set
        characteristic: characteristic

  onSearchKeyDown: ->
    setTimeout => @set.search @searchInput.val()

  onSetFilter: (matches) =>
    matchIds = (match.id for match in matches)
    for item in @items
      item = $(item)
      item.toggleClass 'hidden', item.attr('data-animal') not in matchIds

    @itemsContainer.attr 'data-items': if matches.length is 0
      0
    else if matches.length <= 10
      10
    else if matches.length <= 20
      20
    else
      'gt20'

  onSetSearch: (matches) =>
    matchIds = (match.id for match in matches)
    for item in @items
      item = $(item)
      item.toggleClass 'dimmed', item.attr('data-animal') not in matchIds

  onClickAnimalItem: ({currentTarget}) ->
    console.log 'Selected', $(currentTarget).attr 'data-animal'

  onClearFiltersClick: ->
    @set.filter {}, true

module.exports = AnimalSelector
