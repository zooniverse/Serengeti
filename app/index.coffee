require 'lib/setup'

$ = require 'jqueryify'
{Stack} = require 'spine/lib/manager'
Route = require 'spine/lib/route'
ContentPage = require 'controllers/content_page'
HomePage = require 'controllers/home_page'
Classifier = require 'controllers/classifier'
tutorialSubject = require 'lib/tutorial_subject'
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

  app.stack = new Stack
    className: "main #{Stack::className}"

    controllers:
      home: HomePage
      about: class extends ContentPage then content: 'about.content'
      classify: Classifier
      team: class extends ContentPage then content: 'team.content'

    routes:
      '/home': 'home'
      '/about': 'about'
      '/classify': 'classify'
      '/team': 'team'

    default: 'home'

  Route.setup()

  app.topBar.el.prependTo 'body'
  app.stack.el.appendTo 'body'

  # Simulate setting a subject.
  tutorialSubject.select()

User.bind 'sign-in', ->
  $('html').toggleClass 'signed-in', User.current?

host = if +location.port < 1024
  'https://api.zooniverse.org'
else
  "#{location.protocol}//#{location.hostname}:3000"

Api.init {host}

language = localStorage.language

translate.init language

module.exports = app
