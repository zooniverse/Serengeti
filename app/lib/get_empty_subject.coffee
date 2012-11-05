Subject = require 'models/subject'

module.exports = ->
  Subject.create
    id: 'EMPTY_SUBJECT'

    location: standard: [
      '//placehold.it/570x400.png&text=No more subjects!' # TODO
    ]

    coords: [2.3308, 34.8333]

    metadata:
      empty: true
      timestamps: [(new Date).toString()]
