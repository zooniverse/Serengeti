columnize = (array, columns) ->
  square = array.length + (columns - (columns % array.length))
  perColumn = Math.ceil square / columns

  rowed = for i in [0...columns]
    start = i * perColumn
    array[start...start + perColumn]

  columned = for i in [0...perColumn]
    for column in [0...columns]
      rowed[column][i]

  flattened = []

  for column in columned then for item in column when item?
    flattened.push item

  flattened

module.exports = columnize
