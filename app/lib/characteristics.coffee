Characteristic = require 'models/characteristic'
Value = Characteristic.Value
translate = require 't7e'

# TODO: These should be a sprite.

module.exports = [
  new Characteristic
    id: 'like'
    label: translate {span: 'characteristics.like'}
    values: [
      new Value id: 'likeCatDog', label: translate {span: 'characteristicValues.likeCatDog'}
      new Value id: 'likeCowHorse', label: translate {span: 'characteristicValues.likeCowHorse'}
      new Value id: 'likeAntelopeDeer', label: translate {span: 'characteristicValues.likeAntelopeDeer'}
      new Value id: 'likeBird', label: translate {span: 'characteristicValues.likeBird'}
      new Value id: 'likeWeasel', label: translate {span: 'characteristicValues.likeWeasel'}
      new Value id: 'likeOther', label: translate {span: 'characteristicValues.likeOther'}
    ]

  new Characteristic
    id: 'pattern'
    label: translate {span: 'characteristics.pattern'}
    values: [
      new Value id: 'patternVerticalStripe', label: translate {span: 'characteristicValues.patternVerticalStripe'}
      new Value id: 'patternHorizontalStripe', label: translate {span: 'characteristicValues.patternHorizontalStripe'}
      new Value id: 'patternSpots', label: translate {span: 'characteristicValues.patternSpots'}
      new Value id: 'patternSolid', label: translate {span: 'characteristicValues.patternSolid'}
    ]

  new Characteristic
    id: 'coat'
    label: translate {span: 'characteristics.coat'}
    values: [
      new Value id: 'coatTanYellow', label: translate {span: 'characteristicValues.coatTanYellow'}
      new Value id: 'coatRedBrown', label: translate {span: 'characteristicValues.coatRedBrown'}
      new Value id: 'coatBrownBlack', label: translate {span: 'characteristicValues.coatBrownBlack'}
      new Value id: 'coatWhite', label: translate {span: 'characteristicValues.coatWhite'}
      new Value id: 'coatGray', label: translate {span: 'characteristicValues.coatGray'}
      new Value id: 'coatBlack', label: translate {span: 'characteristicValues.coatBlack'}
    ]

  new Characteristic
    id: 'horns'
    label: translate {span: 'characteristics.horns'}
    values: [
      new Value id: 'hornsStraight', label: translate {span: 'characteristicValues.hornsStraight'}
      new Value id: 'hornsSimpleCurve', label: translate {span: 'characteristicValues.hornsSimpleCurve'}
      new Value id: 'hornsLyrate', label: translate {span: 'characteristicValues.hornsLyrate'}
      new Value id: 'hornsCurly', label: translate {span: 'characteristicValues.hornsCurly'}
    ]

  new Characteristic
    id: 'tail'
    label: translate {span: 'characteristics.tail'}
    values: [
      new Value id: 'tailBushy', label: translate {span: 'characteristicValues.tailBushy'}
      new Value id: 'tailSmooth', label: translate {span: 'characteristicValues.tailSmooth'}
      new Value id: 'tailTufted', label: translate {span: 'characteristicValues.tailTufted'}
      new Value id: 'tailLong', label: translate {span: 'characteristicValues.tailLong'}
      new Value id: 'tailShort', label: translate {span: 'characteristicValues.tailShort'}
    ]

  new Characteristic
    id: 'build'
    label: translate {span: 'characteristics.build'}
    values: [
      new Value id: 'buildStocky', label: translate {span: 'characteristicValues.buildStocky'}
      new Value id: 'buildTall', label: translate {span: 'characteristicValues.buildTall'}
      new Value id: 'buildLanky', label: translate {span: 'characteristicValues.buildLanky'}
      new Value id: 'buildSmall', label: translate {span: 'characteristicValues.buildSmall'}
      new Value id: 'buildLowSlung', label: translate {span: 'characteristicValues.buildLowSlung'}
      # new Value id: 'buildSloped', label: translate {span: 'characteristicValues.buildSloped'}
    ]
]
