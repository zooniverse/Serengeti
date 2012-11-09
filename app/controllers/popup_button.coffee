attach = require 'zootorial/lib/attach'
$ = require 'jqueryify'

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

  eventId: NaN

  constructor: (params = {}) ->
    @[key] = value for own key, value of params when key of @
    @eventId = Math.random().toString(36)[2...]

    @el.on 'click', @onClick

    @popup.addClass 'hidden'
    @popup.remove()
    @popup.prepend '<button name="close">&times;</button>'

  onClick: =>
    @toggle()

  onClickClose: =>
    @close()

  onDocumentClick: ({target}) =>
    @close() unless $(target).parents().andSelf().is @el.add @popup

  toggle: ->
    if @el.hasClass 'open' then @close() else @open()

  open: ->
    @el.addClass 'open'
    @popup.appendTo 'body'
    attach @popup, @attachAt.split(/\s/), @el, @attachTo.split(/\s/), margin: @attachMargin
    setTimeout $.proxy(@popup, 'removeClass', 'hidden'), @classDelay

    @popup.on 'click', 'button[name="close"]', @onClickClose
    $(document).on "click.#{@eventId}", @onDocumentClick

  close: ->
    @el.removeClass 'open'
    @popup.addClass 'hidden'
    setTimeout $.proxy(@popup, 'remove'), @classDelay

    @popup.off 'click'
    $(document).off "click.#{@eventId}"

module.exports = PopupButton
