{Controller} = require 'spine'
$ = require 'jqueryify'
template = require 'views/explore'
LoginForm = require 'zooniverse/lib/controllers/login_form'
User = require 'zooniverse/lib/models/user'
Map = require 'zooniverse/lib/map'

class Explore extends Controller
  className: 'explore'
  apiKey: 'CARTO_API_KEY'
  
  events:
    'change select[data-filter="species"]' : 'onSpeciesSelect'
  
  elements:
    '.sign-in': 'signInContainer'
    'nav button': 'navButtons'
    '.page': 'pages'

  constructor: ->
    super

    @html template
    @loginForm = new LoginForm el: @signInContainer

    User.bind 'sign-in', @onUserSignIn

    @navButtons.first().click()
    @onUserSignIn()
    
    @map ?= new Map
      latitude: 2.33
      longitude: 35
      centerOffset: [0.25, 0.5]
      zoom: 8
      className: 'full-screen'

    @map.el.prependTo @el
    
    # Fake coordinates for sites (lat, lng)
    @mockCoordinates =
      S1_P07_R1: [2, 35]
      S1_D04_R6: [2.5, 35]
      S1_L03_R1: [3, 35]
      S1_D04_R1: [2, 35.5]
      S1_D04_R4: [2.5, 35.5]
      S1_D04_R2: [3, 35.5]
      S1_D04_R5: [2, 36]
      S1_D04_R3: [2.5, 36]
    
    @bind 'dataReady', @plotSiteRolls

  onUserSignIn: =>
    @el.toggleClass 'signed-in', !!User.current

    if User.current
      @requestSpeciesCountsBySiteRoll()
      # @requestClassifications()
      
  queryUrl: (query) ->
    encodeURI "http://the-zooniverse.cartodb.com/api/v2/sql?q=#{query}&api_key=#{@apiKey}"
  
  requestQuery: (query, callback) =>
    url = @queryUrl(query)
    
    $.ajax({url: url})
      .done(callback)
      .fail( (e) -> alert 'Sorry, the query failed')
  
  # Query for species counts
  requestSpeciesCountsBySiteRoll: =>
    query = "SELECT species, site_roll_code, count(species) FROM serengeti GROUP BY species, site_roll_code"
    @requestQuery(query, @getSpeciesCountsBySiteRoll)
  
  getSpeciesCountsBySiteRoll: (response) =>
    
    # Set up helper functions for these data
    speciesCount    = crossfilter(response.rows)
    bySite          = speciesCount.dimension((d) -> d.site_roll_code)
    bySpecies       = speciesCount.dimension((d) -> d.species)
    groupBySite     = bySite.group()
    groupBySpecies  = bySpecies.group()
    sortBySpecies   = crossfilter.quicksort.by((d) -> d.species)
    
    # Get a list of species
    speciesList = groupBySpecies.top(Infinity).map((d) -> d.key).sort()
    
    # Built a select field
    options = "<option value=''>filter by species</option>"
    for species in speciesList
      options += "<option value='#{species}'>#{species.replace(/([A-Z])/g, " $1")}</option>"
    
    el = @el.find("select[data-filter='species']")
    el.append(options)
    
    # Get list of sites
    sites = groupBySite.top(Infinity).map((d) -> d.key)
    @siteLabels = []
    
    for site in sites
      # Filter by site roll
      bySite.filterExact(site)
      
      # Get the data
      top = bySite.top(Infinity)
      
      # Reduce by count attribute
      count = top.reduce((a, b) ->
        b.count += a.count
        return b
      ).count
      
      # Sort the data by species
      data = sortBySpecies(top, 0, top.length)
      
      # Get the mock coordinates
      [lat, lng] = @mockCoordinates[site]
      
      content = ""
      label = @map.addLabel(lat, lng, "<p>#{site}</p>", radius = 10)
      label.data = data
      @siteLabels.push label
      label.on('mouseover', @onSiteMouseOver)

  onSiteMouseOver: (e) =>
    label = e.target
    data = label.data
    for datum in data
      console.log datum.species, datum.count
  
  onSpeciesSelect: (e) =>
    
    # TODO: Create a new map layer
    
    for label in @map.labels
      @map.removeLayer label
    
    species = e.target.value
    for label in @siteLabels
      data = label.data
      for item in data
        if item.species is species
          [lat, lng] = @mockCoordinates[item.site_roll_code]
          @map.addLabel(lat, lng, "", radius = item.count / 20)
  
  requestClassifications: =>
    fields = [
      'babies', 'behavior', 'captured_at', 'created_at', 'how_many', 'site_roll_code',
      'species', 'ST_AsGeoJSON(the_geom) as the_geom', 'updated_at', 'subject_id'
    ].join(',')
    
    # query = "SELECT #{fields} FROM serengeti WHERE user_id='#{User.current.id}'"
    query = "SELECT #{fields} FROM serengeti"
    url = encodeURI "http://the-zooniverse.cartodb.com/api/v2/sql?q=#{query}&api_key=#{@apiKey}"
    
    # Mock data
    $.ajax({url: "http://0.0.0.0:9294/mockdata.json"})
      .done(@getClassifications)
      .fail( (e) -> console.log 'fail', e)
    
    # Query CartoDB
    # $.ajax({url: url})
    #   .done(@getClassifications)
    #   .fail( (e) -> console.log 'fail', e)

  getClassifications: (e) =>
    
    # Parse GeoJSON
    rows = e.rows
    rows.map((d) ->
      d.the_geom = JSON.parse(d.the_geom)
      return d
    )
    
    # Set up crossfilter and initial dimension and group
    @crossfilter = crossfilter(rows)
    @dimensions = {}
    @groups = {}
    
    # Create filter by species and behavior
    @createFilter('species')
    @createFilter('behavior')
    @createFilter('site_roll_code')
    
    # Create dimension and group for coordinates
    @dimensions['the_geom'] = @crossfilter.dimension((d) -> d.the_geom.coordinates)
    @groups['the_geom'] = @dimensions['the_geom'].group()
    
    @trigger 'dataReady'
  
  createFilter: (specifier) =>
    @dimensions[specifier] = @crossfilter.dimension((d) -> d[specifier])
    @groups[specifier] = @dimensions[specifier].group()
    
    all = @groups[specifier].all()
    options = "<option value=''>filter by #{specifier}</option>"
    for item in all
      options += "<option value='#{item.key}'>#{item.key.replace(/([A-Z])/g, " $1")}</option>"
    
    el = @el.find("select.filter[data-filter='#{specifier}']")
    el.append(options) unless el.length is 0
  
  filter: (e) =>
    target = e.target
    key = target.dataset.filter
    value = target.value
    
    dimension = @dimensions[key]
    
    # Remove the filter if no value passed
    if value is ''
      dimension.filterAll()
      return
    dimension.filter(value)
    data = dimension.top(Infinity)
    
    # TODO: Make histogram from these
    @setupHistogram @groups[key].top(Infinity)
    
    # TODO: Do something cool with data
    console.log data
  
  clearFilters: => @el.find('select.filter').val('').trigger('change')

  plotSiteRolls: =>    
    sites = @groups['the_geom'].top(Infinity)
    for site in sites
      [lng, lat] = site.key
      label = @map.addLabel(lat, lng, "<p>#{site.value} classifications</p>", radius = 5)
      label.on('click', @filterByLocation)

  filterByLocation: (e) =>
    coords = e.target._latlng
    lat = coords.lat
    lng = coords.lng
    
    # Clear filters
    for key, dimension of @dimensions
      dimension.filterAll()
    
    @dimensions['the_geom'].filterExact([lng, lat])
    data = @groups.species.top(Infinity)
    sortByKey = crossfilter.quicksort.by (d) -> return d.key
    data = sortByKey(data, 0, data.length)

module.exports = Explore
