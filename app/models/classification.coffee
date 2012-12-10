{Model} = require 'spine'
$ = require 'jqueryify'
Api = require 'zooniverse/lib/api'
Favorite = require 'zooniverse/lib/models/favorite'
Recent = require 'zooniverse/lib/models/recent'

class Classification extends Model
  @configure 'Classification', 'subject', 'annotations', 'metadata', 'favorite'

  @sentThisSession: 0

  constructor: ->
    super
    @annotations ||= []
    @metadata ||= {}

    @metadata.agent ||= window.navigator.userAgent
    @metadata.started ||= (new Date).toUTCString()

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
      @save()
      @trigger 'deannotate', toDelete
      return toDelete

  toJSON: ->
    metaAnnotations = for key, value of @metadata
      annotation = {}
      annotation[key] = value
      annotation

    classification:
      subject_ids: [@subject.id]
      annotations: @annotations.concat metaAnnotations
      favorite: @favorite

  url: ->
    "/projects/serengeti/workflows/#{@subject.workflowId}/classifications"

  send: ->
    unless @subject.metadata.tutorial or @subject.metadata.empty
      @constructor.sentThisSession += 1

    @trigger 'send'
    Api.post @url(), @toJSON(), arguments...

    recent = Recent.create subjects: @subject
    recent.trigger 'send'
    recent.trigger 'is-new'

    if @favorite
      favorite = Favorite.create subjects: @subject
      favorite.trigger 'send'
      favorite.trigger 'is-new'

module.exports = Classification
