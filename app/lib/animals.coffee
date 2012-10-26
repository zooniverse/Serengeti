FilteringSet = require 'models/filtering_set'
Animal = require 'models/animal'
translate = require 'lib/translate'

# The master list of animals is generated from this spreadsheet that the science team put together.
# https://docs.google.com/spreadsheet/ccc?key=0AlwCBXG5ae-wdGo5b3hRcnU1RDZsYlV2YVpjMWtNU0E

# The order of these values must match the order in the spreadsheet.
values = [
  'likeCatDog', 'likeCowHorse', 'likeAntelopeDeer', 'likeBird', 'likeOther', 'likeWeasel',
  'patternVerticalStripe', 'patternHorizontalStripe', 'patternSpots', 'patternSolid',
  'coatTanYellow', 'coatOrange', 'coatRedBrown', 'coatBrownBlack', 'coatWhite', 'coatGray', 'coatBlack',
  'hornsNone', 'hornsStraight', 'hornsSimpleCurve', 'hornsLyrate', 'hornsCurly',
  'tailBushy', 'tailSmooth', 'tailTufted', 'tailLong', 'tailShort',
  'buildStocky', 'buildLanky', 'buildTall', 'buildSmall', 'buildLowSlung',
  'backSloped', 'backRound', 'backStraight'
]

# The order of characteristics is derived from the list of values.
characteristics = ['like', 'pattern', 'coat', 'horns', 'tail', 'build', 'back']

# The animal names and "grid" values are from the spreadsheet.
# Order matches the values. 1 means it describes that animal, 0 means it does not.
# If you want to re-label an animal, do it in the translation file.
animalCharacteristics = [
  {aardvark:         [0,0,0,0,1,0,0,0,0,1,0,0,1,0,0,1,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0]}
  {aardwolf:         [1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0]}
  {baboon:           [0,0,0,0,1,0,0,0,0,1,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0]}
  {batEaredFox:      [1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,1,0]}
  {bushbuck:         [0,0,1,0,0,0,1,1,1,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
  {capeBuffalo:      [0,0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,1,1,0,0,1,0,0,0,0,0,0,0]}
  {caracal:          [1,0,0,0,0,0,0,0,0,1,1,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,1]}
  {cheetah:          [1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,1,0,0,0,0,0,0]}
  {civet:            [1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0]}
  {dikDik:           [0,0,1,0,0,0,0,0,0,1,0,0,1,0,0,1,0,1,1,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0]}
  {eland:            [0,1,1,0,0,0,1,0,0,0,1,0,1,0,0,1,0,1,1,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0]}
  {elephant:         [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1,1,0,0,1,0,1,0,0,0,0,0]}
  {genet:            [1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0]}
  {giraffe:          [0,0,0,0,1,0,0,0,1,0,0,1,0,1,0,0,0,1,1,0,0,0,0,0,1,0,0,0,1,1,0,0,1,0,0]}
  {gazelleGrants:    [0,0,1,0,0,0,0,1,0,1,1,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1]}
  {gazelleThompsons: [0,0,1,0,0,0,0,1,0,1,1,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1]}
  {guineaFowl:       [0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
  {hare:             [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
  {hartebeest:       [0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,0,0,1,0,0,1,1,1,0,0,0,0,0,0,1,0,0]}
  {hippopotamus:     [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,0,1]}
  {honeyBadger:      [1,0,0,0,0,1,0,1,0,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,0,1,0,1,0,0,1,1,0,1,1]}
  {hyenaSpotted:     [1,0,0,0,0,0,1,0,1,0,0,0,1,0,0,1,1,1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0]}
  {hyenaStriped:     [1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0]}
  {impala:           [0,0,1,0,0,0,0,0,0,1,0,1,1,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1]}
  {jackal:           [1,0,0,0,0,0,0,1,0,1,0,0,1,0,0,1,0,1,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0,0,1]}
  {koriBustard:      [0,0,0,1,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
  {leopard:          [1,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,1]}
  {lionFemale:       [1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0]}
  {lionMale:         [1,0,0,0,0,0,0,0,0,1,1,0,1,0,0,0,0,1,0,0,0,0,0,1,1,1,0,1,0,0,0,0,0,0,1]}
  {lizard:           [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0]}
  {mongoose:         [0,0,0,0,0,1,1,0,0,1,0,1,1,0,0,1,0,1,0,0,0,0,1,1,0,1,0,0,0,0,1,1,0,1,0]}
  {ostrich:          [0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
  {porcupine:        [0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,1,1,0,0,0,0,1,0,0,0,1,0,1,0,1,1,0,0,0]}
  {reedbuck:         [0,0,1,0,0,0,0,0,0,1,0,1,1,0,0,0,0,1,0,1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1]}
  {rhinoceros:       [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,1,1,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,1]}
  {secretaryBird:    [0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
  {serval:           [1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,1,0,0,1,0,1,0,0,0,1]}
  {topi:             [0,1,1,0,0,0,0,0,0,1,0,0,1,1,0,0,0,1,0,1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1]}
  {vervetMonkey:     [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
  {warthog:          [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1]}
  {waterbuck:        [0,1,1,0,0,0,0,0,0,1,0,0,1,0,0,1,0,1,0,1,0,0,0,1,0,0,1,0,0,0,0,0,0,0,1]}
  {wildcat:          [1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,1]}
  {wildebeest:       [0,1,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,1,1,0,0,0,0,0,0,0,1,0,0]}
  {zebra:            [0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1]}
  {otherBird:        [0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
  {otherPrimate:     [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
  {otherRodent:      [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
  {human:            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
]

dashedFromId = (id) ->
  id.replace /[A-Z]/g, (cap) -> "-#{cap.toLowerCase()}"

imagesFromId = (id) -> [
    "images/animals/#{dashedFromId id}-1.jpg"
    "images/animals/#{dashedFromId id}-2.jpg"
    "images/animals/#{dashedFromId id}-3.jpg"
  ]

animals = new FilteringSet
  items: for item in animalCharacteristics
    for id, grid of item
      animal = new Animal
        id: id
        label: translate 'animals', id, 'label'
        description: translate 'animals', id, 'description'
        images: imagesFromId id

      for char in characteristics
        animal[char] = (value for value, i in values when value[0...char.length] is char and grid[i] is 1)
        animal[char] = animal[char][0] if animal[char].length is 1
        delete animal[char] if animal[char].length is 0

      animal.save()
    animal

module.exports = animals
