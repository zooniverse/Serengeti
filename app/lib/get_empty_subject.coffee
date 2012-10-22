Subject = require 'models/subject'

module.exports = ->
  Subject.create
    id: 'EMPTY_SUBJECT'

    location: standard: [
      '//placehold.it/570x400.png'
    ]

    coords: [2.3308, 34.8333]

    metadata:
      empty: true
