attach = require 'zootorial/lib/attach'
$ = require 'jqueryify'

log = -> console?.log? arguments...

class PopupButton
  @fromDOM: (el) ->
    el = $(el)
    popup = el.parents().last().find el.attr 'data-popup'
    log {el, popup}
    position = el.attr 'data-popup-position'
    [attachAt, attachTo] = position?.split /\s*\,\s*/
    attachAt ?= @::attachAt
    attachTo ?= @::attachTo
    new @ {el, popup, attachAt, attachTo}

  el: null
  popup: null
  attachAt: 'center bottom'
  attachTo: 'center top'
  attachMargin: 0
  classDelay: 0

  constructor: (params = {}) ->
    @[key] = value for own key, value of params when key of @

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
