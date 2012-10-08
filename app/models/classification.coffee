{Model} = require 'spine'
$ = require 'jqueryify'

class Classification extends Model
  @configure 'Classification', 'subject', 'annotations', 'metadata'

  constructor: ->
    super
    @annotations ||= []
    @metadata ||= {}

    setTimeout =>
      @annotations.push agent: window.navigator.userAgent
      @annotations.push started: (new Date).toUTCString()

  annotate: (values, isMetadata = false) ->
    if isMetadata
      @metadata[key] = value for own key, value of values
      delete @metadata[key] unless value?
    else
      @annotations.push values

    @save()
    @trigger 'add-species', values if 'species' of values

  deannotate: (toDelete) ->
    for annotation, i in @annotations when annotation is toDelete
      @annotations.splice i, 1
      @trigger 'deannotate', toDelete
      return toDelete

  toJSON: ->
    metaAnnotations = for key, value of @metadata
      annotation = {}
      annotation.key = value
      annotation

    classification:
      subject_ids: [@subject.id]
      annotations: @annotations.concat metaAnnotations

  url: ->
    "/projects/serengeti/workflows/#{@subject.workflowId}/classifications"

  send: ->
    # Api.post @url(), @toJSON(), arguments...

module.exports = Classification
