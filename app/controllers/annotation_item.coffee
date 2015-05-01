{Controller} = require 'spine'
template = require '../views/annotation_item'

class AnnotationItem extends Controller
  classification: null
  annotation: null

  className: 'annotation-item'

  events:
    'click button[name="delete"]': 'onClickDelete'

  constructor: ->
    super

    @html template @annotation
    @el.addClass 'new'

    setTimeout @unflash, 1000

  unflash: =>
    @el.removeClass 'new'

  onClickDelete: ->
    @classification.deannotate @annotation
    @release()

module.exports = AnnotationItem
