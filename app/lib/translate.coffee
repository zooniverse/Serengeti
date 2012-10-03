language = ''
strings = {}

translate = (keys...) ->
  keys = keys[0].split '.' if keys.length is 1
  reference = strings
  reference = reference[key] for key in keys
  reference

updateStrings = ->
  strings = require "translations/#{language}"

setLanguage = (newLanguage) ->
  language = newLanguage
  updateStrings()

setLanguage 'en_us' # TODO: Pick the language out of localStorage.

module.exports = translate
window.$t = translate
