{Controller} = require 'spine'
translate = require 't7e'

class ContentPage extends Controller
  content: ''

  tag: 'section'
  className: 'content-page'

  constructor: ->
    super

    @el.append try
      translate div: @content
    catch e
      @content

module.exports = ContentPage
