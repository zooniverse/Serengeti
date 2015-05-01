{Controller} = require 'spine'
$ = require 'jqueryify'
template = require '../views/explore'
LoginForm = require 'zooniverse/lib/controllers/login_form'
User = require 'zooniverse/lib/models/user'
Map = require 'zooniverse/lib/map'
L = require 'zooniverse/vendor/leaflet/leaflet-src'
moment = require('moment/moment')
animals = require('../lib/animals')


class Explore extends Controller
  className: 'explore'
  
  dateGranularity: 100
  cartoTable: 'serengeti'
  layers: []
  styles: ['#D32323', '#525B46']
  dateFmt: 'DD MMM YYYY'
  
  maxCache: 100
  cache: []
  
  events:
    'click input[name="scope"]' : 'setUserScope'
    'click button.species'      : 'showAnimalMenu'
    'click div[data-animal]'    : 'setSpecies'
    'mouseleave .animals'       : 'hideAnimalMenu'
    'change .legend input'      : 'toggleLayer'
  
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
    
    # Set date range
    @startDate  = moment('01 Jun 2010, 00:00 PM')
    endDate     = moment('01 Jan 2012, 00:00 PM')
    @interval   = endDate.diff(@startDate) / @dateGranularity
    
    # Important to set empty strings for species
    @species1 = @species2 = ''
    
    @initUI()
    # @initCartoDBLayer()
    
    @navButtons.first().click()
    @onUserSignIn()
  
  onUserSignIn: =>
    @el.toggleClass 'signed-in', !!User.current
    
    if User.current
      @my.removeAttr('disabled')
    else
      @community.attr('checked', 'checked')
      @my.attr('disabled', 'disabled')
      
  initUI: =>
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
    
    # Set bounds for the map
    southWest = new L.LatLng(-3, 34)
    northEast = new L.LatLng(-2, 36)
    bounds = new L.LatLngBounds(southWest, northEast)
    @map.map.setMaxBounds(bounds)
    @map.el.appendTo @el.find('.map-container')
    
    # Create a custom layer
    @terrainLayer = L.tileLayer("http://www.snapshotserengeti.org.s3.amazonaws.com/tiles/{z}/{x}/{y}.png",
      minZoom: 7
      maxZoom: 12
      attribution: 'Natural Earth (http://www.naturalearthdata.com/)'
      noWrap: true
    )
    @terrainLayer.addTo @map.map
    
    # Containers for plot points
    @markerLayer1 = new L.LayerGroup()
    @markerLayer2 = new L.LayerGroup()
    
    @markerLayer1.addTo(@map.map)
    @markerLayer2.addTo(@map.map)
    
    # Append div for showing date range
    @el.find('.map-container .map').prepend("<div class='dates'></div>")
    @dateEl = @el.find('.map-container .map .dates')
    
    # Create legend
    @el.find('.map-container .map').prepend("<div class='legend'></div>")
    @legendEl = @el.find('.map-container .map .legend')
    @legendEl.append("<span class='animal-name' data-index='1'></span><input type='checkbox' checked='true' id='layer1' data-index='1' /><label for='layer1'></label><br/>")
    @legendEl.append("<span class='animal-name' data-index='2'></span><input type='checkbox' checked='true' id='layer2' data-index='2' /><label for='layer2'></label>")
  
  initCartoDBLayer: =>
    query1 = "WITH hgrid AS (SELECT CDB_HexagonGrid(ST_Expand(CDB_XYZ_Extent({x},{y},{z}),CDB_XYZ_Resolution({z}) * 15),CDB_XYZ_Resolution({z}) * 15 ) as cell) SELECT hgrid.cell as the_geom_webmercator, avg(i.how_many) as prop_count FROM hgrid, serengeti i WHERE i.species = 'zebra' AND ST_Intersects(i.the_geom_webmercator, hgrid.cell) GROUP BY hgrid.cell"
    query2 = "WITH hgrid AS (SELECT CDB_HexagonGrid(ST_Expand(CDB_XYZ_Extent({x},{y},{z}),CDB_XYZ_Resolution({z}) * 15),CDB_XYZ_Resolution({z}) * 15 ) as cell) SELECT hgrid.cell as the_geom_webmercator, avg(i.how_many) as prop_count FROM hgrid, serengeti i WHERE i.species = 'lionFemale' AND ST_Intersects(i.the_geom_webmercator, hgrid.cell) GROUP BY hgrid.cell"
    
    style1 = '''
      #serengeti {
        polygon-opacity:0.6;
        line-color: #FFF;
        line-opacity: 0.7;
        line-width: 1;
        [prop_count < 1.5] {polygon-fill:#FFF7F3;}
        [prop_count < 2.0] {polygon-fill:#FDE0DD;}
        [prop_count < 2.5] {polygon-fill:#FCC5C0;}
        [prop_count < 3.0] {polygon-fill:#FA9FB5;}
        [prop_count < 3.5] {polygon-fill:#F768A1;}
        [prop_count < 4.0] {polygon-fill:#DD3497;}
        [prop_count < 4.5] {polygon-fill:#AE017E;}
        [prop_count < 5.0] {polygon-fill:#7A0177;}
        [prop_count > 5.0] {polygon-fill:#49006A;}
      }
    '''
    
    style2 = '''
      #serengeti {
        polygon-opacity:0.4;
        line-color: #FFF;
        line-opacity: 0.7;
        line-width: 1;
        [prop_count<1.5] {polygon-fill:#F0F9E8;}
        [prop_count<3.0] {polygon-fill:#BAE4BC;}
        [prop_count<4.5] {polygon-fill:#7BCCC4;}
        [prop_count<6.0] {polygon-fill:#43A2CA;}
        [prop_count>6.0] {polygon-fill:#0868AC;}
      }
    '''
    
    @cartoLayer1 = new L.CartoDBLayer({
      map: @map.map
      user_name: 'the-zooniverse'
      table_name: @cartoTable
      infowindow: false
      tile_style: style1
      query: query1
      interactivity: false
      auto_bound: false
      debug: false
    })
    @cartoLayer2 = new L.CartoDBLayer({
      map: @map.map
      user_name: 'the-zooniverse'
      table_name: @cartoTable
      infowindow: false
      tile_style: style2
      query: query2
      interactivity: false
      auto_bound: false
      debug: false
    })
    @map.map.addLayer(@cartoLayer1)
    @map.map.addLayer(@cartoLayer2)
  
  setUserScope: -> @setSpecies()
  
  toggleLayer: (e) =>
    index = e.target?.dataset.index or e
    fill = @styles[index - 1]
    items = @el[0].querySelectorAll("svg g path[fill='#{fill}']")
    state = if @el.find("#layer#{index}:checked").length is 0 then 'none' else 'block'
    
    for item in items
      item.style.display = state
  
  showAnimalMenu: (e) =>
    index = e.target.dataset.index
    @animalMenu.attr('data-index', index)
    @animalMenu.addClass('active')
  
  hideAnimalMenu: =>
    @animalMenu.removeClass('active')
    @animalMenu.removeAttr('data-position')
  
  onDateRangeSelect: (e, ui) =>
    value = ui.value
    @requestSpecies(value, value + 1)
  
  setSpecies: (e) =>
    if e?
      @hideAnimalMenu()
      
      target = e.target
      species = target.textContent or target.innerText
      index = target.parentElement.dataset.index or target.parentElement.parentElement.dataset.index
      
      @["species#{index}"] = target.dataset.animal or target.parentElement.dataset.animal
      
      # Swap text in button
      $("button.species[data-index='#{index}']").text(species)
      $("span.animal-name[data-index='#{index}']").text(species)
      @el.find('.legend').css('opacity', 1)
      
    value = @dateSlider.slider('option', 'value')
    @requestSpecies(value, value + 1)
    # @updateCartoQuery(index, @["species#{index}"], value)
  
  updateDateRange: =>
    n = @dateSlider.slider('option', 'value')
    start = @startDate.clone().add('ms', n * @interval).format(@dateFmt)
    end = @startDate.clone().add('ms', (n + 1) * @interval).format(@dateFmt)
    $('.map-container .map .dates').html("#{start} &mdash; #{end}")
  
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
    $(".map-container .map").append("<img src='/images/spinner.gif' class='spinner'>")
  ajaxStop: ->
    $(".map-container .map img.spinner").remove()
  
  #
  # Methods for querying CartoDB
  #
  
  updateCartoQuery: (index, species, startTimeIndex) =>
    query = "WITH hgrid AS (SELECT CDB_HexagonGrid(ST_Expand(CDB_XYZ_Extent({x},{y},{z}),CDB_XYZ_Resolution({z}) * 15),CDB_XYZ_Resolution({z}) * 15 ) as cell) SELECT hgrid.cell as the_geom_webmercator, avg(i.how_many) as prop_count FROM hgrid, serengeti i WHERE i.species = '#{species}' AND ST_Intersects(i.the_geom_webmercator, hgrid.cell) GROUP BY hgrid.cell"
    
    @["cartoLayer#{index}"].setQuery(query)
  
  # Request species counts for all sites between a date interval
  requestSpecies: (n1, n2) =>
    start = @startDate.clone()
    end   = @startDate.clone()
    
    # Get start and end date and update ui
    start = @startDate.clone().add('ms', n1 * @interval).format(@dateFmt)
    end = @startDate.clone().add('ms', n2 * @interval).format(@dateFmt)
    $('.map-container .map .dates').html("#{start} &mdash; #{end}")
    
    query = """
      SELECT ST_AsGeoJSON(the_geom) as the_geom, species, AVG(how_many)
      FROM #{@cartoTable}
      WHERE (species = '#{@species1}' OR species = '#{@species2}')
      """
    if $('input[name="scope"]:checked').val() is 'my'
      query += " AND (user_id = '#{User.current.id}') "
    query +=
      """
       AND (captured_at BETWEEN '#{start}+02:00' AND '#{end}+02:00')
      GROUP BY the_geom, species
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
            response = JSON.parse(response) # Need to parse the JSON for FF to work
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
  
  getSpecies: (rows) =>
    cross = crossfilter(rows)
    dimensionOnSpecies = cross.dimension((d) -> return d.species)
    
    dimensionOnSpecies.filterExact(@species1)
    species1 = dimensionOnSpecies.top(Infinity)
    
    dimensionOnSpecies.filterExact(@species2)
    species2 = dimensionOnSpecies.top(Infinity)
    
    # Remove layers from map
    @markerLayer1.clearLayers()
    @markerLayer2.clearLayers()
    
    for species, index in [species1, species2]
      for row in species
        avg = row.avg
        [lng, lat] = row.the_geom.coordinates
        
        circle = L.circle([lat, lng], @getRadius(avg), {
          fillColor: @styles[index]
          fillOpacity: @getOpacity(avg)
          stroke: false
        })
        
        @["markerLayer#{index + 1}"].addLayer(circle)
      
      @toggleLayer(index)
    
  getRadius: (x) -> return 1400 * x / Math.sqrt(30 + x * x)
  getOpacity: (x) -> return (0.7 * x / Math.sqrt(5 + x * x))
  
module.exports = Explore
