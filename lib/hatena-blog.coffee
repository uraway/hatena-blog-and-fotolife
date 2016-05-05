HatenablogView = require './hatena-blog-view'

module.exports =

  hatenablogView: null

  activate: (state) ->
    @hatenaBlogView = new HatenablogView(state.hatenaBlogViewState)

  deactivate: ->
    @hatenaBlogView.destroy()

  serialize: ->
    hatenaBlogViewState: @hatenaBlogView.serialize()

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
      description: 'Your API Key. See your account setting page at Hatena Blog'
      type: 'string'
      default: ""
    openAfterPost:
      title: 'Open After Post'
      description: 'After your entry was successfully posted, the default web browser opens the URL'
      type: 'boolean'
      default: false
    removeTitle:
      title: 'Remove Title'
      description: 'Remove the title(#) from your entry content'
      type: 'boolean'
      default: true
