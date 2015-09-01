User = require 'zooniverse/lib/models/user'
UserGetter = require 'zoo-user-getter'

checkZooUser = ->
  User.current?.zooniverse_id

UserGetter.setZooniverseCurrentUserChecker(checkZooUser)

exports.UserGetter = UserGetter
