require 'lib/setup'
Navigation = require 'controllers/navigation'
$ = require 'jqueryify'
{Stack} = require 'spine/lib/manager'
Route = require 'spine/lib/route'
AboutPage = require 'controllers/about_page'
AuthorsPage = require 'controllers/authors_page'
HomePage = require 'controllers/home_page'
Classifier = require 'controllers/classifier'
Profile = require 'controllers/profile'
# Explore = require 'controllers/explore'
DataPage = require 'controllers/data_page'
Api = require 'zooniverse/lib/api'
seasons = require 'lib/seasons'
TopBar = require 'zooniverse/lib/controllers/top_bar'
User = require 'zooniverse/lib/models/user'
ExperimentalSubject = require 'models/experimental_subject'
Geordi = require 'lib/geordi_and_experiments_setup'
ExperimentServer = Geordi.experimentServerClient
googleAnalytics = require 'zooniverse/lib/google_analytics'
# Map = require 'zooniverse/lib/map'

ContentPage = require 'controllers/content_page'
feedbackContent = require 'views/feedback_page'

# Map::tilesId = 53589
# Map::apiKey = '21a5504123984624a5e1a856fc00e238'

navigation = new Navigation
navigation.el.appendTo document.body

LanguagePicker = require 'controllers/language_picker'
languagePicker = new LanguagePicker
languagePicker.el.prependTo document.body

googleAnalytics.init
  account: 'UA-1224199-36'
  domain: 'snapshotserengeti.org'

app = {}

User.bind 'sign-in', ->
  $('html').toggleClass 'signed-in', User.current?
  if User.current?
    Geordi.logEvent 'login'
  else
    ExperimentServer.resetExperimentalFlags()
    Geordi.logEvent 'logout'

[host, proxyPath] = if location.origin is 'http://preview.zooniverse.org'
  ['https://dev.zooniverse.org', '/proxy']
else if +location.port < 1024
  [window.location.origin, '/_ouroboros_api/proxy']
else
  ['https://dev.zooniverse.org', '/proxy']

Api.init {host, proxyPath}

# TODO: Don't count on the proxy frame to have no loaded yet.

Api.proxy.el().one 'load', ->
  Api.get '/projects/serengeti', (project) ->
    sortedSeasons = for season, {_id: id, total, complete} of project.seasons
      total ?= 0
      complete ?= 0
      name = if season is '0' then 'Lost Season' else "Season #{ season }"
      {season, id, name, total, complete}

    sortedSeasons.sort (a, b) ->
      # Lost Season is effectively season 8.5, in ordering
      if a.season is '0'
        8.5 - b.season
      else if b.season is '0'
        a.season - 8.5
      else
        a.season - b.season

    seasons.push sortedSeasons...

    User.count = project.user_count

    $('.before-load').remove()
    app.stack = new Stack
      className: "main #{Stack::className}"

      controllers:
        home: HomePage
        about: AboutPage
        classify: Classifier
        profile: Profile
        authors: AuthorsPage
        # explore: Explore
        data: DataPage

      routes:
        '/home': 'home'
        '/about': 'about'
        '/classify': 'classify'
        '/profile': 'profile',
        '/authors': 'authors'
        # '/explore': 'explore'
        '/data': 'data'

      default: 'home'

    # Load the top bar last since it fetches the user.
    app.topBar = new TopBar
      app: 'serengeti'
      appName: 'Snapshot Serengeti'

    $(window).on 'request-login-dialog', ->
      app.topBar.onClickSignUp()
      app.topBar.loginForm.signInButton.click()
      app.topBar.loginDialog.reattach()

    $(window).bind('beforeunload', (e) ->
        Geordi.logEvent 'leave'
        event.preventDefault()
    )

    app.stack.el.appendTo 'body'
    app.topBar.el.prependTo 'body'

    Route.setup()

    TranslationEditor = require 't7e/editor'
    TranslationEditor.init() if !!~location.search.indexOf 'translate=1'

module.exports = app
