{Controller} = require 'spine'
$ = require 'jqueryify'
template = require 'views/explore'
LoginForm = require 'zooniverse/lib/controllers/login_form'
User = require 'zooniverse/lib/models/user'
Map = require 'zooniverse/lib/map'
L = require 'zooniverse/vendor/leaflet/leaflet-src'
moment = require('moment/moment')
animals = require('lib/animals')

class Explore extends Controller
  className: 'explore'
  
  dateGranularity: 10
  cartoTable: 'serengeti_random'
  layers: []
  styles: ['#d32323', '#525b46']
  dateFmt: 'DD MMM YYYY, hh:mm A'
  
  maxCache: 10
  cache: []
  
  events:
    'change select.filter'      : 'onSpeciesSelect'
    'click input[name="scope"]' : 'setUserScope'
    'click button.species'      : 'onPickSpecies'
    'mouseleave .animals'       : 'hideAnimalMenu'
    'click div[data-animal]'    : 'onSpeciesSelect'
  
  elements:
    '.sign-in'    : 'signInContainer'
    'nav button'  : 'navButtons'
    '.page'       : 'pages'
    '.slider'     : 'dateSlider'
    '#community'  : 'community'
    '#my'         : 'my'
    '.animals'    : 'animalMenu'

  constructor: ->
    super
    
    @html template(animals)
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
      zoom: 11
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
  
  setUserScope: (e) ->
    @requestDateRange()
    @onSpeciesSelect()
  
  onPickSpecies: (e) =>
    @speciesIndex = e.target.dataset.index
    @animalMenu.addClass('active')
    position = if @speciesIndex is '1' then 'left' else 'right'
    @animalMenu.attr('data-position', position)
  
  hideAnimalMenu: =>
    @animalMenu.removeClass('active')
    @animalMenu.removeAttr('data-position')
  
  onDateRangeSelect: (e, ui) =>
    value = ui.value
    @requestSpecies(value, value + 1)
  
  onSpeciesSelect: (e) =>
    if e?
      species = e.target.innerText
      @["species#{@speciesIndex}"] = e.target.dataset.animal or ''
      # Swap text in button
      $("button.species[data-index='#{@speciesIndex}']").text(species)
      @hideAnimalMenu()
    
    value = @dateSlider.slider('option', 'value')
    @requestSpecies(value, value + 1)
  
  updateDateRange: =>
    n = @dateSlider.slider('option', 'value')
    start = @startDate.clone().add('ms', n * @interval).format(@dateFmt)
    end = @startDate.clone().add('ms', (n + 1) * @interval).format(@dateFmt)
    $('.map-container .map .dates').html("#{start} &mdash; #{end} (East Africa Time)")
  
  getQueryUrl: (query) ->
    url = encodeURI "http://the-zooniverse.cartodb.com/api/v2/sql?q=#{query}"
    return url.replace(/\+/g, '%2B')  # Must manually escape plus character (maybe others too)
  
  #
  # Methods for caching query results
  #
  
  createCacheKey: =>
    d   = @dateSlider.slider('option', 'value')
    sc  = $('input[name="scope"]:checked').val()
    return "#{@species1}_#{@species2}_#{d}_#{sc}"
  
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
  
  # Show spinner while waiting for response
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
      # .then(@requestSpecies)
      .fail( (e) -> alert 'Sorry, the query failed')
  
  # Request species counts for all sites between a date interval
  requestSpecies: =>
    start = @startDate.clone()
    end   = @startDate.clone()
    
    # Get start and end date and update ui
    n = @dateSlider.slider('option', 'value')
    start = @startDate.clone().add('ms', n * @interval).format(@dateFmt)
    end = @startDate.clone().add('ms', (n + 1) * @interval).format(@dateFmt)
    $('.map-container .map .dates').html("#{start} &mdash; #{end} (East Africa Time)")
    
    query = """
      SELECT ST_AsGeoJSON(the_geom) as the_geom, species, AVG(how_many), site_roll_code
      FROM serengeti_random
      WHERE (species = '#{@species1}' OR species = '#{@species2}')
      """
    if $('input[name="scope"]:checked').val() is 'my'
      query += " AND (user_id = '#{User.current.id}') "
    query +=
      """
      AND (captured_at BETWEEN '#{start}+02:00' AND '#{end}+02:00')
      GROUP BY the_geom, species, site_roll_code
      """
    
    url = @getQueryUrl(query)
    cacheKey = @createCacheKey()
    cachedResult = @getCachedResult(cacheKey)
    
    if cachedResult
      @getSpecies(cachedResult)
    else
      url = @getQueryUrl(query)
      do (cacheKey) =>
        $.ajax({url: url, beforeSend: @ajaxStart})
          .pipe( (response) ->
            rows = response.rows
            rows.map((d) -> d.the_geom = JSON.parse(d.the_geom))
            return rows
          )
          .pipe( (data) => @cacheResults(cacheKey, data))
          .pipe( (data) => @getSpecies(data))
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
    
    n = @dateSlider.slider('option', 'value')
    start = @startDate.clone().add('ms', n * @interval).format(@dateFmt)
    end = @startDate.clone().add('ms', (n + 1) * @interval).format(@dateFmt)
    $('.map-container .map .dates').html("#{start} &mdash; #{end} (East Africa Time)")
  
  getSpecies: (rows) =>
    
    cross = crossfilter(rows)
    dimensionOnSpecies = cross.dimension((d) -> return d.species)
    
    dimensionOnSpecies.filterExact(@species1)
    species1 = dimensionOnSpecies.top(Infinity)
    
    dimensionOnSpecies.filterExact(@species2)
    species2 = dimensionOnSpecies.top(Infinity)
    
    # Remove layers from map
    for layer in @layers
      @map.map.removeLayer(layer)
    @layers = []
    
    for species, index in [species1, species2]
      for row in species
        avg = row.avg
        [lng, lat] = row.the_geom.coordinates
        
        # Create two circles over each other
        outerCircle = L.circle([lat, lng], 200 * avg, {
          fillColor: @styles[index]
          fillOpacity: 0.01 * Math.exp(avg / 4)
          stroke: false
        })
        # innerCircle = L.circle([lat, lng], 100 * avg, {
        #   fillColor: @styles[index]
        #   fillOpacity: 0.25
        #   stroke: false
        # })
        
        @layers.push outerCircle
        # @layers.push innerCircle
        @map.map.addLayer(outerCircle)
        # @map.map.addLayer(innerCircle)
        
    # for species, index in [species1, species2]
    #   for row in species
    #     avg = row.avg
    #     [lng, lat] = row.the_geom.coordinates
    #     
    #     circle = L.circle([lat, lng], 10 * avg, {
    #         color: @styles[index]
    #         fillColor: @styles[index],
    #         fillOpacity: 0.5
    #     })
    #     @layers.push circle
    #     @map.map.addLayer(circle)


module.exports = Explore
