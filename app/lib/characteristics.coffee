Characteristic = require 'models/characteristic'
Value = Characteristic.Value
translate = require 'lib/translate'

module.exports = [
  new Characteristic
    id: 'like'
    label: translate 'characteristics', 'like'
    values: [
      new Value id: 'likeCatDog', label: translate('characteristicValues', 'likeCatDog'), image: '//placehold.it/50.png'
      new Value id: 'likeCowHorse', label: translate('characteristicValues', 'likeCowHorse'), image: '//placehold.it/50.png'
      new Value id: 'likeAntelopeDeer', label: translate('characteristicValues', 'likeAntelopeDeer'), image: '//placehold.it/50.png'
      new Value id: 'likeBird', label: translate('characteristicValues', 'likeBird'), image: '//placehold.it/50.png'
      new Value id: 'likeWeasel', label: translate('characteristicValues', 'likeWeasel'), image: '//placehold.it/50.png'
      new Value id: 'likeOther', label: translate('characteristicValues', 'likeOther'), image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'pattern'
    label: translate 'characteristics', 'pattern'
    values: [
      new Value id: 'patternVerticalStripe', label: translate('characteristicValues', 'patternVerticalStripe'), image: '//placehold.it/50.png'
      new Value id: 'patternHorizontalStripe', label: translate('characteristicValues', 'patternHorizontalStripe'), image: '//placehold.it/50.png'
      new Value id: 'patternSpots', label: translate('characteristicValues', 'patternSpots'), image: '//placehold.it/50.png'
      new Value id: 'patternSolid', label: translate('characteristicValues', 'patternSolid'), image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'coat'
    label: translate 'characteristics', 'coat'
    values: [
      new Value id: 'coatTanYellow', label: translate('characteristicValues', 'coatTanYellow'), image: '//placehold.it/50.png'
      new Value id: 'coatOrange', label: translate('characteristicValues', 'coatOrange'), image: '//placehold.it/50.png'
      new Value id: 'coatRedBrown', label: translate('characteristicValues', 'coatRedBrown'), image: '//placehold.it/50.png'
      new Value id: 'coatBrownBlack', label: translate('characteristicValues', 'coatBrownBlack'), image: '//placehold.it/50.png'
      new Value id: 'coatWhite', label: translate('characteristicValues', 'coatWhite'), image: '//placehold.it/50.png'
      new Value id: 'coatGray', label: translate('characteristicValues', 'coatGray'), image: '//placehold.it/50.png'
      new Value id: 'coatBlack', label: translate('characteristicValues', 'coatBlack'), image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'horns'
    label: translate 'characteristics', 'horns'
    values: [
      new Value id: 'hornsNone', label: translate('characteristicValues', 'hornsNone'), image: '//placehold.it/50.png'
      new Value id: 'hornsStraight', label: translate('characteristicValues', 'hornsStraight'), image: '//placehold.it/50.png'
      new Value id: 'hornsSimpleCurve', label: translate('characteristicValues', 'hornsSimpleCurve'), image: '//placehold.it/50.png'
      new Value id: 'hornsLyrate', label: translate('characteristicValues', 'hornsLyrate'), image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'tail'
    label: translate 'characteristics', 'tail'
    values: [
      new Value id: 'tailCurly', label: translate('characteristicValues', 'tailCurly'), image: '//placehold.it/50.png'
      new Value id: 'tailBushy', label: translate('characteristicValues', 'tailBushy'), image: '//placehold.it/50.png'
      new Value id: 'tailSmooth', label: translate('characteristicValues', 'tailSmooth'), image: '//placehold.it/50.png'
      new Value id: 'tailTufted', label: translate('characteristicValues', 'tailTufted'), image: '//placehold.it/50.png'
      new Value id: 'tailLong', label: translate('characteristicValues', 'tailLong'), image: '//placehold.it/50.png'
      new Value id: 'tailShort', label: translate('characteristicValues', 'tailShort'), image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'build'
    label: translate 'characteristics', 'build'
    values: [
      new Value id: 'buildStocky', label: translate('characteristicValues', 'buildStocky'), image: '//placehold.it/50.png'
      new Value id: 'buildLanky', label: translate('characteristicValues', 'buildLanky'), image: '//placehold.it/50.png'
      new Value id: 'buildTall', label: translate('characteristicValues', 'buildTall'), image: '//placehold.it/50.png'
      new Value id: 'buildSmall', label: translate('characteristicValues', 'buildSmall'), image: '//placehold.it/50.png'
      new Value id: 'buildLowSlung', label: translate('characteristicValues', 'buildLowSlung'), image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'back'
    label: translate 'characteristics', 'back'
    values: [
      new Value id: 'backSloped', label: translate('characteristicValues', 'backSloped'), image: '//placehold.it/50.png'
      new Value id: 'backRound', label: translate('characteristicValues', 'backRound'), image: '//placehold.it/50.png'
      new Value id: 'backStraight', label: translate('characteristicValues', 'backStraight'), image: '//placehold.it/50.png'
    ]
]
