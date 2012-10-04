{Module, Events} = require 'spine'

class FilteringSet
  Module.extend.call @, Events
  Module.include.call @, Events

  items: null
  options: null

  constructor: (params = {}) ->
    @[property] = value for own property, value of params
    @items ?= []
    @options ?= {}

    @filter @options

  find: (params) ->
    for item in @items
      mismatch = false
      for feature, value of params
        if value instanceof RegExp and typeof item[feature] is 'string'
          # If given a regex option value, check it against a string.
          mismatch = true unless value.test item[feature]
        else if item[feature] instanceof Array
          # If matching an array, see if the option value is present.
          mismatch = true unless value in item[feature]
        else
          # Otherwise, just test equality.
          mismatch = true unless item[feature] is value

      continue if mismatch
      item

  filter: (options = {}, hard = true) ->
    # "Hard" will replace all filtering options.
    # "Soft" will modify the current options.
    if hard
      @options = options
    else
      @options[property] = value for own property, value of options

    console.log 'Filtering by', @options

    # Clear out empty options.
    for feature, value of @options
      delete @options[feature] unless value?

    @trigger 'filter', @find @options

  search: (searchString) ->
    searchExpression = new RegExp searchString, 'i'

    matches = for item in @items
      match = false
      for feature, value of item when feature of item.attributes()
        match = true if searchExpression.test value

      continue unless match
      item

    @trigger 'search', matches

module.exports = FilteringSet
