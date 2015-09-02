$ = require('jqueryify')
ExperimentServerClient = require 'lib/experiments'
ExperimentalSubject = require 'models/experimental_subject'
User = require 'zooniverse/lib/models/user'

checkZooUserID = ->
  User.current?.zooniverse_id

checkZooSubject = ->
  ExperimentalSubject.current?.zooniverseId

exports.ExperimentServerClient = new ExperimentServerClient()

exports.Geordi = new (require('lib/geordi'))({
  "server": "staging"
  "projectToken": "serengeti"
  "zooUserIDGetter": checkZooUserID
  "subjectGetter": checkZooSubject
  "experimentServerClient": exports.ExperimentServerClient
})