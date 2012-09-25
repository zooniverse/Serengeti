{Model} = require 'spine'
{translate} = require 'lib/translation'

class Characteristic extends Model
  @configure 'Characteristic', 'label', 'values'

  constructor: ->
    super

    translate.bind 'change-language', @translateLabel

    setTimeout @translateLabel

  translateLabel: =>
    @updateAttribute 'label', translate 'characteristics', @id

  class @Value extends Model
    @configure 'Value', 'label', 'image'

    constructor: ->
      super

      translate.bind 'change-language', @translateLabel

      setTimeout @translateLabel

    translateLabel: =>
      @updateAttribute 'label', translate 'characteristicValues', @id

module.exports = Characteristic
