ExperimentServerClient = require 'lib/experiments'
ExperimentServer = new ExperimentServerClient()
ExperimentalSubject = require 'models/experimental_subject'
User = require 'zooniverse/lib/models/user'
GeordiClient = require 'zooniverse-geordi-client'

checkZooUserID = ->
  User.current?.zooniverse_id

checkZooSubject = ->
  ExperimentalSubject.current?.zooniverseId

Geordi = new GeordiClient({
  "server": "production"
  "projectToken": "serengeti"
  "zooUserIDGetter": checkZooUserID
  "subjectGetter": checkZooSubject
  "experimentServerClient": ExperimentServer
})

ExperimentServer = new ExperimentServerClient(Geordi)

Geordi.experimentServerClient = ExperimentServer

module.exports = Geordi

