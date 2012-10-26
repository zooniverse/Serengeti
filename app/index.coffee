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

app = {}

$(window).one 'translate-init', ->
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
      home: HomePage
      about: AboutPage
      classify: Classifier
      profile: Profile

    routes:
      '/home': 'home'
      '/about': 'about'
      '/classify': 'classify'
      '/profile': 'profile'

    default: 'home'

  Route.setup()

  app.topBar.el.prependTo 'body'
  app.stack.el.appendTo 'body'

User.bind 'sign-in', ->
  $('html').toggleClass 'signed-in', User.current?

Api.init
  host: if !!~location.href.indexOf 'beta'
    'https://dev.zooniverse.org'
  else if +location.port < 1024
    'https://api.zooniverse.org'
  else
    "#{location.protocol}//#{location.hostname}:3000"

language = localStorage.language
translate.init language

module.exports = app
