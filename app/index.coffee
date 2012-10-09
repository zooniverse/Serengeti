require 'lib/setup'

$ = require 'jqueryify'
ContentPage = require 'controllers/content_page'
Classifier = require 'controllers/classifier'
tutorialSubject = require 'lib/tutorial_subject'
translate = require 'lib/translate'

app = {}

$(window).one 'translate-init', ->
  $('.before-load').remove()

  for page in ['home', 'about']
    app[page] = new ContentPage content: "#{page}.content"
    app[page].el.appendTo 'body'

  app.classifier = new Classifier
  app.classifier.el.appendTo 'body'

  # Simulate setting a subject.
  tutorialSubject.select()

language = window.localStorage.language
translate.init language, '$t'

module.exports = app
