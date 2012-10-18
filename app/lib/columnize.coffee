columnize = (array, columns) ->
  untouchedLength = array.length

  sorted = []

  while array.length > 0
    sorted.push array.shift()
    per = Math.floor array.length / columns
    array = array.splice(per).concat array
    console.log per, sorted, array

  sorted

module.exports = columnize
