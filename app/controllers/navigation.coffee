template = require 'views/navigation'

class Navigation
  constructor: ->
    @el = $('<nav></nav>')
    @el. append template

    addEventListener('hashchange', @onHashchange, false)
    @onHashchange()

  onHashchange: (e) =>
    @el.find("a[href='#{location.hash}']")
      .parent().addClass('active')
      .siblings().removeClass('active')

module.exports = Navigation


