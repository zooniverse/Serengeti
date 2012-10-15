require 'lib/setup'

$ = require 'jqueryify'
{Stack} = require 'spine/lib/manager'
Route = require 'spine/lib/route'
ContentPage = require 'controllers/content_page'
Classifier = require 'controllers/classifier'
tutorialSubject = require 'lib/tutorial_subject'
translate = require 'lib/translate'

app = {}

class MainStack extends Stack
  el: '#main'

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

  app.stack = new MainStack

  # Simulate setting a subject.
  tutorialSubject.select()

  Route.setup()

language = window.localStorage.language
translate.init language, '$t'

module.exports = app
