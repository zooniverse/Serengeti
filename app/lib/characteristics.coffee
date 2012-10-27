Characteristic = require 'models/characteristic'
Value = Characteristic.Value
translate = require 'lib/translate'

# TODO: These should be a sprite.

module.exports = [
  new Characteristic
    id: 'like'
    label: translate 'characteristics.like'
    values: [
      new Value id: 'likeCatDog', label: translate 'characteristicValues.likeCatDog'
      new Value id: 'likeCowHorse', label: translate 'characteristicValues.likeCowHorse'
      new Value id: 'likeAntelopeDeer', label: translate 'characteristicValues.likeAntelopeDeer'
      new Value id: 'likeBird', label: translate 'characteristicValues.likeBird'
      new Value id: 'likeWeasel', label: translate 'characteristicValues.likeWeasel'
      new Value id: 'likeOther', label: translate 'characteristicValues.likeOther'
    ]

  new Characteristic
    id: 'pattern'
    label: translate 'characteristics.pattern'
    values: [
      new Value id: 'patternVerticalStripe', label: translate 'characteristicValues.patternVerticalStripe'
      new Value id: 'patternHorizontalStripe', label: translate 'characteristicValues.patternHorizontalStripe'
      new Value id: 'patternSpots', label: translate 'characteristicValues.patternSpots'
      new Value id: 'patternSolid', label: translate 'characteristicValues.patternSolid'
    ]

  new Characteristic
    id: 'coat'
    label: translate 'characteristics.coat'
    values: [
      new Value id: 'coatTanYellow', label: translate 'characteristicValues.coatTanYellow'
      new Value id: 'coatRedBrown', label: translate 'characteristicValues.coatRedBrown'
      new Value id: 'coatBrownBlack', label: translate 'characteristicValues.coatBrownBlack'
      new Value id: 'coatWhite', label: translate 'characteristicValues.coatWhite'
      new Value id: 'coatGray', label: translate 'characteristicValues.coatGray'
      new Value id: 'coatBlack', label: translate 'characteristicValues.coatBlack'
    ]

  new Characteristic
    id: 'horns'
    label: translate 'characteristics.horns'
    values: [
      new Value id: 'hornsStraight', label: translate 'characteristicValues.hornsStraight'
      new Value id: 'hornsSimpleCurve', label: translate 'characteristicValues.hornsSimpleCurve'
      new Value id: 'hornsLyrate', label: translate 'characteristicValues.hornsLyrate'
      new Value id: 'hornsCurly', label: translate 'characteristicValues.hornsCurly'
    ]

  new Characteristic
    id: 'tail'
    label: translate 'characteristics.tail'
    values: [
      new Value id: 'tailBushy', label: translate 'characteristicValues.tailBushy'
      new Value id: 'tailSmooth', label: translate 'characteristicValues.tailSmooth'
      new Value id: 'tailTufted', label: translate 'characteristicValues.tailTufted'
      new Value id: 'tailLong', label: translate 'characteristicValues.tailLong'
      new Value id: 'tailShort', label: translate 'characteristicValues.tailShort'
    ]

  new Characteristic
    id: 'build'
    label: translate 'characteristics.build'
    values: [
      new Value id: 'buildStocky', label: translate 'characteristicValues.buildStocky'
      new Value id: 'buildTall', label: translate 'characteristicValues.buildTall'
      new Value id: 'buildLanky', label: translate 'characteristicValues.buildLanky'
      new Value id: 'buildSmall', label: translate 'characteristicValues.buildSmall'
      new Value id: 'buildLowSlung', label: translate 'characteristicValues.buildLowSlung'
      # new Value id: 'buildSloped', label: translate 'characteristicValues.buildSloped'
    ]
]
