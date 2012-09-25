{Module, Events} = require 'spine'

class FilteringSet
  Module.extend.call @, Events
  Module.include.call @, Events

  items: null
  options: null
  matches: null

  constructor: (params = {}) ->
    @[property] = value for own property, value of params
    @items ?= []
    @options ?= {}

    @filter @options

  filter: (options = {}, hard = true) ->
    # "Hard" will replace all filtering options.
    # "Soft" will modify the current options.
    if hard
      @options = options
    else
      @options[property] = value for own property, value of options

    @matches = for item in @items
      mismatch = false
      for feature, value of @options
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

    @trigger 'filter', @matches

module.exports = FilteringSet
