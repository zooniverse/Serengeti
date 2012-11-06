{Controller} = require 'spine'
template = require 'views/home_page'
ImageChanger = require './image_changer'
Api = require 'zooniverse/lib/api'

class HomePage extends Controller
  totalSubjects: NaN

  className: 'home-page'

  elements:
    '.recents figure': 'recents'
    '.progress .classification-count': 'classificationCount'
    '.progress .user-count': 'userCount'
    '.progress .fill': 'progressFill'

  activeRecent: -1

  constructor: ->
    super
    @html template

    @imageChanger = new ImageChanger
      el: @el.find '.recents .image-changer'
      sources: []

    Api.get '/projects/serengeti', (data) =>
      @classificationCount.html data.classification_count
      @userCount.html data.user_count
      @progressFill.width "#{100 * (data.complete_count / @totalSubjects)}%"

    Api.get '/projects/serengeti/recents', (recents) =>
      # Prefer to show favorites
      recents.sort (a, b) -> a.favorited < b.favorited

      mostRecent = for recent, i in recents when i < 3
        locations = recent.subjects[0].location.standard
        locations[Math.floor locations.length / 2]

      @imageChanger.setSources mostRecent

module.exports = HomePage
