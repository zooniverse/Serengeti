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
  dateFmt: 'ddd, MMM DD YYYY, hh:mm:ss A'
  
  maxCache: 10
  cache: []
  
  events:
    'change select.filter'      : 'onSpeciesSelect'
    'click input[name="scope"]' : 'setUserScope'
  
  elements:
    '.sign-in'                        : 'signInContainer'
    'nav button'                      : 'navButtons'
    '.page'                           : 'pages'
    'select[data-filter="species1"]'  : 'species1'
    'select[data-filter="species2"]'  : 'species2'
    '.slider'                         : 'dateSlider'
    '#community'                      : 'community'
    '#my'                             : 'my'

  constructor: ->
    super
    
    @html template
    @loginForm = new LoginForm el: @signInContainer
    
    # Set default state for user scope buttons
    User.bind 'sign-in', @onUserSignIn

    # Set up slider and map
    @dateSlider.slider({
      min: 0
      max: @dateGranularity - 1
      step: 1
      slide: @onDateRangeSelect
    })
    
    @map ?= new Map
      latitude: -2.51
      longitude: 34.93
      centerOffset: [0, 0]
      zoom: 9
      className: 'full-screen'
    @map.el.appendTo @el.find('.map-container')
    
    # Append div for showing date range
    @el.find('.map-container .map').prepend("<div class='dates'></div>")
    @dateEl = @el.find('.map-container .map .dates')
    
    @navButtons.first().click()
    @onUserSignIn()

  onUserSignIn: =>
    @el.toggleClass 'signed-in', !!User.current
    
    # Enable 'My Classifications'
    @my.removeAttr('disabled')
    if User.current
      @requestDateRange()
      # @requestSpecies(0, 1)
  
  setUserScope: (e) -> @requestDateRange()
  
  onDateRangeSelect: (e, ui) =>
    value = ui.value
    @requestSpecies(value, value + 1)
  
  onSpeciesSelect: =>
    value = @dateSlider.slider('option', 'value')
    @requestSpecies(value, value + 1)
  
  getQueryUrl: (query) ->
    url = encodeURI "http://the-zooniverse.cartodb.com/api/v2/sql?q=#{query}"
    return url.replace(/\+/g, '%2B')  # Must manually escape plus character (maybe others too)
  
  #
  # Methods for caching query results
  #
  
  createCacheKey: =>
    s1  = @species1.val()
    s2  = @species2.val()
    d   = @dateSlider.slider('option', 'value')
    sc  = $('input[name="scope"]:checked').val()
    return "#{s1}_#{s2}_#{d}_#{sc}"
  
  # Store results from a query
  cacheResults: (key, response) ->
    @cache.shift() if @cache.length is @maxCache
    obj = {}
    obj[key] = response
    @cache.push obj
    return response

  # Get results from a cached query
  getCachedResult: (key) ->
    for result in @cache
      if result.hasOwnProperty(key)
        return result[key]
    return false
  
  requestQuery: (query, callback) =>
    cacheKey = @createCacheKey()
    cachedResult = @getCachedResult(key)
    
    if cachedQuery
      callback(cachedQuery)
    else
      url = @getQueryUrl(query)
      do (key) =>
        $.ajax({url: url, beforeSend: @ajaxStart})
          .pipe( (response) ->
            rows = response.rows
            rows.map((d) -> d.the_geom = JSON.parse(d.the_geom))
            return rows
          )
          .pipe( (data) => @cacheResults(key, data))
          .pipe( (data) -> callback(data))
          .pipe( => @ajaxStop())
          .fail( (e) -> alert 'Sorry, the query failed')  # TODO: Fail more gracefully ...
  
  ajaxStart: ->
    $(".map-container .map").append("<img src='images/spinner.gif' class='spinner'>")
  ajaxStop: ->
    $(".map-container .map img.spinner").remove()
  
  #
  # Methods for querying CartoDB
  #
  
  # Request the minimum and maximum dates of image capture
  requestDateRange: =>
    query = "SELECT MIN(captured_at), MAX(captured_at) FROM #{@cartoTable}"
    if $('input[name="scope"]:checked').val() is 'my'
      query += " WHERE user_id = '#{User.current.id}'"
    
    url = @getQueryUrl(query)
    $.ajax({url: url, beforeSend: @ajaxStart})
      .done(@getDateRange)
      .then(@ajaxStop)
      .fail( (e) -> alert 'Sorry, the query failed')
  
  # Request species counts for all sites between a date interval
  requestSpecies: (lower, upper) =>
    start = @startDate.clone()
    end   = @startDate.clone()
    
    start.add('ms', lower * @interval)
    end.add('ms', upper * @interval)
    @dateEl.html("#{start.format(@dateFmt)} &mdash; #{end.format(@dateFmt)} (East Africa Time)")
    
    species1 = @species1.val()
    species2 = @species2.val()
    
    query = """SELECT ST_AsGeoJSON(the_geom) as the_geom, species, AVG(how_many), site_roll_code
      FROM #{@cartoTable}
      WHERE species = '#{species1}' OR species = '#{species2}'
      AND captured_at BETWEEN '#{start.format(@dateFmt)}+02:00' AND '#{end.format(@dateFmt)}+02:00'
    """
    if $('input[name="scope"]:checked').val() is 'my'
      query += "AND WHERE user_id = '#{User.current.id}'"
    query += " GROUP BY the_geom, species, site_roll_code"
    
    url = @getQueryUrl(query)
    cacheKey = @createCacheKey()
    cachedResult = @getCachedResult(key)
    
    if cachedResult
      @getSpecies(cachedQuery)
    else
      url = @getQueryUrl(query)
      do (key) =>
        $.ajax({url: url, beforeSend: @ajaxStart})
          .pipe( (response) ->
            rows = response.rows
            rows.map((d) -> d.the_geom = JSON.parse(d.the_geom))
            return rows
          )
          .pipe( (data) => @cacheResults(key, data))
          .pipe( (data) -> @getSpecies(data))
          .pipe( => @ajaxStop())
          .fail( (e) -> alert 'Sorry, the query failed')  # TODO: Fail more gracefully ...
  
  #
  # Methods for receiving query results from CartoDB
  #
  
  getDateRange: (response) =>
    result = response.rows[0]
    
    @startDate  = moment(result.min)
    endDate     = moment(result.max)
    @interval   = endDate.diff(@startDate) / @dateGranularity
    
    # Clone because object mutable
    start = @startDate.clone()
    $('.map-container .map .dates').html("#{start.format(@dateFmt)} &mdash; #{start.add('ms', @interval).format(@dateFmt)} (East Africa Time)")
  
  getSpecies: (rows) =>
    
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
