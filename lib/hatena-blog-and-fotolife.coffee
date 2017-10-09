HatenablogView = require './hatena-blog-and-fotolife-view'
IndexListView = require './hatena-blog-and-fotolife-index-view'

module.exports =

  hatenablogView: null
  indexListView: null

  activate: (state) ->
    @hatenaBlogView = new HatenablogView(state.hatenaBlogViewState)
    @indexListView = new IndexListView(state.indexListViewState)

  deactivate: ->
    @hatenaBlogView.destroy()
    @indexListView.destroy()

  serialize: ->
    hatenaBlogViewState: @hatenaBlogView.serialize()
    indexListViewState: @indexListView.serialize()

  config:
    hatenaId:
      title: 'Hatena ID'
      description: 'Your Hatena ID'
      type: 'string'
      default: ""
    blogId:
      title: 'Blog URL'
      description: 'Your Blog URL without `http://`',
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
