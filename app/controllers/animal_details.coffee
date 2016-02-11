{Controller} = require 'spine'
template = require 'views/animal_details'
PopupButton = require './popup_button'
ImageChanger = require './image_changer'
ExperimentalSubject = require 'models/experimental_subject'
Geordi = require 'lib/geordi_and_experiments_setup'
ExperimentServer = Geordi.experimentServerClient

class AnimalDetails extends Controller
  animal: null
  classification: null
  set: null

  className: 'animal-details'

  events:
    'click button[name="change-image"]': 'onClickChangeImage'
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

    for popupButton in @el.find '[data-popup]'
      PopupButton.fromDOM popupButton

    @imageChanger = new ImageChanger
      el: @el.find '.image-changer'
      sources: @animal.images

    @onInputChange()

  show: =>
    @hadFocus = document.activeElement
    @el.removeClass 'hidden'
    @el.focus()

  hide: =>
    $(@hadFocus).focus()
    @el.addClass 'hidden'
    setTimeout @release, 333

  onClickChangeImage: ({currentTarget}) ->
    delta = parseFloat $(currentTarget).val()
    @imageChanger.activate @imageChanger.active + delta

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
    babies = !!@babiesCheckbox.attr 'checked'
    babies

  onClickCancel: ->
    @hide()

  onClickIdentify: ->
    Geordi.logEvent {
      type: 'identify'
      relatedID: @animal.id
      data: {
        species: @animal.id
        behavior: @getBehaviors()
        count: @getCount()
        babies: @getBabies()
        filters: @set.options
        search: @set.searchString
      }
      subjectID: ExperimentalSubject.current?.zooniverseId
    }
    @classification.annotate
      species: @animal

      count: @getCount()
      behavior: @getBehaviors()
      babies: @getBabies()

      filters: @set.options
      search: @set.searchString

    @hide()

module.exports = AnimalDetails
