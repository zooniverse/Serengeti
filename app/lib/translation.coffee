{Module, Events} = require 'spine'
$ = require 'jqueryify'

language = ''
strings = {}

translate = (keys...) ->
  reference = strings
  reference = reference[key] for key in keys
  reference

Module.extend.call translate, Events

updateStrings = ->
  strings = require "translations/#{language}"

setLanguage = (e..., newLanguage) ->
  language = newLanguage
  updateStrings()
  translate.trigger 'change', language

setLanguage 'en_us'

$(document).on 'change-language', setLanguage

module.exports = {translate}
