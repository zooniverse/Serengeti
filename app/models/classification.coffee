{Model} = require 'spine'
$ = require 'jqueryify'

class Classification extends Model
  @configure 'Classification', 'subject', 'annotations'

  constructor: ->
    super
    @annotations ||= []

    setTimeout =>
      @annotations.push agent: window.navigator.userAgent
      @annotations.push started: (new Date).toUTCString()

  annotate: (values) ->
    @annotations.push values
    @save()

  toJSON: ->
    classification:
      subject_ids: [@subject.id]
      annotations: @annotations

  url: ->
    "/projects/serengeti/workflows/#{@subject.workflowId}/classifications"

  send: ->
    # Api.post @url(), @toJSON(), arguments...

module.exports = Classification
