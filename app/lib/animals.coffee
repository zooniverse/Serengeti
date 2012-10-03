FilteringSet = require 'models/filtering_set'
Animal = require 'models/animal'

# The master list of animals is generated from this spreadsheet that the science team put together.
# https://docs.google.com/spreadsheet/ccc?key=0AlwCBXG5ae-wdGo5b3hRcnU1RDZsYlV2YVpjMWtNU0E

# The order of these values must match the order in the spreadsheet.
values = [
  'likeCatDog', 'likeCowHorse', 'likeAntelopeDeer', 'likeBird', 'likeOther', 'likeWeasel',
  'patternVerticalStripe', 'patternHorizontalStripe', 'patternSpots', 'patternSolid',
  'coatTanYellow', 'coatOrange', 'coatRedBrown', 'coatBrownBlack', 'coatWhite', 'coatGray', 'coatBlack',
  'hornsNone', 'hornsStraight', 'hornsCurve', 'hornsLyrate', 'hornsCurly',
  'tailBushy', 'tailSmooth', 'tailTufted', 'tailLong', 'tailShort',
  'buildStocky', 'buildLanky', 'buildTall', 'buildSmall', 'buildLowSlung',
  'backSloped', 'backRound', 'backStraight'
]

# The order of characteristics is derived from the list of values.
characteristics = ['like', 'pattern', 'coat', 'horns', 'tail', 'build', 'back']

# The animal names and "grid" values are from the spreadsheet.
# Order matches the values. 1 means it describes that animal, 0 means it does not.
# If you want to re-label an animal, do it in the translation file.
animals =
  'Aardvark':            [0,0,0,0,1,0,0,0,0,1,0,0,1,0,0,1,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0]
  'Aardwolf':            [1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0]
  'Baboon':              [0,0,0,0,1,0,0,0,0,1,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0]
  'Bat-eared fox':       [1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,1,0]
  'Buffalo':             [0,0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,1,1,0,0,1,0,0,0,0,0,0,0]
  'Bushbuck':            [0,0,1,0,0,0,1,1,1,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  'Caracal':             [1,0,0,0,0,0,0,0,0,1,1,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,1]
  'Cheetah':             [1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,1,0,0,0,0,0,0]
  'Civet':               [1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0]
  'Dik Dik':             [0,0,1,0,0,0,0,0,0,1,0,0,1,0,0,1,0,1,1,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0]
  'Eland':               [0,1,1,0,0,0,1,0,0,0,1,0,1,0,0,1,0,1,1,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0]
  'Elephant':            [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1,1,0,0,1,0,1,0,0,0,0,0]
  'Female Lion':         [1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0]
  'Genet':               [1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0]
  'Giraffe':             [0,0,0,0,1,0,0,0,1,0,0,1,0,1,0,0,0,1,1,0,0,0,0,0,1,0,0,0,1,1,0,0,1,0,0]
  'Grant\'s Gazelle':    [0,0,1,0,0,0,0,1,0,1,1,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1]
  'Guinea Fowl':         [0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  'Hartebeest':          [0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,0,0,1,0,0,1,1,1,0,0,0,0,0,0,1,0,0]
  'Hippopotamus':        [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,0,1]
  'Honey-badger':        [1,0,0,0,0,1,0,1,0,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,0,1,0,1,0,0,1,1,0,1,1]
  'Impala':              [0,0,1,0,0,0,0,0,0,1,0,1,1,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1]
  'Jackal':              [1,0,0,0,0,0,0,1,0,1,0,0,1,0,0,1,0,1,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0,0,1]
  'Kori Bustard':        [0,0,0,1,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  'Leopard':             [1,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,1]
  'Lizard':              [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0]
  'Male Lion':           [1,0,0,0,0,0,0,0,0,1,1,0,1,0,0,0,0,1,0,0,0,0,0,1,1,1,0,1,0,0,0,0,0,0,1]
  'Mongoose':            [0,0,0,0,0,1,1,0,0,1,0,1,1,0,0,1,0,1,0,0,0,0,1,1,0,1,0,0,0,0,1,1,0,1,0]
  'Ostrich':             [0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  'Other Bird':          [0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  'Other Primate':       [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  'Other Rodent':        [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  'Porcupine':           [0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,1,1,0,0,0,0,1,0,0,0,1,0,1,0,1,1,0,0,0]
  'Reedbuck':            [0,0,1,0,0,0,0,0,0,1,0,1,1,0,0,0,0,1,0,1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1]
  'Rhinoceros':          [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,1,1,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,1]
  'Secretary Bird':      [0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  'Serval':              [1,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,1,0,0,1,0,1,0,0,0,1]
  'Spotted Hyena':       [1,0,0,0,0,0,1,0,1,0,0,0,1,0,0,1,1,1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0]
  'Striped Hyena':       [1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0]
  'Thompson\'s Gazelle': [0,0,1,0,0,0,0,1,0,1,1,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1]
  'Topi':                [0,1,1,0,0,0,0,0,0,1,0,0,1,1,0,0,0,1,0,1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1]
  'Vervet Monkey':       [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  'Warthog':             [0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1]
  'Waterbuck':           [0,1,1,0,0,0,0,0,0,1,0,0,1,0,0,1,0,1,0,1,0,0,0,1,0,0,1,0,0,0,0,0,0,0,1]
  'Wildcat':             [1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,1]
  'Wildebeest':          [0,1,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,1,1,0,0,0,0,0,0,0,1,0,0]
  'Zebra':               [0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1]

upperCapture = (match, capture) -> capture.toUpperCase()
idFromLabel = (label) ->
  label = label.replace /^\w/, label.charAt(0).toLowerCase() # First letter lower case
  label = label.replace '\'', '' # Remove single quotes
  label = label.replace /\s(\w)/i, upperCapture # Camel-case spaces
  label = label.replace /\W(\w)/i, upperCapture # Camel-case hyphens
  label

imageFromId = (id) ->
  '//placehold.it/300.png'

animalInstances = for label, grid of animals
  id = idFromLabel label

  animal = new Animal
    id: id
    image: imageFromId id

  for char in characteristics
    animal[char] = (value for value, i in values when value[0...char.length] is char and grid[i] is 1)
    animal[char] = animal[char][0] if animal[char].length is 1
    delete animal[char] if animal[char].length is 0

  animal.save()
  animal

window.animals = animalInstances

module.exports = new FilteringSet items: animalInstances
