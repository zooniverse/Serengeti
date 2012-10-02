Characteristic = require 'models/characteristic'
Value = Characteristic.Value

module.exports = [
  new Characteristic
    id: 'like'
    values: [
      new Value id: 'likeCatDog', image: '//placehold.it/50.png'
      new Value id: 'likeCowHorse', image: '//placehold.it/50.png'
      new Value id: 'likeAntelopeDeer', image: '//placehold.it/50.png'
      new Value id: 'likeBird', image: '//placehold.it/50.png'
      new Value id: 'likeWeasel', image: '//placehold.it/50.png'
      new Value id: 'likeOther', image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'pattern'
    values: [
      new Value id: 'patternVerticalStripe', image: '//placehold.it/50.png'
      new Value id: 'patternHorizontalStripe', image: '//placehold.it/50.png'
      new Value id: 'patternSpots', image: '//placehold.it/50.png'
      new Value id: 'patternSolid', image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'coat'
    values: [
      new Value id: 'coatTanYellow', image: '//placehold.it/50.png'
      new Value id: 'coatOrange', image: '//placehold.it/50.png'
      new Value id: 'coatRedBrown', image: '//placehold.it/50.png'
      new Value id: 'coatBrownBlack', image: '//placehold.it/50.png'
      new Value id: 'coatWhite', image: '//placehold.it/50.png'
      new Value id: 'coatGray', image: '//placehold.it/50.png'
      new Value id: 'coatBlack', image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'horns'
    values: [
      new Value id: 'hornsNone', image: '//placehold.it/50.png'
      new Value id: 'hornsStraight', image: '//placehold.it/50.png'
      new Value id: 'hornsSimpleCurve', image: '//placehold.it/50.png'
      new Value id: 'hornsLyrate', image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'tail'
    values: [
      new Value id: 'tailCurly', image: '//placehold.it/50.png'
      new Value id: 'tailBushy', image: '//placehold.it/50.png'
      new Value id: 'tailSmooth', image: '//placehold.it/50.png'
      new Value id: 'tailTufted', image: '//placehold.it/50.png'
      new Value id: 'tailLong', image: '//placehold.it/50.png'
      new Value id: 'tailShort', image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'build'
    values: [
      new Value id: 'buildStocky', image: '//placehold.it/50.png'
      new Value id: 'buildLanky', image: '//placehold.it/50.png'
      new Value id: 'buildTall', image: '//placehold.it/50.png'
      new Value id: 'buildSmall', image: '//placehold.it/50.png'
      new Value id: 'buildLowSlung', image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'back'
    values: [
      new Value id: 'backSloped', image: '//placehold.it/50.png'
      new Value id: 'backRound', image: '//placehold.it/50.png'
      new Value id: 'backStraight', image: '//placehold.it/50.png'
    ]
]
