translate = require 'lib/translate'
Classification = require 'models/classification'
User = require 'zooniverse/lib/models/user'

userCount = -> User.current?.project.user_count or 0

social = -> translate('classify.splits.social').replace '###', userCount()
task = -> translate 'classify.splits.task'
science = -> translate 'classify.splits.science'

countClassifications = ->
  return 0 unless User.current?
  count = User.current?.classification_count
  count += Classification.sentThisSession

oneClassification = -> countClassifications() is 1
lessThanThreeClassifications = -> countClassifications() <= 3

splits =
  classifier_messaging:
    a: body: social,  isShown: oneClassification
    b: body: social,  isShown: lessThanThreeClassifications
    c: body: task,    isShown: oneClassification
    d: body: task,    isShown: lessThanThreeClassifications
    e: body: science, isShown: oneClassification
    f: body: science, isShown: lessThanThreeClassifications

get = (key) ->
  body = ''

  if User.current?.project?.splits?[key]?
    splitId = User.current.project.splits[key]
    message = splits[key][splitId]
    body = message.body {userCount} if message.isShown()

  body

module.exports = {get}
