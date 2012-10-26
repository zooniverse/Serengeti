{Controller} = require 'spine'
template = require 'views/animal_details'
ImageChanger = require './image_changer'

class AnimalDetails extends Controller
  animal: null
  classification: null
  set: null

  className: 'animal-details'

  events:
    'change select': 'onSelectChange'
    'click button[name="cancel"]': 'onClickCancel'
    'click button[name="identify"]': 'onClickIdentify'

  elements:
    'select[name="count"]': 'countSelect'
    'select[name="behavior"]': 'behaviorSelect'
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

    @onSelectChange()

  show: =>
    @el.removeClass 'hidden'

  hide: =>
    @el.addClass 'hidden'
    setTimeout @release, 333

  onSelectChange: ->
    setTimeout => @identifyButton.attr disabled: not (@countSelect.val() and @behaviorSelect.val())

  onClickCancel: ->
    @hide()

  onClickIdentify: ->
    @classification.annotate
      species: @animal

      count: @countSelect.val()
      behavior: @behaviorSelect.val()
      babies: !!@babiesCheckbox.attr 'checked'

      filters: @set.options
      search: @set.searchString

    @hide()

module.exports = AnimalDetails
