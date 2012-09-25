FilteringSet = require 'models/filtering_set'
Animal = require 'models/animal'

module.exports = new FilteringSet items: [
  new Animal
    id: 'aardvark'
    face: ['long', 'snout']
    back: ['round']
    coat: ['short']
    frontLimbs: ['short']
    backLimbs: ['short']
    build: ['stocky']
    horns: ['none']
    ears: ['large']
    tail: ['thin']
    color: ['red', 'brown', 'gray']

  new Animal
    id: 'batEaredFox'
    face: ['short']
    back: ['round']
    frontChest: ['light']
    ears: ['large']
    tail: ['bushy']
    color: ['red', 'gray']

  new Animal
    id: 'cheetah'
    face: ['short']
    back: ['flat']
    frontLimbs: ['thin']
    backLimbs: ['thin']
    feet: ['small']
    pattern: ['spots']
    build: ['lean']

  new Animal
    id: 'dikDik'
    face: ['long', 'snout']
    frontChest: ['light']
    build: ['small']
    horns: ['small', 'backward']
    ears: ['large']
    eyes: ['large']
    tail: ['short']
    color: ['gray', 'brown']
]
