$ = require 'jqueryify'
translate = require 't7e'
enUs = require '../translations/en_us'

HTML = $(document.body.parentNode)

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
    HTML.attr 'data-language', preferredLanguage

    @el = $("<select class='#{@className}'></select>")

    for language, code of @languages
      option = $("<option value='#{code}'>#{language}</option>")
      option.attr 'selected', 'selected' if code is preferredLanguage
      @el.append option

    @el.on 'change', => @onChange arguments...

    @el.trigger 'change' unless @el.val() is DEFAULT

  onChange: ->
    preferredLanguage = @el.val()
    HTML.attr 'data-language', preferredLanguage

    localStorage.preferredLanguage = preferredLanguage

    if preferredLanguage is DEFAULT
      translate.load enUs
      translate.refresh()
    else
      $.getJSON "./translations/#{preferredLanguage}.json", (data) ->
        console?.log? "Got translations for #{preferredLanguage}", data
        translate.load data
        translate.refresh()

module.exports = LanguagePicker
