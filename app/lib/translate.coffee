$ = require 'jqueryify'
strings = require 'translations/en_us'

translate = (keys...) ->
  keys = keys[0].split '.' if keys.length is 1
  reference = strings

  for key in keys
    return unless reference[key]
    reference = reference[key]

  reference

translate.init = (language = null, global) ->
  # TODO: Load the new language and modify the "strings" variable (if language).
  window[global] = translate if global
  $(window).trigger 'translate-init'

module.exports = translate
