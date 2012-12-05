{Controller} = require 'spine'
$ = require 'jqueryify'
template = require 'views/explore'
LoginForm = require 'zooniverse/lib/controllers/login_form'
User = require 'zooniverse/lib/models/user'
Map = require 'zooniverse/lib/map'
L = require 'zooniverse/vendor/leaflet/leaflet-src'

class Explore extends Controller
  className: 'explore'
  apiKey: 'CARTO_API_KEY'
  dateGranularity: 10
  cartoTable: 'serengeti_copy'
  
  events:
    'change select.filter' : 'onSpeciesSelect'
  
  elements:
    '.sign-in'                        : 'signInContainer'
    'nav button'                      : 'navButtons'
    '.page'                           : 'pages'
    'select[data-filter="species1"]'  : 'species1'
    'select[data-filter="species2"]'  : 'species2'
    '.slider'                         : 'dateSlider'

  constructor: ->
    super
    
    @html template
    @loginForm = new LoginForm el: @signInContainer
    
    # User.bind 'sign-in', @onUserSignIn
    @requestSpeciesByDate(0, 1)
    
    # Set up slider (using jQueryUI for now ...)
    @dateSlider.slider({
      min: 0
      max: @dateGranularity - 1
      step: 1
      slide: @onDateRangeSelect
    })
    
    @map ?= new Map
      latitude: -2.332778
      longitude: 34.566667
      centerOffset: [0.25, 0.5]
      zoom: 9
      className: 'full-screen'
    
    @map.el.appendTo @el.find('.map-container')
    
    @navButtons.first().click()
    @onUserSignIn()
  
  onUserSignIn: =>
    @el.toggleClass 'signed-in', !!User.current
    
    if User.current
      @requestSpeciesByDate(0, 1)
  
  onDateRangeSelect: (e, ui) =>
    value = ui.value
    @requestSpeciesByDate(value, value + 1)
  
  onSpeciesSelect: =>
    value = @dateSlider.slider('option', 'value')
    @requestSpeciesByDate(value, value + 1)
  
  getQueryUrl: (query) ->
    url = encodeURI "http://the-zooniverse.cartodb.com/api/v2/sql?q=#{query}&api_key=#{@apiKey}"
    return url.replace(/\+/g, '%2B')  # Must manually escape plus character (maybe others too)
  
  requestQuery: (query, callback) =>
    if $('input[name="scope"]:checked').val() is 'single'
      query = @appendUserCondition(query)
    
    url = @getQueryUrl(query)
    $.ajax({url: url})
      .done(callback)
      .fail( (e) -> alert 'Sorry, the query failed')  # TODO: Fail more gracefully ...
  
  # Add user condition to query
  appendUserCondition: (query) =>
    from = "FROM #{@cartoTable}\nWHERE"
    index = query.indexOf(from)
    index += from.length
    base = query.substring(0, index)
    condition = query.substring(index)
    
    return "#{base} user_id = '#{User.current.id}' AND #{condition}"
  
  # Query for species for a given date range.  Parameters are integers between 0 and @dateGranularity.
  # The range of captured_at dates is segmented into @dateGranularity bins.
  requestSpeciesByDate: (lower, upper) =>
    species1 = @species1.val()
    species2 = @species2.val()
    
    query = """
      SELECT ST_AsGeoJSON(the_geom) as the_geom, species, AVG(how_many), site_roll_code
      FROM #{@cartoTable}
      WHERE species = '#{species1}' OR species = '#{species2}'
        AND captured_at BETWEEN (
          SELECT MIN(captured_at)
          FROM #{@cartoTable} ) + #{lower} * (
            SELECT (MAX(captured_at) - MIN(captured_at)) / 10
            FROM #{@cartoTable}) AND (SELECT MIN(captured_at) + #{upper} * (
              SELECT (MAX(captured_at) - MIN(captured_at)) / 10 FROM #{@cartoTable})
              FROM #{@cartoTable})
      GROUP BY the_geom, species, site_roll_code;
    """
    @requestQuery(query, @getSpeciesByDate)
  
  getSpeciesByDate: (response) =>
    rows = response.rows
    rows.map((d) -> d.the_geom = JSON.parse(d.the_geom))
    
    species1 = @species1.val()
    species2 = @species2.val()
    
    cross = crossfilter(response.rows)
    dimensionOnSpecies = cross.dimension((d) -> return d.species)
    
    dimensionOnSpecies.filterExact(species1)
    species1 = dimensionOnSpecies.top(Infinity)
    
    dimensionOnSpecies.filterExact(species2)
    species2 = dimensionOnSpecies.top(Infinity)
    
    console.log species1, species2
    
    # Remove layers from map
    for layer in @map.map._layers
      @map.map.removeLayer(layer)
    
    for species, index in [species1, species2]
      for row in species
        avg = row.avg
        [lng, lat] = row.the_geom.coordinates
        
        circle = L.circle([lat, lng], 4 * avg, {
            color: if index is 0 then 'red' else 'blue',
            fillColor: '#f03',
            fillOpacity: 0.5
        })
        @map.map.addLayer(circle)


module.exports = Explore
