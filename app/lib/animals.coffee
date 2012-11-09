FilteringSet = require 'models/filtering_set'
Animal = require 'models/animal'
translate = require 'lib/translate'

# The master list of animals is generated from this spreadsheet that the science team put together.
# https://docs.google.com/spreadsheet/ccc?key=0AlwCBXG5ae-wdGo5b3hRcnU1RDZsYlV2YVpjMWtNU0E

# The order of these values must match the order in the spreadsheet.
values = [
  'likeCatDog', 'likeCowHorse', 'likeAntelopeDeer', 'likeBird', 'likeOther', 'likeWeasel'
  'patternVerticalStripe', 'patternHorizontalStripe', 'patternSpots', 'patternSolid'
  'coatTanYellow', 'coatRedBrown', 'coatBrownBlack', 'coatWhite', 'coatGray', 'coatBlack'
  'hornsNone', 'hornsStraight', 'hornsSimpleCurve', 'hornsLyrate', 'hornsCurly'
  'tailBushy', 'tailSmooth', 'tailTufted', 'tailLong', 'tailShort'
  'buildStocky', 'buildLanky', 'buildTall', 'buildSmall', 'buildLowSlung', 'buildSloped'
]

# The order of characteristics is derived from the list of values.
characteristics = ['like', 'pattern', 'coat', 'horns', 'tail', 'build']

# The animal names and "grid" values are from the spreadsheet.
# Order matches the values. 1 means it describes that animal, 0 means it does not.
# If you want to re-label an animal, do it in the translation file.
animalCharacteristics = [
  {aardvark:        [0,0,0,0,1,0,0,0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,1,0]}
  {aardwolf:        [1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1]}
  {baboon:          [0,0,0,0,1,0,0,0,0,1,0,1,1,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0]}
  {batEaredFox:     [1,0,0,0,0,0,0,0,0,1,0,1,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0]}
  {otherBird:       [0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
  {buffalo:         [0,0,0,0,1,0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1,0,1,1,0,0,1,0,0,0,0,0]}
  {bushbuck:        [0,0,1,0,0,0,1,1,1,0,0,1,1,0,0,0,1,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0]}
  {caracal:         [1,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0]}
  {cheetah:         [1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,1,0,0,0,0]}
  {civet:           [1,0,0,0,0,1,0,0,1,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0]}
  {dikDik:          [0,0,1,0,0,0,0,0,0,1,0,1,0,0,1,0,1,1,0,0,0,0,0,0,0,1,0,0,0,1,0,0]}
  {eland:           [0,1,1,0,0,0,1,0,0,0,1,1,0,0,1,0,1,1,0,0,0,0,0,0,0,0,1,0,1,0,0,0]}
  {elephant:        [0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,1,0,0,0,0,0,1,1,0,0,1,0,1,0,0,0]}
  {gazelleGrants:   [0,0,1,0,0,0,0,1,0,1,1,0,0,0,0,0,1,1,1,0,0,0,0,1,0,1,0,0,0,0,0,0]}
  {gazelleThomsons: [0,0,1,0,0,0,0,1,0,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,0,0,0,1,0,0]}
  {genet:           [1,0,0,0,0,1,0,0,1,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0]}
  {giraffe:         [0,0,0,0,1,0,0,0,1,0,1,1,1,0,0,0,1,1,0,0,0,0,0,1,0,0,0,1,1,0,0,1]}
  {guineaFowl:      [0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0]}
  {hare:            [0,0,0,0,1,0,0,0,0,1,0,1,0,0,1,0,0,0,0,0,0,1,0,0,0,1,0,1,0,1,0,0]}
  {hartebeest:      [0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,1,1,0,0,1,1,1,0,0,1,0,0,0,1]}
  {hippopotamus:    [0,0,0,0,1,0,0,0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0]}
  {honeyBadger:     [1,0,0,0,0,1,0,1,0,1,0,0,0,1,1,1,1,0,0,0,0,1,1,0,0,0,1,0,0,1,1,0]}
  {hyenaSpotted:    [1,0,0,0,0,0,0,0,1,0,0,1,1,0,1,1,1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1]}
  {hyenaStriped:    [1,0,0,0,0,0,1,0,0,0,0,1,1,0,1,1,1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1]}
  {impala:          [0,0,1,0,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0]}
  {jackal:          [1,0,0,0,0,0,0,1,0,1,1,1,1,0,1,1,1,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0]}
  {koriBustard:     [0,0,0,1,0,0,0,0,1,1,0,1,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0]}
  {leopard:         [1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,1,1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0]}
  {lionFemale:      [1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0]}
  {lionMale:        [1,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,1,1,1,0,1,0,0,0,0,0]}
  {mongoose:        [0,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,1,0,0,0,0,1,1,0,1,0,0,0,0,1,1,0]}
  {ostrich:         [0,0,0,1,0,0,0,0,0,1,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0]}
  {porcupine:       [0,0,0,0,1,0,0,0,0,1,0,0,0,1,0,1,1,0,0,0,0,1,0,0,0,1,1,0,0,1,1,0]}
  {reedbuck:        [0,0,1,0,0,0,0,0,0,1,0,1,0,0,0,0,1,0,1,0,0,1,0,0,0,1,0,0,0,0,0,0]}
  {reptiles:        [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0]}
  {rhinoceros:      [0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,1,1,0,0,0,0,1,1,0,0,1,0,0,0,0,0]}
  {rodents:         [0,0,0,0,1,0,0,1,0,1,1,1,1,1,1,1,0,0,0,0,0,1,1,0,1,0,0,1,0,1,0,0]}
  {secretaryBird:   [0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0]}
  {serval:          [1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,1,1,0,0,0,0,0,1,0,1,0,0,1,0,1,0,0]}
  {topi:            [0,1,1,0,0,0,0,0,0,1,0,1,1,0,0,0,1,0,1,0,0,0,0,1,1,1,0,1,0,0,0,1]}
  {vervetMonkey:    [0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0]}
  {warthog:         [0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,1,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0]}
  {waterbuck:       [0,1,1,0,0,0,0,0,0,1,0,1,0,0,0,0,1,0,1,0,0,0,1,0,0,1,1,0,1,0,0,0]}
  {wildcat:         [1,0,0,0,0,0,0,0,1,1,1,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0]}
  {wildebeest:      [0,1,1,0,0,0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1,0,1,1,0,0,0,1,0,0,0,1]}
  {zebra:           [0,1,0,0,0,0,1,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0]}
  {zorilla:         [0,0,0,0,0,1,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0]}
  {human:           [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
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

# Make "confusing" associations after all animals have been created.
confusingSets =
  aardwolf: ['hyenaStriped']
  buffalo: ['wildebeest']
  caracal: ['wildcat', 'lionFemale']
  cheetah: ['leopard', 'serval']
  civet: ['genet']
  gazelleGrants: ['gazelleThomsons', 'impala']
  gazelleThomsons: ['gazelleGrants', 'impala']
  genet: ['civet']
  hartebeest:  ['gazelleGrants', 'gazelleThomsons', 'topi']
  hippopotamus: ['rhinoceros', 'warthog']
  hyenaSpotted: ['hyenaStriped']
  hyenaStriped: ['aardwolf', 'hyenaSpotted']
  impala: ['gazelleGrants', 'gazelleThomsons']
  mongoose: ['zorilla']
  reedbuck: ['dikDik']
  rhinoceros: ['hippopotamus', 'warthog']
  secretaryBird:  ['koriBustard']
  serval: ['cheetah']
  topi: ['hartebeest']
  warthog: ['hippopotamus', 'rhinoceros']
  wildebeest: ['buffalo']
  zorilla: ['mongoose']

for animalId, set of confusingSets
  animal = Animal.find animalId
  for id, i in set
    animal.confusedWith.push Animal.find id
  animal.save()

module.exports = animals
