require 'lib/setup'

Classifier = require 'controllers/classifier'
tutorialSubject = require 'lib/tutorial_subject'

classifier = new Classifier
classifier.el.appendTo 'body'

# Simulate setting a subject.
tutorialSubject.select()

module.exports = {classifier}
