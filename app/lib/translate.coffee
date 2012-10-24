$ = require 'jqueryify'
strings = require 'translations/en_us'

dev = +window.location.port >= 1024

translate = (keys...) ->
  keys = keys[0].split '.' if keys.length is 1
  reference = strings

  for key in keys
    throw new Error "No translation for #{keys.join '.'}" unless reference[key]?
    reference = reference[key]

  reference

translate.init = (language = null) ->
  # TODO: Load the new language and modify the "strings" variable (if language).
  $(window).trigger 'translate-init'

module.exports = translate
