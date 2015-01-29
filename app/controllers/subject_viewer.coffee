{Controller} = require 'spine'
template = require 'views/subject_viewer'
AnnotationItem = require './annotation_item'
Subject = require 'models/subject'
User = require 'zooniverse/lib/models/user'
AnalyticsLogger = require 'lib/analytics'
$ = require 'jqueryify'
modulus = require 'lib/modulus'
splits = require 'lib/splits'

class SubjectViewer extends Controller
  classification: null
  active: NaN

  className: 'subject-viewer'

  playTimeouts: null

  events:
    # 'click button[name="zoom"]': 'onClickZoomToggle'
    # 'mousedown .subject-images': 'onMouseDownImage'
    'click button[name="play"]': 'onClickPlay'
    'click button[name="pause"]': 'onClickPause'
    'click button[name="toggle"]': 'onClickToggle'
    'click button[name="satellite"]': 'onClickSatellite'
    'click button[name="sign-in"]': 'onClickSignIn'
    'click button[name="favorite"]': 'onClickFavorite'
    'click button[name="unfavorite"]': 'onClickUnfavorite'
    'change input[name="fire"]': 'onChangeFireCheckbox'
    'click a[name="facebook"]': 'onClickFacebook'
    'click a[name="tweet"]': 'onClickTweet'
    'click a[name="pin"]': 'onClickPin'
    'click a[name="talk"]': 'onClickTalk'
    'change input[name="nothing"]': 'onChangeNothingCheckbox'
    'click button[name="finish"]': 'onClickFinish'
    'click button[name="next"]': 'onClickNext'

  elements:
    '.subject-images figure': 'figures'
    'figure.satellite': 'satelliteImage'
    '.annotations': 'annotationsContainer'
    '.extra-message': 'extraMessageContainer'
    '.toggles button': 'toggles'
    'button[name="satellite"]': 'satelliteToggle'
    'input[name="fire"]': 'fireCheckbox'
    'input[name="nothing"]': 'nothingCheckbox'
    'button[name="finish"]': 'finishButton'
    'a.talk-link': 'talkLink'

  constructor: ->
    super
    @playTimeouts = []
    @el.attr tabindex: 0
    @setClassification @classification

  # delegateEvents: ->
  #   super
  #   doc = $(document)
  #   doc.on 'mousemove', @onDocMouseMove
  #   doc.on 'mouseup', @onDocMouseUp

  setClassification: (classification) ->
    @el.removeClass 'finished'
    @classification?.unbind 'change', @onClassificationChange
    @classification?.unbind 'add-species', @onClassificationAddSpecies

    @classification = classification

    if @classification
      @classification.bind 'change', @onClassificationChange
      @classification.bind 'add-species', @onClassificationAddSpecies

      @html template @classification

      @active = Math.floor @classification.subject.location.standard.length / 2
      @activate @active

      @onClassificationChange()
    else
      @html ''

  onClassificationChange: =>
    noAnnotations = @classification.annotations.length is 0
    nothing = @classification.metadata.nothing
    isFavorite = !!@classification.favorite
    inSelection = @classification.metadata.inSelection

    @el.toggleClass 'no-annotations', noAnnotations
    @el.toggleClass 'favorite', isFavorite

    @finishButton.attr disabled: inSelection or (noAnnotations and not nothing)

  onClassificationAddSpecies: (classification, annotation) =>
    item = new AnnotationItem {@classification, annotation}
    item.el.appendTo @annotationsContainer

  # onClickZoomToggle: ->
  #   @el.toggleClass 'zoomed'

  # onMouseDownImage: (e) ->
  #   return unless @el.hasClass 'zoomed'
  #   e.preventDefault();
  #   @el.addClass 'dragging'
  #   @mouseDown = e
  #   @onDocMouseMove e

  # onDocMouseMove: (e) =>
  #   return unless @mouseDown
  #   @onDragImage e

  # onDragImage: (e) ->
  #   return unless @mouseDown
  #   # TODO: A lot of this can be cached somewhere. POC.
  #   e.preventDefault()

  #   figure = @figures.filter '.active'
  #   image = figure.find 'img'

  #   figureOffset = figure.offset()
  #   imageOffset =
  #     left: parseFloat image.css 'left'
  #     top: parseFloat image.css 'top'

  #   startX = (@mouseDown.pageX - figureOffset.left)
  #   startY = (@mouseDown.pageY - figureOffset.top)
  #   currentX = (e.pageX - figureOffset.left)
  #   currentY = (e.pageY - figureOffset.top)
  #   diffX = startX - currentX
  #   diffY = startY - currentY

  #   rawOffset =
  #     left: imageOffset.left - diffX
  #     top: imageOffset.top - diffY

  #   clampedOffset =
  #     left: Math.min Math.max(rawOffset.left, figure.outerWidth() - image.outerWidth()), 0
  #     top: Math.min Math.max(rawOffset.top, figure.outerHeight() - image.outerHeight()), 0

  #   @figures.find('img').css clampedOffset

  #   @mouseDown = e

  # onDocMouseUp: (e) =>
  #   return unless @mouseDown
  #   @el.removeClass 'dragging'
  #   delete @mouseDown

  onClickPlay: ->
    @play()

  onClickPause: ->
    @pause()

  onClickToggle: ({currentTarget}) =>
    selectedIndex = $(currentTarget).val()
    @activate selectedIndex

  onClickSatellite: ->
    if not @satelliteImage.hasClass 'active'
      AnalyticsLogger.logEvent 'map', null, null, @classification.subject.zooniverseId
    @satelliteImage.add(@satelliteToggle).toggleClass 'active'

  onClickSignIn: ->
    $(window).trigger 'request-login-dialog'

  onClickFacebook: ->
    AnalyticsLogger.logEvent 'facebook', @classification.id, null, @classification.subject.zooniverseId

  onClickTweet: ->
    AnalyticsLogger.logEvent 'tweet', @classification.id, null, @classification.subject.zooniverseId

  onClickPin: ->
    AnalyticsLogger.logEvent 'pin', @classification.id, null, @classification.subject.zooniverseId

  onClickTalk: ->
    AnalyticsLogger.logEvent 'talk', @classification.id, null, @classification.subject.zooniverseId

  onClickFavorite: ->
    AnalyticsLogger.logEvent 'favorite', @classification.id, null, @classification.subject.zooniverseId
    @classification.updateAttribute 'favorite', true

  onClickUnfavorite: ->
    AnalyticsLogger.logEvent 'unfavorite', @classification.id, null, @classification.subject.zooniverseId
    @classification.updateAttribute 'favorite', false

  onChangeFireCheckbox: ->
    fire = !!@fireCheckbox.attr 'checked'
    @classification.annotate {fire}, true

  onChangeNothingCheckbox: ->
    nothing = !!@nothingCheckbox.attr 'checked'
    @classification.annotate {nothing}, true

  onClickFinish: ->
    message = splits.get 'classifier_messaging' unless @classification.subject.metadata.tutorial
    @extraMessageContainer.html message
    @extraMessageContainer.hide() unless message

    @el.addClass 'finished'
    AnalyticsLogger.logEvent 'classify', @classification.id, null, @classification.subject.zooniverseId
    @classification.send() unless @classification.subject.metadata.empty

  onClickNext: ->
    Subject.next()

  play: ->
    # Flip the images back and forth a couple times.
    last = @classification.subject.location.standard.length - 1
    iterator = [0...last].concat [last...0]
    iterator = iterator.concat [0...last].concat [last...0]

    # End half way through.
    iterator = iterator.concat [0...Math.floor(@classification.subject.location.standard.length / 2) + 1]

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

    @active = modulus +@active, @classification.subject.location.standard.length

    for image, i in @figures
      @setActiveClasses image, i, @active

    for button, i in @toggles
      @setActiveClasses button, i, @active

  setActiveClasses: (el, elIndex, activeIndex) ->
    el = $(el)
    el.toggleClass 'before', +elIndex < +activeIndex
    el.toggleClass 'active', +elIndex is +activeIndex
    el.toggleClass 'after', +elIndex > +activeIndex

module.exports = SubjectViewer
