template = require 'views/navigation'

class Navigation
  constructor: ->
    @el = $('<div id="navigation"></nav>')
    @el.append template

    @nav = @el.find('nav')
    @navButton = @el.find('.nav-button')

    @navButton.on 'click', @onNavButtonClick

    addEventListener('hashchange', @onHashchange, false)
    @onHashchange()

  onHashchange: (e) =>
    @el.find("a[href='#{location.hash}']")
      .parent().addClass('active')
      .siblings().removeClass('active')

    @nav.slideUp('fast')
    @navButton.removeClass('open')

  onNavButtonClick: (e) =>
    @navButton.toggleClass('open')
    @nav.slideToggle('fast')

module.exports = Navigation
