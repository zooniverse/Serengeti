FilteringSet = require 'models/filtering_set'
Animal = require 'models/animal'

module.exports = new FilteringSet items: [
  new Animal
    id: 'aardvark'
    face: ['faceLong', 'faceSnout']
    back: 'backRound'
    coat: 'coatShort'
    frontLimbs: ['short']
    backLimbs: ['short']
    build: ['stocky']
    horns: ['none']
    ears: ['large']
    tail: ['thin']
    color: ['red', 'brown', 'gray']

  new Animal
    id: 'batEaredFox'
    face: 'faceShort'
    back: 'backRound'
    coat: 'coatShort'
    frontChest: ['light']
    ears: ['large']
    tail: ['bushy']
    color: ['red', 'gray']

  new Animal
    id: 'cheetah'
    face: 'faceShort'
    back: 'backFlat'
    coat: 'coatShort'
    frontLimbs: ['thin']
    backLimbs: ['thin']
    feet: ['small']
    pattern: ['spots']
    build: ['lean']

  new Animal
    id: 'dikDik'
    face: ['faceLong', 'faceSnout']
    back: 'backRound'
    coat: 'coatShort'
    frontChest: ['light']
    build: ['small']
    horns: ['small', 'backward']
    ears: ['large']
    eyes: ['large']
    tail: ['short']
    color: ['gray', 'brown']
]
