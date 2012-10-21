{Controller} = require 'spine'
template = require 'views/home_page'
ImageChanger = require './image_changer'

class HomePage extends Controller
  className: 'home-page'

  elements:
    '.recents figure': 'recents'

  activeRecent: -1

  constructor: ->
    super
    @html template

    @imageChanger = new ImageChanger
      el: @el.find '.recents .image-changer'
      sources: [
        '//placehold.it/600x400.png'
        '//placehold.it/600x400.png'
        '//placehold.it/600x400.png'
      ]

module.exports = HomePage
