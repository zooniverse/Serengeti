translate = require 't7e'
Classification = require 'models/classification'
User = require 'zooniverse/lib/models/user'

userCount = -> User.count or 0

none = -> ''
social = -> translate('span', 'classify.splits.social').replace '###', userCount()
task = -> translate 'span', 'classify.splits.task'
science = -> translate 'span', 'classify.splits.science'

countClassifications = ->
  return 0 unless User.current?
  count = User.current?.project?.classification_count || 0
  count += Classification.sentThisSession

oneClassification = -> countClassifications() is 1
lessThanThreeClassifications = -> countClassifications() <= 4 # That's 3 + tutorial

splits =
  classifier_messaging:
    a: body: none,    isShown: oneClassification
    b: body: none,    isShown: lessThanThreeClassifications
    c: body: social,  isShown: oneClassification
    d: body: social,  isShown: lessThanThreeClassifications
    e: body: task,    isShown: oneClassification
    f: body: task,    isShown: lessThanThreeClassifications
    g: body: science, isShown: oneClassification
    h: body: science, isShown: lessThanThreeClassifications

get = (key) ->
  body = ''

  if User.current?.project?.splits?[key]?
    splitId = User.current.project.splits[key]
    message = splits[key][splitId]
    body = message.body() if message.isShown()

  body

module.exports = {get}
