Characteristic = require 'models/characteristic'
Value = Characteristic.Value
translate = require 'lib/translate'

# TODO: These should be a sprite.

module.exports = [
  new Characteristic
    id: 'like'
    label: translate 'characteristics', 'like'
    values: [
      new Value id: 'likeCatDog', label: translate('characteristicValues', 'likeCatDog'), image: 'images/characteristics/build-lanky.png'
      new Value id: 'likeCowHorse', label: translate('characteristicValues', 'likeCowHorse'), image: 'images/characteristics/build-lanky.png'
      new Value id: 'likeAntelopeDeer', label: translate('characteristicValues', 'likeAntelopeDeer'), image: 'images/characteristics/build-lanky.png'
      new Value id: 'likeBird', label: translate('characteristicValues', 'likeBird'), image: 'images/characteristics/build-lanky.png'
      new Value id: 'likeWeasel', label: translate('characteristicValues', 'likeWeasel'), image: 'images/characteristics/build-lanky.png'
      new Value id: 'likeOther', label: translate('characteristicValues', 'likeOther'), image: 'images/characteristics/build-lanky.png'
    ]

  new Characteristic
    id: 'pattern'
    label: translate 'characteristics', 'pattern'
    values: [
      new Value id: 'patternVerticalStripe', label: translate('characteristicValues', 'patternVerticalStripe'), image: 'images/characteristics/pattern-stripes.png'
      new Value id: 'patternHorizontalStripe', label: translate('characteristicValues', 'patternHorizontalStripe'), image: 'images/characteristics/pattern-color-bands.png'
      new Value id: 'patternSpots', label: translate('characteristicValues', 'patternSpots'), image: 'images/characteristics/pattern-spots.png'
      new Value id: 'patternSolid', label: translate('characteristicValues', 'patternSolid'), image: 'images/characteristics/color-red-brown.png'
    ]

  new Characteristic
    id: 'coat'
    label: translate 'characteristics', 'coat'
    values: [
      new Value id: 'coatTanYellow', label: translate('characteristicValues', 'coatTanYellow'), image: 'images/characteristics/color-tan.png'
      new Value id: 'coatOrange', label: translate('characteristicValues', 'coatOrange'), image: 'images/characteristics/color-orange.png'
      new Value id: 'coatRedBrown', label: translate('characteristicValues', 'coatRedBrown'), image: 'images/characteristics/color-red-brown.png'
      new Value id: 'coatBrownBlack', label: translate('characteristicValues', 'coatBrownBlack'), image: 'images/characteristics/color-brown.png'
      new Value id: 'coatWhite', label: translate('characteristicValues', 'coatWhite'), image: 'images/characteristics/color-white.png'
      new Value id: 'coatGray', label: translate('characteristicValues', 'coatGray'), image: 'images/characteristics/color-grey.png'
      new Value id: 'coatBlack', label: translate('characteristicValues', 'coatBlack'), image: 'images/characteristics/color-black.png'
    ]

  new Characteristic
    id: 'horns'
    label: translate 'characteristics', 'horns'
    values: [
      new Value id: 'hornsNone', label: translate('characteristicValues', 'hornsNone'), image: 'images/characteristics/color-red-brown.png'
      new Value id: 'hornsStraight', label: translate('characteristicValues', 'hornsStraight'), image: 'images/characteristics/horns-straight.png'
      new Value id: 'hornsSimpleCurve', label: translate('characteristicValues', 'hornsSimpleCurve'), image: 'images/characteristics/horns-simple-curve.png'
      new Value id: 'hornsLyrate', label: translate('characteristicValues', 'hornsLyrate'), image: 'images/characteristics/horns-lyrate.png'
      new Value id: 'hornsCurly', label: translate('characteristicValues', 'hornsCurly'), image: 'images/characteristics/horns-curly.png'
    ]

  new Characteristic
    id: 'tail'
    label: translate 'characteristics', 'tail'
    values: [
      new Value id: 'tailBushy', label: translate('characteristicValues', 'tailBushy'), image: 'images/characteristics/tail-bushy.png'
      new Value id: 'tailSmooth', label: translate('characteristicValues', 'tailSmooth'), image: 'images/characteristics/tail-smooth.png'
      new Value id: 'tailTufted', label: translate('characteristicValues', 'tailTufted'), image: 'images/characteristics/tail-tufted.png'
      new Value id: 'tailLong', label: translate('characteristicValues', 'tailLong'), image: 'images/characteristics/tail-long.png'
      new Value id: 'tailShort', label: translate('characteristicValues', 'tailShort'), image: 'images/characteristics/tail-short.png'
    ]

  new Characteristic
    id: 'build'
    label: translate 'characteristics', 'build'
    values: [
      new Value id: 'buildStocky', label: translate('characteristicValues', 'buildStocky'), image: 'images/characteristics/build-stocky.png'
      new Value id: 'buildLanky', label: translate('characteristicValues', 'buildLanky'), image: 'images/characteristics/build-lanky.png'
      new Value id: 'buildTall', label: translate('characteristicValues', 'buildTall'), image: 'images/characteristics/build-tall.png'
      new Value id: 'buildSmall', label: translate('characteristicValues', 'buildSmall'), image: 'images/characteristics/build-small.png'
      new Value id: 'buildLowSlung', label: translate('characteristicValues', 'buildLowSlung'), image: 'images/characteristics/build-low-slung.png'
    ]

  new Characteristic
    id: 'back'
    label: translate 'characteristics', 'back'
    values: [
      new Value id: 'backSloped', label: translate('characteristicValues', 'backSloped'), image: 'images/characteristics/color-red-brown.png'
      new Value id: 'backRound', label: translate('characteristicValues', 'backRound'), image: 'images/characteristics/color-red-brown.png'
      new Value id: 'backStraight', label: translate('characteristicValues', 'backStraight'), image: 'images/characteristics/color-red-brown.png'
    ]
]
