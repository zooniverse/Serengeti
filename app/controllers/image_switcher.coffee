{Controller} = require 'spine'
template = require 'views/image_switcher'
AnnotationItem = require './annotation_item'
$ = require 'jqueryify'

modulus = (a, b) -> ((a % b) + b) % b

class ImageSwitcher extends Controller
  classification: null
  active: NaN

  className: 'image-switcher'

  playTimeouts: null

  events:
    'click button[name="play"]': 'onClickPlay'
    'click button[name="pause"]': 'onClickPause'
    'click button[name="toggle"]': 'onClickToggle'
    'click button[name="satellite"]': 'onClickSatellite'
    'click button[name="sign-in"]': 'onClickSignIn'
    'click button[name="favorite"]': 'onClickFavorite'
    'click button[name="unfavorite"]': 'onClickUnfavorite'

  elements:
    '.subject-images figure': 'images'
    'figure.satellite': 'satelliteImage'
    '.annotations': 'annotationsContainer'
    '.toggles button': 'toggles'
    'button[name="satellite"]': 'satelliteToggle'

  constructor: ->
    super
    @playTimeouts = []
    @el.attr tabindex: 0
    @setClassification @classification

  delegateEvents: ->
    super
    $(document).on 'keydown', @onKeyDown

  setClassification: (classification) ->
    @classification?.unbind 'change', @onClassificationChange
    @classification?.unbind 'add-species', @onClassificationAddSpecies
    @classification = classification

    if @classification
      @classification.bind 'change', @onClassificationChange
      @classification.bind 'add-species', @onClassificationAddSpecies

      @html template @classification

      @active = Math.floor @classification.subject.location.length / 2
      @activate @active
    else
      @html ''

  keys =
    SPACE: 32
    LEFT: 37
    RIGHT: 39
    F: 70
    M: 77
    0: 48
    9: 57

  keys.values = (value for key, value of keys)

  onKeyDown: (e) =>
    return unless @el.is ':visible'
    return if $(e.target).is 'a, button, input, textarea, select'

    isNumber = keys[0] <= e.which <= keys[9]
    return unless e.which in keys.values or isNumber

    e.preventDefault()
    switch e.which
      when keys.SPACE then @play()
      when keys.LEFT then @activate @active - 1
      when keys.RIGHT then @activate @active + 1
      when keys.F then @el.find('button[name$="favorite"]:visible').click()
      when keys.M then @satelliteToggle.click()
      else @activate e.which - 49

  onClassificationChange: =>
    @el.toggleClass 'favorite', !!@classification.favorite

  onClassificationAddSpecies: (classification, annotation) =>
    item = new AnnotationItem {@classification, annotation}
    item.el.appendTo @annotationsContainer
    console.log 'Added species', annotation

  onClickPlay: ->
    @play()

  onClickPause: ->
    @pause()

  onClickToggle: ({currentTarget}) =>
    selectedIndex = $(currentTarget).val()
    @activate selectedIndex

  onClickSatellite: ->
    @satelliteImage.add(@satelliteToggle).toggleClass 'active'

  onClickSignIn: ->
    console.log 'Clicked sign-in'

  onClickFavorite: ->
    @classification.updateAttribute 'favorite', true

  onClickUnfavorite: ->
    @classification.updateAttribute 'favorite', false

  play: ->
    # Flip the images back and forth a couple times.
    last = @classification.subject.location.length - 1
    iterator = [0...last].concat [last...0]
    iterator = iterator.concat [0...last].concat [last...0]

    # End half way through.
    iterator = iterator.concat [0...Math.floor(@classification.subject.location.length / 2) + 1]

    @el.addClass 'playing'

    for index, i in iterator then do (index, i) =>
      @playTimeouts.push setTimeout (=> @activate index), i * 333

    @playTimeouts.push setTimeout @pause, i * 333

  pause: =>
    clearTimeout timeout for timeout in @playTimeouts
    @playTimeouts.splice 0
    @el.removeClass 'playing'

  activate: (@active) ->
    @satelliteImage.add(@satelliteToggle).removeClass 'active'

    @active = modulus +@active, @classification.subject.location.length

    for image, i in @images
      @setActiveClasses image, i, @active

    for button, i in @toggles
      @setActiveClasses button, i, @active

  setActiveClasses: (el, elIndex, activeIndex) ->
    el = $(el)
    el.toggleClass 'before', +elIndex < +activeIndex
    el.toggleClass 'active', +elIndex is +activeIndex
    el.toggleClass 'after', +elIndex > +activeIndex

module.exports = ImageSwitcher
