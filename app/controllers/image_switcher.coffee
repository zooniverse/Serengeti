{Controller} = require 'spine'
template = require 'views/image_switcher'
$ = require 'jqueryify'

class ImageSwitcher extends Controller
  subject: null

  className: 'image-switcher'

  events:
    'click button[name="play"]': 'onClickPlay'
    'click button[name="toggle"]': 'onClickToggle'
    'click button[name="satellite"]': 'onClickSatellite'

  elements:
    '.images figure': 'images'
    '.toggles button, button[name="satellite"]': 'toggles'

  constructor: ->
    super
    @el.one 'load', => console.log 'Loaded'
    @setSubject @subject

  setSubject: (@subject) ->
    if @subject
      @html template @subject
      @activate Math.floor @subject.location.length / 2
      $()
    else
      @html ''

  onClickPlay: ->
    @play()

  play: ->
    # Flip the images back and forth a couple times.
    last = @subject.location.length - 1
    iterator = [0...last].concat [last...0]
    iterator = iterator.concat [0...last].concat [last...0]

    # End half way through.
    iterator = iterator.concat [0...Math.floor(@subject.location.length / 2) + 1]

    for index, i in iterator then do (index, i) =>
      setTimeout (=> @activate index), i * 333

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

  onClickSatellite: ->
    @activate @subject.location.length

module.exports = ImageSwitcher
