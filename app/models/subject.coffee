{Model} = require 'spine'

class Subject extends Model
  @configure 'Subject', 'zooniverseId', 'location', 'coords', 'metadata'

  @toClassify = []

  select: ->
    @trigger 'select'

  satelliteImage: -> """
    //maps.googleapis.com/maps/api/staticmap
    ?center=#{@coords.join ','}
    &zoom=17
    &size=565x380
    &maptype=hybrid
    &markers=size:tiny|#{@coords.join ','}
    &sensor=false
  """.replace '\n', ''

module.exports = Subject
