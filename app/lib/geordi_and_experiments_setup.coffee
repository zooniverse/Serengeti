ExperimentServerClient = require 'lib/experiments'

Subject = require 'models/subject'
User = require 'Zooniverse/lib/models/user'
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
})

ExperimentServer = new ExperimentServerClient(Geordi)

Geordi.experimentServerClient = ExperimentServer

module.exports = Geordi

