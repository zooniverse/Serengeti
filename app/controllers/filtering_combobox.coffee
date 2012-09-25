{Controller} = require 'spine'
template = require 'views/filtering_select'

class FilteringSelect extends Controller
  set: null
  itemTemplate: (item) -> "<span>#{item.id}</span>"

  className: 'filtering-select'

  elements:
    '.filtering-select-menu': 'menu'

  constructor: ->
    super
    throw new Error 'FilteringSelect needs a FilteringSet' unless @set?

    @el.html template @

module.exports = FilteringSelect
