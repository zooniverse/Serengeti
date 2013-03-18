translate = require 't7e'
enUs = require 'translations/en_us'
$ = require 'jqueryify'

translate.load enUs

preferredLanguage = localStorage.preferredLanguage

if preferredLanguage?
  $.getJSON "./translations/#{language}.json", (data) ->
    console.log "Got translations for #{language}", data
    translate.load data
    translate.refresh()

require 'json2ify'
require 'es5-shimify'

require 'jqueryify'
require 'spine'

# Here so that it is included after jQuery
require 'lib/jquery-ui-1.9.2.custom'
require 'lib/wax.leaf'
require 'lib/cartodb-leaflet'
