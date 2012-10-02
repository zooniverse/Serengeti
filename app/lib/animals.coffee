FilteringSet = require 'models/filtering_set'
Animal = require 'models/animal'

module.exports = new FilteringSet items: [
  new Animal
    id: 'aardvark'
    back: 'backRound'
]
