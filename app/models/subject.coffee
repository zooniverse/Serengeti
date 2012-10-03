{Model} = require 'spine'

class Subject extends Model
  @configure 'Subject', 'zooniverseId', 'location', 'coords', 'metadata'

module.exports = Subject
