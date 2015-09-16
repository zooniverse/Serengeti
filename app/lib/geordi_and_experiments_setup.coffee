ExperimentServerClient = require 'lib/experiments'
ExperimentServer = new ExperimentServerClient()
Subject = require 'models/subject'
User = require 'zooniverse/lib/models/user'
GeordiClient = require 'zooniverse-geordi-client'

checkZooUserID = ->
  User.current?.zooniverse_id

checkZooSubject = ->
  Subject.current?.zooniverseId

Geordi = new GeordiClient({
  "server": "production"
  "projectToken": "serengeti"
  "zooUserIDGetter": checkZooUserID
  "subjectGetter": checkZooSubject
  "experimentServerClient": ExperimentServer
})

module.exports = {Geordi,ExperimentServer}

