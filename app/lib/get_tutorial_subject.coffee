Subject = require 'models/subject'

module.exports = ->
  Subject.create
    id: '5077375154558fabd7000003'
    zooniverseId: 'TUTORIAL_SUBJECT'
    workflowId: '5077375154558fabd7000002'

    location: standard: [
      'images/tutorial-subject/PICT0500.JPG'
      'images/tutorial-subject/PICT0501.JPG'
      'images/tutorial-subject/PICT0502.JPG'
    ]

    coords: [2.3308, 34.8333]

    metadata:
      tutorial: true
      timestamps: [(new Date).toString()]
