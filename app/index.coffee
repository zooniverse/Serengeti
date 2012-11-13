require 'lib/setup'

$ = require 'jqueryify'
{Stack} = require 'spine/lib/manager'
Route = require 'spine/lib/route'
AboutPage = require 'controllers/about_page'
HomePage = require 'controllers/home_page'
Classifier = require 'controllers/classifier'
Profile = require 'controllers/profile'
translate = require 'lib/translate'
Api = require 'zooniverse/lib/api'
TopBar = require 'zooniverse/lib/controllers/top_bar'
User = require 'zooniverse/lib/models/user'
googleAnalytics = require 'zooniverse/lib/google_analytics'

ContentPage = require 'controllers/content_page'
feedbackContent = require 'views/feedback_page'

# Temporarily disable Talk links
$(document).on 'click', 'a[href*="talk"]', (e) ->
  e.preventDefault(); alert 'Talk is currently unavailable. Sorry!'

app = {}

User.bind 'sign-in', ->
  $('html').toggleClass 'signed-in', User.current?

Api.init
  host: if !!~location.href.match /demo|beta/
    'https://dev.zooniverse.org'
  else if +location.port < 1024
    'https://api.zooniverse.org'
  else
    "#{location.protocol}//#{location.hostname}:3000"

googleAnalytics.init
  account: 'UA-1224199-36'
  domain: 'snapshotserengeti.org'

language = localStorage.language
translate.init language, ->
  $('.before-load').remove()

  app.topBar = new TopBar
    app: 'serengeti'
    appName: 'Serengeti'

  $(window).on 'request-login-dialog', ->
    app.topBar.onClickSignUp()
    app.topBar.loginForm.signInButton.click()
    app.topBar.loginDialog.reattach()

  app.stack = new Stack
    className: "main #{Stack::className}"

    controllers:
      home: class extends HomePage then totalSubjects: 1227
      about: AboutPage
      classify: Classifier
      profile: Profile
      feedback: class extends ContentPage then content: feedbackContent

    routes:
      '/home': 'home'
      '/about': 'about'
      '/classify': 'classify'
      '/profile': 'profile'
      '/feedback': 'feedback'

    default: 'home'

  Route.setup()

  app.topBar.el.prependTo 'body'
  app.stack.el.appendTo 'body'

module.exports = app
