HatenablogView = require './hatena-blog-view'
EntryListView = require './entry-list-view'

module.exports =

  hatenablogView: null

  activate: (state) ->
    @hatenaBlogView = new HatenablogView(state.hatenaBlogViewState)
    @entryListView = new EntryListView(state.entryListViewState)

  deactivate: ->
    @hatenablogView.destroy()
    @entryListView.destroy()

  serialize: ->
    hatenaBlogViewState: @hatenablogView.serialize()
    entryListViewState: @entryListView.serialize()

  config:
    hatenaId:
      title: 'Hatena ID'
      description: 'Your Hatena ID'
      type: 'string'
      default: ""
    blogId:
      title: 'Blog ID'
      description: 'Your Blog ID',
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
