{Model} = require 'spine'
$ = require 'jqueryify'
Api = require 'zooniverse/lib/api'
Favorite = require 'zooniverse/lib/models/favorite'
Recent = require 'zooniverse/lib/models/recent'

class Classification extends Model
  @configure 'Classification', 'subject', 'annotations', 'metadata', 'favorite'

  constructor: ->
    super
    @annotations ||= []
    @metadata ||= {}

    if @annotations.length < 2 then setTimeout =>
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
      favorite: @favorite

  url: ->
    "/projects/serengeti/workflows/#{@subject.workflowId}/classifications"

  send: ->
    @trigger 'send'
    Api.post(@url(), @toJSON(), arguments...).deferred

    recent = Recent.create subjects: @subject
    favorite = Favorite.create subjects: @subject if @favorite

    favoriteSend = favorite.send().deferred
    favoriteSend.done ->
      favorite.trigger 'send'
      favorite.trigger 'is-new'

module.exports = Classification
