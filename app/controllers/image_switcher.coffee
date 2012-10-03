{Controller} = require 'spine'
template = require 'views/image_switcher'
$ = require 'jqueryify'

class ImageSwitcher extends Controller
  subject: null

  events:
    'click button[name="toggle"]': 'onClickToggle'

  elements:
    '.images > *': 'images'
    '.toggles > *': 'toggles'

  constructor: ->
    super
    @setSubject @subject

  setSubject: (@subject) ->
    if @subject
      @html template @subject
      @activate Math.floor @subject.location.length / 2
    else
      @html ''

  onClickToggle: ({currentTarget}) =>
    selectedIndex = $(currentTarget).val()
    @activate selectedIndex

  activate: (activeIndex) ->
    for image, i in @images
      @setActiveClasses image, i, activeIndex

    for button, i in @toggles
      @setActiveClasses button, i, activeIndex

  setActiveClasses: (el, elIndex, activeIndex) ->
    el = $(el)
    el.toggleClass 'before', +elIndex < +activeIndex
    el.toggleClass 'active', +elIndex is +activeIndex
    el.toggleClass 'after', +elIndex > +activeIndex

module.exports = ImageSwitcher
