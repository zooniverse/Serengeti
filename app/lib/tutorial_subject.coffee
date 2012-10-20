Subject = require 'models/subject'

module.exports = ->
  Subject.create
    id: '5077375154558fabd7000003'

    location: [
      'images/tutorial-subject/PICT0518.JPG'
      'images/tutorial-subject/PICT0519.JPG'
      'images/tutorial-subject/PICT0520.JPG'
    ]

    coords: [2.3308, 34.8333]

    metadata:
      tutorial: true
