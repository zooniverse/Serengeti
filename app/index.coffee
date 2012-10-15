require 'lib/setup'

$ = require 'jqueryify'
{Stack} = require 'spine/lib/manager'
Route = require 'spine/lib/route'
ContentPage = require 'controllers/content_page'
Classifier = require 'controllers/classifier'
tutorialSubject = require 'lib/tutorial_subject'
translate = require 'lib/translate'
Api = require 'zooniverse/lib/api'
TopBar = require 'zooniverse/lib/controllers/top_bar'

app = {}

class MainStack extends Stack
  controllers:
    home: class extends ContentPage then content: 'home.content'
    about: class extends ContentPage then content: 'about.content'
    classify: Classifier
    team: class extends ContentPage then content: 'team.content'

  routes:
    '/home': 'home'
    '/about': 'about'
    '/classify': 'classify'
    '/team': 'team'

  default: 'home'

$(window).one 'translate-init', ->
  $('.before-load').remove()

  app.topBar = new TopBar
    app: 'serengeti'
    appName: 'Serengeti'

  app.topBar.el.prependTo 'body'

  app.stack = new MainStack
    el: '#main'

  # Simulate setting a subject.
  tutorialSubject.select()

  Route.setup()

Api.init
  host: +window.location.port >= 1024 && 'http://localhost:3000' || 'http://api.zooniverse.org'

language = window.localStorage.language
translate.init language, '$t'

module.exports = app
