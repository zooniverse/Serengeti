{Module, Events} = require 'spine'

class FilteringSet
  Module.extend.call @, Events
  Module.include.call @, Events

  items: null
  matches: null

  constructor: (params = {}) ->
    @[property] = value for own property, value of params
    @items ?= []

    @filter()

  filter: (given = {}) ->
    @matches = for item in @items
      mismatch = false
      for feature, value of given
        if value instanceof RegExp and typeof item[feature] is 'string'
          mismatch = true unless value.test item[feature]
        else if item[feature] instanceof Array
          mismatch = true unless value in item[feature]
        else
          mismatch = true unless item[feature] is value
      continue if mismatch
      item

    @trigger 'filter', @matches

module.exports = FilteringSet
