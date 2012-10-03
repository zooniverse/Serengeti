{Controller} = require 'spine'
template = require 'views/filtering_select'
Filterer = require './filterer'
CharacteristicMenuItem = require './characteristic_menu_item'

class FilteringSelect extends Controller
  set: null
  characteristics: null
  itemController: null

  selection: null

  events:
    'click button[name="select"]': 'onClickButton'
    'keyup input': 'onKeyUpSearchInput'
    'click button[name="clear-filters"]': 'onClickClearFilters'
    'click [data-item]': 'onClickItem'

  elements:
    'button[name="select"] .label': 'label'
    '.filtering-select-menu': 'menu'
    'input[name="search"]': 'searchInput'
    '.filtering-select-menu .match .filterers': 'filterersContainer'
    '.filtering-select-menu .items': 'itemsContainer'

  constructor: ->
    super
    throw new Error 'FilteringSelect needs a set' unless @set
    throw new Error 'FilteringSelect needs some characteristics' unless @characteristics

    @html template @
    @close()
    @appendItems()
    @appendFilterers()

    setTimeout @onSetFilter
    @set.bind 'filter', @onSetFilter

  appendItems: ->
    for item in @set.items
      controller = new @itemController model: item
      itemNode = controller.el
      itemNode.attr 'data-item': item.id
      @itemsContainer.append itemNode

  appendFilterers: ->
    for characteristic in @characteristics
      filterer = new Filterer
        set: @set
        characteristic: characteristic
        valueController: CharacteristicMenuItem

      @filterersContainer.append filterer.el

  onSetFilter: =>
    @el.toggleClass 'no-matches', @set.matches.length is 0

    # @possibleValues.html @set.matches.length

    matchIds = (match.id for match in @set.matches)
    for itemNode in @itemsContainer.children '[data-item]'
      itemNode = $(itemNode)
      itemId = itemNode.attr 'data-item'
      itemNode.toggleClass 'hidden',  itemId not in matchIds

  onClickButton: ->
    @toggle()

  onKeyUpSearchInput: (e) ->
    inputValue = @searchInput.val()
    @set.filter label: new RegExp(inputValue, 'i'), false

  onClickClearFilters: ->
    @set.filter {}, true

  onClickItem: ({currentTarget}) ->
    itemId = $(currentTarget).attr 'data-item'
    item = @set.find(id: itemId)[0]
    @select item
    @close()

  select: (item) ->
    @label.html ''
    @itemsContainer.children('.selected').removeClass 'selected'

    if item
      @label.html item.label
      @itemsContainer.children("[data-item='#{item.id}']").addClass 'selected'

    @trigger 'select', item

  open: ->
    @el.addClass 'open'
    @menu.removeClass 'hidden'

  close: ->
    @el.removeClass 'open'
    @menu.addClass 'hidden'

  toggle: ->
    @el.toggleClass 'open'
    @menu.toggleClass 'hidden'

module.exports = FilteringSelect
