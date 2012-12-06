{Controller} = require 'spine'
$ = require 'jqueryify'
template = require 'views/explore'
LoginForm = require 'zooniverse/lib/controllers/login_form'
User = require 'zooniverse/lib/models/user'
Map = require 'zooniverse/lib/map'
L = require 'zooniverse/vendor/leaflet/leaflet-src'
moment = require('moment/moment')

class Explore extends Controller
  className: 'explore'
  dateGranularity: 10
  cartoTable: 'serengeti_random'
  layers: []
  styles: ['#A34E20', '#1F3036']
  dateFmt: 'dddd, MMMM Do YYYY, h:mm:ss a'
  
  maxCache: 10
  cache: []
  
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
    
    User.bind 'sign-in', @onUserSignIn

    # Set up slider (using jQueryUI for now ...)
    @dateSlider.slider({
      min: 0
      max: @dateGranularity - 1
      step: 1
      change: @onDateRangeSelect
    })
    
    @map ?= new Map
      latitude: -2.51
      longitude: 34.93
      centerOffset: [0, 0]
      zoom: 11
      className: 'full-screen'
    
    @map.el.appendTo @el.find('.map-container')
    
    @navButtons.first().click()
    @onUserSignIn()
    
    @map ?= new Map
      latitude: -2.332778
      longitude: 34.566667
      centerOffset: [0.25, 0.5]
      zoom: 8
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
    
    # Create a unique key for the query
    species1  = @species1.val()
    species2  = @species2.val()
    date      = @dateSlider.slider('option', 'value')
    scope     = $('input[name="scope"]:checked').val()
    key = "#{species1}_#{species2}_#{date}_#{scope}"
    
    # Check if query results are cached
    cachedQuery = @getCachedQuery(key)
    
    if cachedQuery
      callback(cachedQuery)
    else
      url = @getQueryUrl(query)
      do (key) =>
        $.ajax({url: url})
          .pipe( (response) ->
            rows = response.rows
            rows.map((d) -> d.the_geom = JSON.parse(d.the_geom))
            return rows
          )
          .pipe( (data) => @cacheResults(key, data))
          .pipe( (data) -> callback(data))
          .fail( (e) -> alert 'Sorry, the query failed')  # TODO: Fail more gracefully ...
  
  getQueryUrl: (query) ->
    url = encodeURI "http://the-zooniverse.cartodb.com/api/v2/sql?q=#{query}"
    return url.replace(/\+/g, '%2B')  # Must manually escape plus character (maybe others too)
  
  cacheResults: (key, response) ->
    @cache.shift() if @cache.length is @maxCache
    obj = {}
    obj[key] = response
    @cache.push obj
    return response
  
  getCachedQuery: (key) ->
    for result in @cache
      if result.hasOwnProperty(key)
        return result[key]
    return false
  
  # Add user condition to query
  appendUserCondition: (query) =>
    from = "FROM #{@cartoTable}\nWHERE"
    index = query.indexOf(from)
    index += from.length
    base = query.substring(0, index)
    condition = query.substring(index)
    
    return "#{base} user_id = '#{User.current.id}' AND #{condition}"
  
  #
  # Methods for querying CartoDB
  #
  
  requestDateRange: =>
    console.log 'requestDateRange'
    query = "SELECT MIN(captured_at), MAX(captured_at) FROM #{@cartoTable};"
    @requestQuery(query, @getDateRange)
  
  #
  # Methods for receiving query results from CartoDB
  #
  
  getDateRange: (response) =>
    result = response.rows[0]
    @startDate  = moment(result.min)
    @endDate    = moment(result.max)
    console.log @startDate.format(@dateFmt), @endDate.format(@dateFmt)
  
  
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
  
  getSpeciesByDate: (rows) =>
    
    species1 = @species1.val()
    species2 = @species2.val()
    
    cross = crossfilter(rows)
    dimensionOnSpecies = cross.dimension((d) -> return d.species)
    
    dimensionOnSpecies.filterExact(species1)
    species1 = dimensionOnSpecies.top(Infinity)
    
    dimensionOnSpecies.filterExact(species2)
    species2 = dimensionOnSpecies.top(Infinity)
    
    # Remove layers from map
    for layer in @layers
      @map.map.removeLayer(layer)
    @layers = []
    
    for species, index in [species1, species2]
      for row in species
        avg = row.avg
        [lng, lat] = row.the_geom.coordinates
        
        circle = L.circle([lat, lng], 10 * avg, {
            color: @styles[index]
            fillColor: @styles[index],
            fillOpacity: 0.5
        })
        @layers.push circle
        @map.map.addLayer(circle)


module.exports = Explore
