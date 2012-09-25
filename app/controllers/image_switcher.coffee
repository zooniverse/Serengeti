{Controller} = require 'spine'
$ = require 'jqueryify'

class ImageSwitcher extends Controller
  events:
    'click button[name="toggle"]': onClickToggle

  onClickToggle: ({currentTarget}) =>
    imgIndex = $(currentTarget).val()

module.exports = ImageSwitcher
