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
    'change input[type="range"]'            : 'scrubTime'
  
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
      @requestSpeciesByDate(0, 1)
      
  getQueryUrl: (query) ->
    url = encodeURI "http://the-zooniverse.cartodb.com/api/v2/sql?q=#{query}&api_key=#{@apiKey}"
    return url.replace(/\+/g, '%2B')
  
  requestQuery: (query, callback) =>
    if $('input[name="scope"]:checked').val() is 'single'
      query = @appendUserCondition(query)
    url = @getQueryUrl(query)
    console.log url
    $.ajax({url: url})
      .done(callback)
      .fail( (e) -> alert 'Sorry, the query failed')
  
  # Add user condition to query
  appendUserCondition: (query) =>
    return query += "WHERE user_id = #{User.current.id}"
  
  requestSpeciesByDate: (lower, upper) =>
    query = "SELECT site_roll_code, species, AVG(how_many) FROM serengeti WHERE captured_at BETWEEN (SELECT MIN(captured_at) FROM serengeti) + #{lower} * (SELECT (MAX(captured_at) - MIN(captured_at)) / 10 FROM serengeti) AND (SELECT MIN(captured_at) + #{upper} * (SELECT (MAX(captured_at) - MIN(captured_at)) / 10 FROM serengeti) FROM serengeti) GROUP BY site_roll_code, species"
    
    @requestQuery(query, @getSpeciesByDate)
  
  getSpeciesByDate: (response) =>
    
    # Remove labels from map
    for label in @map.labels
      @map.removeLayer label
      
    cross = crossfilter(response.rows)
    
    dimBySite = cross.dimension((d) -> d.site_roll_code)
    groupBySite = dimBySite.group()
    dimBySpecies = cross.dimension((d) -> d.species)
    groupBySpecies = dimBySpecies.group()
    
    # Get sorted list of sites and species for this query
    siteList = groupBySite.top(Infinity).map((d) -> d.key).sort()
    speciesList = groupBySpecies.top(Infinity).map((d) -> d.key).sort()
    
    # Build select with all species in this query
    el = @el.find("select[data-filter='species']")
    value = el.val()
    el.empty()
    options = "<option value=''>filter by species</option>"
    for species in speciesList
      options += "<option value='#{species}'>#{species.replace(/([A-Z])/g, " $1")}</option>"
    el.append(options)
    el.val(value)
    
    currentSpecies = $("select[data-filter='species']").val() or 'gazelleThomsons'
    
    for site in siteList
      dimBySite.filterExact(site)
      species = dimBySite.top(Infinity)
      
      for critter in species
        if critter.species is currentSpecies
          [lat, lng] = @mockCoordinates[site]
          label = @map.addLabel(lat, lng, "", 2 * critter.avg)
  
  scrubTime: (e) =>
    upper = parseInt(e.target.value)
    lower = upper - 1
    @requestSpeciesByDate(lower, upper)


module.exports = Explore
