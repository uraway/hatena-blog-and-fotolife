{CompositeDisposable} = require 'atom'
HatenablogView = require './hatena-blog-view'

module.exports =

  hatenablogView: null

  activate: (state) ->
    @hatenaBlogView = new HatenablogView(state.hatenaBlogViewState)

  deactivate: ->
    @hatenablogView.destroy()

  serialize: ->
    hatenaBlogViewState: @hatenablogView.serialize()

  config:
    hatenaId:
      title: 'Hatena ID'
      description: 'Your Hatena ID like **uraway**'
      type: 'string'
      default: ''
    blogId:
      title: 'Blog ID'
      description: 'Your Blog ID like **uraway.hatenablog.com**'
      type: 'string'
      default: ''
    apiKey:
      title: 'API Key'
      description: 'Your API Key. See your account setting page at Hatena Blog.'
      type: 'string'
      default: ''
