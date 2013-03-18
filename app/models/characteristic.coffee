{Model} = require 'spine'

class Characteristic extends Model
  @configure 'Characteristic', 'label', 'values'

  class @Value extends Model
    @configure 'Value', 'label', 'image'

module.exports = Characteristic
