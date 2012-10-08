{Model} = require 'spine'
translate = require 'lib/translate'

class Characteristic extends Model
  @configure 'Characteristic', 'label', 'values'

  class @Value extends Model
    @configure 'Value', 'label', 'image'

module.exports = Characteristic
