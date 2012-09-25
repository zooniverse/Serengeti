Characteristic = require 'models/characteristic'
Value = Characteristic.Value

module.exports = [
  new Characteristic
    id: 'face'
    values: [
      new Value id: 'faceShort', image: '//placehold.it/50.png'
      new Value id: 'faceLong', image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'back'
    values: [
      new Value id: 'backFlat', image: '//placehold.it/50.png'
      new Value id: 'backRound', image: '//placehold.it/50.png'
    ]

  new Characteristic
    id: 'coat'
    values: [
      new Value id: 'coatShort', image: '//placehold.it/50.png'
      new Value id: 'coatLong', image: '//placehold.it/50.png'
    ]
]
