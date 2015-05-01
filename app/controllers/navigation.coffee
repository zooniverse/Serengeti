template = require '../views/navigation'

class Navigation
  constructor: ->
    @el = $('<div id="navigation"></nav>')
    @el.append template

    @nav = @el.find('nav')
    @navButton = @el.find('.nav-button')

    @navButton.on 'click', @toggleNav

    addEventListener('hashchange', @onHashchange, false)
    @onHashchange()

  onHashchange: (e) =>
    @el.find("a[href='#{location.hash}']")
      .parent().addClass('active')
      .siblings().removeClass('active')
    @closeNav() if window.innerWidth <= 1000 # responsive nav breakpoint

  toggleNav: =>
    @navButton.toggleClass('open')
    @nav.slideToggle('fast')

  closeNav: =>
    @navButton.removeClass('open')
    @nav.slideUp('fast')


module.exports = Navigation
