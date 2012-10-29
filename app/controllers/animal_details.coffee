{Controller} = require 'spine'
template = require 'views/animal_details'
ImageChanger = require './image_changer'

class AnimalDetails extends Controller
  animal: null
  classification: null
  set: null

  className: 'animal-details'

  events:
    'keydown': 'onKeyDown'
    'change input': 'onInputChange'
    'click button[name="cancel"]': 'onClickCancel'
    'click button[name="identify"]': 'onClickIdentify'

  elements:
    'input[name="count"]': 'countRadios'
    'input[name="behavior"]': 'behaviorCheckboxes'
    'input[name="babies"]': 'babiesCheckbox'
    'button[name="identify"]': 'identifyButton'

  constructor: ->
    super

    @html template @animal
    @el.attr tabindex: 0
    @el.addClass 'hidden'

    @imageChanger = new ImageChanger
      el: @el.find '.image-changer'
      sources: @animal.images

    @onInputChange()

  KEYS =
    ENTER: 13, ESC: 27
    0: 48, 1: 49, 2: 50, 3: 51, 4: 52, 5: 53, 6: 54, 7: 55, 8: 56, 9: 57
    '-': 173, '=': 61
    Q: 81, W: 87, E: 69, R: 82, T: 84, Y: 89, U: 85, I: 73, O: 79, P: 80

  onKeyDown: (e) ->
    {which} = e
    key = (key for key, val of KEYS when which is val)[0]
    return unless key
    e.preventDefault()
    @el.find("[data-shortcut='#{key}']").click()

  show: =>
    @hadFocus = document.activeElement
    @el.removeClass 'hidden'
    @el.focus()

  hide: =>
    $(@hadFocus).focus()
    @el.addClass 'hidden'
    setTimeout @release, 333

  onInputChange: ->
    setTimeout =>
      count = @getCount()
      behaviors = @getBehaviors()

      @identifyButton.attr disabled: (not count) or (behaviors.length is 0)

  getCount: ->
    @countRadios.filter(':checked').val()

  getBehaviors: ->
    for checkbox in @behaviorCheckboxes
      checkbox = $(checkbox)
      continue unless checkbox.attr 'checked'
      checkbox.val()

  getBabies: ->
    !!@babiesCheckbox.attr 'checked'

  onClickCancel: ->
    @hide()

  onClickIdentify: ->
    @classification.annotate
      species: @animal

      count: @getCount()
      behavior: @getBehaviors()
      babies: @getBabies()

      filters: @set.options
      search: @set.searchString

    @hide()

module.exports = AnimalDetails
