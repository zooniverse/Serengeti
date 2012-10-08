{Controller} = require 'spine'
template = require 'views/animal_selector'
FilterMenu = require './filter_menu'
AnimalDetails = require './animal_details'

class AnimalSelector extends Controller
  set: null
  characteristics: null

  className: 'animal-selector'

  events:
    'keydown input[name="search"]': 'onSearchKeyDown'
    'click [data-animal]': 'onAnimalItemClick'
    'keydown [data-animal]': 'onAnimalItemKeyDown'

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
    for characteristic in @characteristics
      new FilterMenu
        el: @el.find ".#{characteristic.id}.filter-menu"
        set: @set
        characteristic: characteristic

  setClassification: (@classification) ->
    @classification.bind 'add-species', @clearFilters

  ESC = 27
  onSearchKeyDown: ({which}) ->
    setTimeout =>
      @searchInput.attr value: '' if which is ESC
      @set.search @searchInput.val()

  onSetFilter: (matches, options) =>
    @classification?.annotate filters: options, true

    matchIds = (match.id for match in matches)
    for item in @items
      item = $(item)
      item.toggleClass 'hidden', item.attr('data-animal') not in matchIds

    breakpoints = [20, 10, 5, 0]
    breakpoint = point for point in breakpoints when matches.length <= point
    @itemsContainer.attr 'data-items': breakpoint ? 'gt20'

  onSetSearch: (matches, searchString) =>
    @classification?.annotate search: searchString, true

    matchIds = (match.id for match in matches)
    for item in @items
      item = $(item)
      item.toggleClass 'dimmed', item.attr('data-animal') not in matchIds

  onAnimalItemClick: ({currentTarget}) ->
    animalId = $(currentTarget).attr 'data-animal'
    animal = @set.find(id: animalId)[0]
    @select animal

  ENTER = 13
  onAnimalItemKeyDown: ({which, currentTarget}) ->
    if which is ENTER
      animalId = $(currentTarget).attr 'data-animal'
      animal = @set.find(id: animalId)[0]
      @select animal

  select: (animal) ->
    details = new AnimalDetails {animal, @classification}
    @itemsContainer.append details.el
    setTimeout details.show, 125

  clearFilters: =>
    @set.filter {}, true
    @searchInput.val ''
    @searchInput.trigger 'keydown'

module.exports = AnimalSelector
