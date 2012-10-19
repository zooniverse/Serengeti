modulus = (a, b) ->
  ((a % b) + b) % b

module.exports = modulus
