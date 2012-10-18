columnize = (array, columns) ->
  until array.length is 0
    item = array.shift()
    perColumn = Math.floor array.length / columns
    array = array.splice(perColumn).concat array
    item

module.exports = columnize
