translate = require 't7e'
enUs = require '../translations/en_us'
$ = require 'jqueryify'

translate.load enUs

require 'json2ify'
require 'es5-shimify'

require 'jqueryify'
require 'spine'

# Here so that it is included after jQuery
require './jquery-ui-1.9.2.custom.js'
require './wax.leaf.js'
require './cartodb-leaflet.js'
