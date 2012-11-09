attach = require 'zootorial/lib/attach'
$ = require 'jqueryify'

log = -> console?.log? arguments...

class PopupButton
  @fromDOM: (el) ->
    el = $(el)
    popup = el.parents().last().find el.attr 'data-popup'

    position = el.attr('data-popup-position') || ''
    [attachAt, attachTo, attachMargin] = position.split /\s*\,\s*/g
    attachAt ?= @::attachAt
    attachTo ?= @::attachTo
    attachMargin ?= @::attachMargin

    new @ {el, popup, attachAt, attachTo, attachMargin}

  el: null
  popup: null

  attachAt: 'center bottom'
  attachTo: 'center top'
  attachMargin: 0

  classDelay: 0

  constructor: (params = {}) ->
    @[key] = value for own key, value of params when key of @
    log params

    @el.on 'click', @onClick

    @popup.addClass 'hidden'
    @popup.remove()

    $(document).on 'click', @onDocumentClick

  onClick: (e) =>
    @toggle()

  onDocumentClick: ({target}) =>
    @close() unless $(target).parents().andSelf().is @el

  toggle: ->
    if @el.hasClass 'open' then @close() else @open()

  open: ->
    @el.addClass 'open'
    @popup.appendTo 'body'
    attach @popup, @attachAt.split(/\s/), @el, @attachTo.split(/\s/), margin: @attachMargin
    setTimeout $.proxy(@popup, 'removeClass', 'hidden'), @classDelay

  close: ->
    @el.removeClass 'open'
    @popup.addClass 'hidden'
    setTimeout $.proxy(@popup, 'remove'), @classDelay

module.exports = PopupButton
