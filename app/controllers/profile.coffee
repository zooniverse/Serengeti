{Controller} = require 'spine'
$ = require 'jqueryify'
template = require 'views/profile'
LoginForm = require 'zooniverse/lib/controllers/login_form'
User = require 'zooniverse/lib/models/user'
Favorite = require 'zooniverse/lib/models/favorite'
Recent = require 'zooniverse/lib/models/recent'
itemTemplate = require 'views/profile_item'
Map = require 'zooniverse/lib/map'

class Profile extends Controller
  className: 'profile'

  itemPages: null

  events:
    'click button[name="turn-page"]'      : 'onClickPageButton'
    'click button[name="delete"]'         : 'onClickDelete'
    'click button[name="load-more"]'      : 'onClickLoadMore'
    'change select.filter'                : 'filter'
    'click button[name="clear-filters"]'  : 'clearFilters'

  elements:
    '.sign-in': 'signInContainer'
    'nav button': 'navButtons'
    '.page': 'pages'
    '.favorites ul': 'favoritesList'
    '.recents ul': 'recentsList'

  constructor: ->
    super

    @html template
    @loginForm = new LoginForm el: @signInContainer

    User.bind 'sign-in', @onUserSignIn

    Favorite.bind 'create destroy', @onItemCreateDestroy
    Favorite.bind 'send', @onCreateItem
    Favorite.bind 'is-new', @onMarkNew

    Recent.bind 'create destroy', @onItemCreateDestroy
    Recent.bind 'send', @onCreateItem
    Recent.bind 'is-new', @onMarkNew

    @navButtons.first().click()
    @onUserSignIn()
    
    @map ?= new Map
      latitude: 2.33
      longitude: 35
      centerOffset: [0.25, 0.5]
      zoom: 6
      className: 'full-screen'

    @map.el.appendTo @el.find('.map-container')
    
    @bind 'dataReady', @plotSiteRolls

  onClickPageButton: ({currentTarget}) ->
    @navButtons.add(@pages).removeClass 'active'

    value = $(currentTarget).val()
    page = @pages.filter ".#{value}"
    button = @navButtons.filter "[value='#{value}']"

    button.add(page).addClass 'active'

  onClickDelete: ({currentTarget}) ->
    item = $(currentTarget).parent("[data-item]")
    id = item.attr 'data-item'
    Favorite.find(id).unfavorite()

  onClickLoadMore: ({currentTarget}) ->
    ItemClass = switch $(currentTarget).val()
      when 'favorite' then Favorite
      when 'recent' then Recent

    @loadMore ItemClass

  onUserSignIn: =>
    @el.toggleClass 'signed-in', !!User.current

    for ItemClass in [Favorite, Recent]
      ItemClass.first().destroy() until ItemClass.count() is 0

    @itemPages = {}

    if User.current
      @loadMore Favorite
      @loadMore Recent
      @requestClassifications()

  onItemCreateDestroy: (item) =>
    ItemClass = item.constructor
    className = ItemClass.className.toLowerCase()
    hasItems = ItemClass.count() isnt 0

    @el.toggleClass "has-#{className}s", hasItems

    loadMoreButton = @el.find "button[name='load-more'][value='#{className}']"
    loadMoreButton.attr disabled: not hasItems

  onCreateItem: (item) =>
    list = @["#{item.constructor.className.toLowerCase()}sList"]
    return unless list.find("[data-item='#{item.id}']").length is 0

    item = $(itemTemplate item)
    item.bind 'destroy', -> item.remove()
    item.appendTo list

  onMarkNew: (item) =>
    item = @el.find "[data-item='#{item.id}']"
    item.prependTo item.parent()
    item.addClass 'new'

  loadMore: (ItemClass) ->
    @itemPages[ItemClass.className] ?= 0
    @itemPages[ItemClass.className] += 1
    fetch = ItemClass.fetch(page: @itemPages[ItemClass.className], per_page: 8).deferred
    fetch.done => @onFetchItems ItemClass

  onFetchItems: (ItemClass) =>
    @onCreateItem item for item in ItemClass.all()

  requestClassifications: =>
    # Put Carto API key in Zooniverse lib
    apiKey = 'CARTO_API_KEY'
    fields = [
      'babies', 'behavior', 'captured_at', 'created_at', 'how_many', 'site_roll_code',
      'species', 'ST_AsGeoJSON(the_geom) as the_geom', 'updated_at', 'subject_id'
    ].join(',')
    
    # query = "SELECT #{fields} FROM serengeti WHERE user_id='#{User.current.id}'"
    query = "SELECT #{fields} FROM serengeti"
    url = encodeURI "http://the-zooniverse.cartodb.com/api/v2/sql?q=#{query}&api_key=#{apiKey}"
    
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
    
    window.cross = @crossfilter
    window.data = rows
    window.dimensions = @dimensions
    
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
  
  setupHistogram: (data) ->
    $('.map-container .plot').empty()
    
    margin = {top: 20, right: 20, bottom: 30, left: 40}
    width = 400 - margin.left - margin.right
    height = 600 - margin.top - margin.bottom
    
    x = d3.scale.linear()
          .range([0, width])
          .domain([0, d3.max(data, (d) -> return d.value)])
    y = d3.scale.ordinal()
          .rangeBands([0, height])
          .domain(data.map((d) -> return d.key))

    xAxis = d3.svg.axis()
              .scale(x)
              .orient('bottom')
    yAxis = d3.svg.axis()
              .scale(y)
              .orient('left')
    
    svg = d3.select('.map-container .plot').append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
          .append('g')
            .attr('transform', "translate(#{margin.left}, #{margin.top})")
    
    svg.append('g')
        .attr('class', 'x axis')
        .attr('transform', "translate(0, #{height})")
        .call(xAxis)
    svg.append('g')
        .attr('class', 'y axis')
        .call(yAxis)
      .append('text')
        .attr('transform', 'rotate(-90)')
        .attr('y', 6)
        .attr('dy', '.71em')
        .style('text-anchor', 'end')
        .text('Count')
    
    svg.selectAll('.bar')
        .data(data)
      .enter().append('rect')
        .attr('class', 'bar')
        .attr('width', (d) -> return x(d.value))
        .attr('y', (d) -> return y(d.key))
        .attr('height', (d) -> y.rangeBand())
  
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
    
    @setupHistogram data

module.exports = Profile
