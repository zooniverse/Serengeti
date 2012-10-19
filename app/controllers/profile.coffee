{Controller} = require 'spine'
template = require 'views/profile'

class Profile extends Controller
  className: 'profile'

  events:
    'click button[name="turn-page"]': 'onClickPageButton'

  elements:
    'nav button': 'navButtons'
    '.page': 'pages'
    '.favorites ul': 'favoritesList'
    '.recents ul': 'recentsList'

  constructor: ->
    super

    @html template
    @navButtons.first().click()

  onClickPageButton: ({currentTarget}) ->
    @navButtons.add(@pages).removeClass 'active'

    value = $(currentTarget).val()
    page = @pages.filter ".#{value}"
    button = @navButtons.filter "[value='#{value}']"

    button.add(page).addClass 'active'

module.exports = Profile
