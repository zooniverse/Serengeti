{Controller} = require 'spine'
template = require 'views/annotation_item'

class AnnotationItem extends Controller
  classification: null
  annotation: null

  className: 'annotation-item'

  constructor: ->
    super

    @html template @annotation

  events:
    'click button[name="delete"]': 'onClickDelete'

  onClickDelete: ->
    @classification.deannotate @annotation
    @release()

module.exports = AnnotationItem
