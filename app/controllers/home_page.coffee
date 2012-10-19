{Controller} = require 'spine'
template = require 'views/home_page'
modulus = require 'lib/modulus'

class HomePage extends Controller
  className: 'home-page'

  elements:
    '.recents figure': 'recents'

  activeRecent: -1

  constructor: ->
    super
    @html template

  activate: ->
    super
    @rotate();
    # @autoRotate()

  autoRotate: =>
    @rotate()
    setTimeout @autoRotate, 2000 if @el.is ':visible'

  rotate: ->
    @activeRecent = modulus @activeRecent + 1, @recents.length
    @recents.removeClass 'active'
    @recents.eq(@activeRecent).addClass 'active'

module.exports = HomePage
