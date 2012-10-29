{Controller} = require 'spine'
template = require 'views/animal_details'
ImageChanger = require './image_changer'

class AnimalDetails extends Controller
  animal: null
  classification: null
  set: null

  className: 'animal-details'

  events:
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
    @el.addClass 'hidden'

    @imageChanger = new ImageChanger
      el: @el.find '.image-changer'
      sources: @animal.images

    window.ic = @imageChanger

    @onInputChange()

  show: =>
    @el.removeClass 'hidden'

  hide: =>
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
