{Controller} = require 'spine'
translate = require 'lib/translate'

class ContentPage extends Controller
  content: ''

  tag: 'section'
  className: 'content-page'

  constructor: ->
    super

    @el.append translate @content

module.exports = ContentPage
