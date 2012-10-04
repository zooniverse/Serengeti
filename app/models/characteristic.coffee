{Model} = require 'spine'
translate = require 'lib/translate'

class Characteristic extends Model
  @configure 'Characteristic', 'label', 'values'

  constructor: ->
    super
    setTimeout @translateLabel

  translateLabel: =>
    @updateAttribute 'label', translate 'characteristics', @id

  class @Value extends Model
    @configure 'Value', 'label', 'image'

    constructor: ->
      super
      setTimeout @translateLabel

    translateLabel: =>
      @updateAttribute 'label', translate 'characteristicValues', @id

module.exports = Characteristic
