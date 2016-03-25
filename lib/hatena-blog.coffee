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
      description: 'Your Hatena ID'
      type: 'string'
      default: ""
    blogId:
      title: 'Blog URL'
      description: 'Your Blog URL',
      type: 'string'
      default: ""
    apiKey:
      title: 'API Key'
      description: 'Your API Key. See your account setting page at Hatena Blog.'
      type: 'string'
      default: ""
    openAfterPost:
      title: 'Open After Post'
      description: 'After your entry successfully posted, the default web browser open its URL.'
      type: 'boolean'
      default: false
