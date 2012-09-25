{Model} = require 'spine'
{translate} = require 'lib/translation'

class Animal extends Model
  @configure 'Animal', \
    'name', 'face', 'back', 'coat', \
    'frontLimbs', 'backLimbs', 'build', \
    'horns', 'ears', 'tail', 'color'

  constructor: ->
    super

    translate.bind 'change-language', @translateName

    # Delay so the model can initialize before updating its attributes.
    setTimeout @translateName

  translateName: =>
    @updateAttribute 'name', translate 'animals', @id

module.exports = Animal
