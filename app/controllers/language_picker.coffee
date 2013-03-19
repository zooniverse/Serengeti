$ = require 'jqueryify'
translate = require 't7e'
enUs = require '../translations/en_us'

DEFAULT = '$DEFAULT'

class LanguagePicker
  @DEFAULT = DEFAULT

  languages:
    'English': DEFAULT
    'Polski': 'pl_pl'

  el: null
  className: 'language-picker'

  constructor: ->
    preferredLanguage = localStorage.preferredLanguage || DEFAULT

    @el = $("<select class='#{@className}'></select>")

    for language, code of @languages
      option = $("<option value='#{code}'>#{language}</option>")
      option.attr 'selected', true if language is preferredLanguage
      @el.append option

    @el.on 'change', => @onChange arguments...

    @el.trigger 'change' unless @el.val() is DEFAULT

  onChange: ->
    preferredLanguage = @el.val()

    if preferredLanguage is DEFAULT
      translate.load enUs
      translate.refresh()
    else
      $.getJSON "./translations/#{preferredLanguage}.json", (data) ->
        console?.log? "Got translations for #{preferredLanguage}", data
        translate.load data
        translate.refresh()

module.exports = LanguagePicker
