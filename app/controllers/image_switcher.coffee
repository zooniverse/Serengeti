{Controller} = require 'spine'
template = require 'views/image_switcher'
$ = require 'jqueryify'

class ImageSwitcher extends Controller
  subject: null

  events:
    'click button[name="toggle"]': onClickToggle

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
    for img, i in @el.find 'img'
      @setActiveClasses img, i, activeIndex

    for button, i in @el.find 'button[name="toggle"]'
      @setActiveClasses button, i, activeIndex

  setActiveClasses: (el, elIndex, activeIndex) ->
    el = $(el)
    el.toggleClass 'before', i < activeIndex
    el.toggleClass 'active', i is activeIndex
    el.toggleClass 'after', i > activeIndex

module.exports = ImageSwitcher
