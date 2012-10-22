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
    'click button[name="turn-page"]': 'onClickPageButton'
    'click button[name="delete"]': 'onClickDelete'
    'click button[name="load-more"]': 'onClickLoadMore'

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
    Favorite.bind 'is-new', @onMarkNewFavorite

    Recent.bind 'create destroy', @onItemCreateDestroy

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

  onMarkNewFavorite: (favorite) =>
    item = @favoritesList.find "[data-item='#{favorite.id}']"
    item.prependTo item.parent()
    item.addClass 'new'

  loadMore: (ItemClass) ->
    @itemPages[ItemClass.className] ?= 0
    @itemPages[ItemClass.className] += 1
    fetch = ItemClass.fetch(page: @itemPages[ItemClass.className], per_page: 8).deferred
    fetch.done => @onFetchItems ItemClass

  onFetchItems: (ItemClass) =>
    @onCreateItem item for item in ItemClass.all()

module.exports = Profile
