Characteristic = require 'models/characteristic'
Value = Characteristic.Value
translate = require 'lib/translate'

module.exports = [
  new Characteristic
    id: 'like'
    label: translate 'characteristics', 'like'
    values: [
      new Value id: 'likeCatDog', label: translate('characteristicValues', 'likeCatDog'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'likeCowHorse', label: translate('characteristicValues', 'likeCowHorse'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'likeAntelopeDeer', label: translate('characteristicValues', 'likeAntelopeDeer'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'likeBird', label: translate('characteristicValues', 'likeBird'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'likeWeasel', label: translate('characteristicValues', 'likeWeasel'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'likeOther', label: translate('characteristicValues', 'likeOther'), image: 'http://lorempixel.com/40/40/abstract'
    ]

  new Characteristic
    id: 'pattern'
    label: translate 'characteristics', 'pattern'
    values: [
      new Value id: 'patternVerticalStripe', label: translate('characteristicValues', 'patternVerticalStripe'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'patternHorizontalStripe', label: translate('characteristicValues', 'patternHorizontalStripe'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'patternSpots', label: translate('characteristicValues', 'patternSpots'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'patternSolid', label: translate('characteristicValues', 'patternSolid'), image: 'http://lorempixel.com/40/40/abstract'
    ]

  new Characteristic
    id: 'coat'
    label: translate 'characteristics', 'coat'
    values: [
      new Value id: 'coatTanYellow', label: translate('characteristicValues', 'coatTanYellow'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'coatOrange', label: translate('characteristicValues', 'coatOrange'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'coatRedBrown', label: translate('characteristicValues', 'coatRedBrown'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'coatBrownBlack', label: translate('characteristicValues', 'coatBrownBlack'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'coatWhite', label: translate('characteristicValues', 'coatWhite'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'coatGray', label: translate('characteristicValues', 'coatGray'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'coatBlack', label: translate('characteristicValues', 'coatBlack'), image: 'http://lorempixel.com/40/40/abstract'
    ]

  new Characteristic
    id: 'horns'
    label: translate 'characteristics', 'horns'
    values: [
      new Value id: 'hornsNone', label: translate('characteristicValues', 'hornsNone'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'hornsStraight', label: translate('characteristicValues', 'hornsStraight'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'hornsSimpleCurve', label: translate('characteristicValues', 'hornsSimpleCurve'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'hornsLyrate', label: translate('characteristicValues', 'hornsLyrate'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'hornsCurly', label: translate('characteristicValues', 'hornsCurly'), image: 'http://lorempixel.com/40/40/abstract'
    ]

  new Characteristic
    id: 'tail'
    label: translate 'characteristics', 'tail'
    values: [
      new Value id: 'tailBushy', label: translate('characteristicValues', 'tailBushy'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'tailSmooth', label: translate('characteristicValues', 'tailSmooth'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'tailTufted', label: translate('characteristicValues', 'tailTufted'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'tailLong', label: translate('characteristicValues', 'tailLong'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'tailShort', label: translate('characteristicValues', 'tailShort'), image: 'http://lorempixel.com/40/40/abstract'
    ]

  new Characteristic
    id: 'build'
    label: translate 'characteristics', 'build'
    values: [
      new Value id: 'buildStocky', label: translate('characteristicValues', 'buildStocky'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'buildLanky', label: translate('characteristicValues', 'buildLanky'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'buildTall', label: translate('characteristicValues', 'buildTall'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'buildSmall', label: translate('characteristicValues', 'buildSmall'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'buildLowSlung', label: translate('characteristicValues', 'buildLowSlung'), image: 'http://lorempixel.com/40/40/abstract'
    ]

  new Characteristic
    id: 'back'
    label: translate 'characteristics', 'back'
    values: [
      new Value id: 'backSloped', label: translate('characteristicValues', 'backSloped'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'backRound', label: translate('characteristicValues', 'backRound'), image: 'http://lorempixel.com/40/40/abstract'
      new Value id: 'backStraight', label: translate('characteristicValues', 'backStraight'), image: 'http://lorempixel.com/40/40/abstract'
    ]
]
