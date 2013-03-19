template = require 'views/navigation'

class Navigation
  constructor: ->
    @el = $('<nav></nav>')
    @el. append template

module.exports = Navigation
