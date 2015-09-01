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
AnalyticsLogger = require 'lib/analytics'
googleAnalytics = require 'zooniverse/lib/google_analytics'
Experiments = require 'lib/experiments'
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
    AnalyticsLogger.logEvent 'login'
  else
    Experiments.resetExperimentalFlags()
    AnalyticsLogger.logEvent 'logout'

Api.init
  host: if !!location.href.match /demo|beta/
    'https://olddev.zooniverse.org'
  else if +location.port < 1024
    'https://api.zooniverse.org'
  else
    'https://olddev.zooniverse.org'
    #"#{location.protocol}//#{location.hostname}:3000"

# TODO: Don't count on the proxy frame to have no loaded yet.

Api.proxy.el().one 'load', ->
  Api.get '/projects/serengeti', (project) ->
    sortedSeasons = for season, {_id: id, total, complete} of project.seasons
      total ?= 0
      complete ?= 0
      {season, id, total, complete}

    sortedSeasons.sort (a, b) ->
      a.season > b.season

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
        AnalyticsLogger.logEvent 'leave'
        event.preventDefault()
    )

    app.stack.el.appendTo 'body'
    app.topBar.el.prependTo 'body'

    Route.setup()

    TranslationEditor = require 't7e/editor'
    TranslationEditor.init() if !!~location.search.indexOf 'translate=1'

module.exports = app
