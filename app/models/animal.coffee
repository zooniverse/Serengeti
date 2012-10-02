{Model} = require 'spine'
{translate} = require 'lib/translation'
characteristics = require 'lib/characteristics'

characteristicIds = (characteristic.id for characteristic in characteristics)

class Animal extends Model
  @configure 'Animal', 'label', 'image', characteristicIds...

  constructor: ->
    super

    translate.bind 'change-language', @translateLabel

    # Delay so the model can initialize before updating its attributes.
    setTimeout @translateLabel

  translateLabel: =>
    @updateAttribute 'label', translate 'animals', @id

module.exports = Animal
