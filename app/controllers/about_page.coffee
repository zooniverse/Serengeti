{Controller} = require 'spine'
template = require 'views/about_page'

class AboutPage extends Controller
  className: 'about-page content-page'

  events:
    'click nav button[name="turn-page"]': 'onClickNavButton'

  elements:
    'nav button[name="turn-page"]': 'navButtons'

  constructor: ->
    super
    @html template

    @navButtons.first().next().next().click()

  onClickNavButton: ({currentTarget}) ->
    button = $(currentTarget)
    page = @el.find "[data-page='#{button.val()}']"

    page.add(page.siblings('[data-page]')).add(button).add(button.siblings('[name="turn-page"]')).removeClass 'before active after'

    page.prevAll('[data-page]').add(button.prevAll('[name="turn-page"]')).addClass 'before'
    page.add(button).addClass 'active'
    page.nextAll('[data-page]').add(button.nextAll('[name="turn-page"]')).addClass 'after'

module.exports = AboutPage
