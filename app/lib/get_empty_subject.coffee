Subject = require 'models/subject'

module.exports = ->
  Subject.create
    id: 'EMPTY_SUBJECT'

    location: standard: [
      'images/no-more-subjects.jpg'
    ]

    coords: [2.3308, 34.8333]

    metadata:
      empty: true
      timestamps: [(new Date).toString()]
