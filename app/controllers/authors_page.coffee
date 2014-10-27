AboutPage = require './about_page'
template = require 'views/authors_page'
$ = require 'jqueryify'

class AuthorsPage extends AboutPage
  className: ['authors-page', AboutPage::className].join ' '
  template: template

module.exports = AuthorsPage
