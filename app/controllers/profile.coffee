{Controller} = require 'spine'
$ = require 'jqueryify'
template = require 'views/profile'
LoginForm = require 'zooniverse/lib/controllers/login_form'
User = require 'zooniverse/lib/models/user'
Favorite = require 'zooniverse/lib/models/favorite'
Recent = require 'zooniverse/lib/models/recent'
itemTemplate = require 'views/profile_item'

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
    key = 'CARTO_API_KEY'
    fields = [
      'babies', 'behavior', 'captured_at', 'created_at', 'how_many', 'site_roll_code',
      'species', 'the_geom', 'the_geom_webmercator', 'updated_at', 'subject_id'
    ].join(',')
    
    # query = "SELECT #{fields} FROM serengeti WHERE user_id='#{User.current.id}'"
    query = "SELECT #{fields} FROM serengeti"
    url = encodeURI "http://the-zooniverse.cartodb.com/api/v2/sql?q=#{query}&api_key=#{key}"
    
    # $.ajax({url: "http://0.0.0.0:9294/mockdata.json"})
    #   .done(@getClassifications)
    #   .fail( (e) -> console.log 'fail', e)
    
    $.ajax({url: url})
      .done(@getClassifications)
      .fail( (e) -> console.log 'fail', e)

  getClassifications: (e) =>
    
    # Set up crossfilter and initial dimension and group
    @crossfilter = crossfilter(e.rows)
    @dimensions = {}
    @groups = {}
    
    # Create filter by species and behavior
    @createFilter('species')
    @createFilter('behavior')
  
  createFilter: (specifier) =>
    @dimensions[specifier] = @crossfilter.dimension((d) -> d[specifier])
    @groups[specifier] = @dimensions[specifier].group()
    
    all = @groups[specifier].all()
    options = "<option value=''>filter by #{specifier}</option>"
    for item in all
      options += "<option value='#{item.key}'>#{item.key.replace(/([A-Z])/g, " $1")}</option>"
    
    @el.find("select.filter[data-filter='#{specifier}']").append(options)
  
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
    
    # TODO: Do something cool with data
    console.log data
  
  clearFilters: => @el.find('select.filter').val('').trigger('change')


module.exports = Profile
