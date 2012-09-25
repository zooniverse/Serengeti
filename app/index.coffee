require 'lib/setup'

Classifier = require 'controllers/classifier'

classifier = new Classifier
classifier.el.appendTo 'body'

module.exports = {classifier}
