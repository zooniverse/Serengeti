characteristics = require 'lib/characteristics'
{Model} = require 'spine'
translate = require 'lib/translate'

characteristicIds = (characteristic.id for characteristic in characteristics)

class Animal extends Model
  @configure 'Animal', 'label', 'images', 'description', characteristicIds..., 'confusedWith'

  constructor: ->
    super
    @confusedWith ?= []

    setTimeout @translateLabel

  translateLabel: =>
    @updateAttribute 'label', translate 'animals', @id, 'label'

  toJSON: -> @id

module.exports = Animal
