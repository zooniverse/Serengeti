User = require 'zooniverse/lib/models/user'
ExperimentalSubject = require 'models/experimental_subject'
UserGetter = require 'zoo-user-getter'

checkZooUser = ->
  User.current?.zooniverse_id

checkZooSubject = ->
  ExperimentalSubject.current?.zooniverseId

exports.UserGetter = new UserGetter(checkZooUser)
exports.getCurrentSubject = checkZooSubject
window?.UserGetter = exports.UserGetter
