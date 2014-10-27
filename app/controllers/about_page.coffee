{Controller} = require 'spine'
template = require 'views/about_page'
$ = require 'jqueryify'

class AboutPage extends Controller
  className: 'about-page content-page'
  template: template

  events:
    'click nav button[name="turn-page"]': 'onClickNavButton'

  elements:
    'nav button[name="turn-page"]': 'navButtons'

  constructor: ->
    super
    @html @template

    @navButtons.first().click()

    $(window).on 'hashchange', @onPageChange

  onClickNavButton: ({currentTarget}) ->
    button = $(currentTarget)
    page = @el.find "[data-page='#{button.val()}']"

    page.add(page.siblings('[data-page]')).add(button).add(button.siblings('[name="turn-page"]')).removeClass 'before active after'

    page.prevAll('[data-page]').add(button.prevAll('[name="turn-page"]')).addClass 'before'
    page.add(button).addClass 'active'
    page.nextAll('[data-page]').add(button.nextAll('[name="turn-page"]')).addClass 'after'

    @onPageChange()

  onPageChange: =>
    return unless @el.is ':visible'
    setTimeout =>
      visibleProtoimages = @el.find 'img[data-src]:visible'
      @processProtoimage img for img in visibleProtoimages

  processProtoimage: (img) ->
    img = $(img)
    img.attr src: img.attr 'data-src'
    img.removeAttr 'data-src'

module.exports = AboutPage
