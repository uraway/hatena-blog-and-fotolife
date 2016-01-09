{CompositeDisposable} = require 'atom'
HatenablogView = require './hatena-blog-view'

module.exports =
  config:
    hatenaId:
      type: 'string'
      default: ''
    blogId:
      type: 'string'
      default: ''
    apiKey:
      type: 'string'
      default: ''

  hatenaBlogPanel: null
  subscriptions: null
  HatenablogView: null

  activate: (state) ->
    @hatenaBlogView = new HatenablogView(state.atomHatenablogViewState)
    @hatenaBlogPanel = atom.workspace.addTopPanel(item: @hatenaBlogView, priority: 0)

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'hatena-blog:toggle': =>
      @toggle()

  deactivate: ->
    @hatenablogView.destroy()
    @hatenaBlogPanel.destroy()
    @subscriptions?.dispose()
    @subscriptions = null


  serialize: ->
    atomHatenablogViewState: @hatenablogView.serialize()

  toggle: ->
    if @hatenaBlogPanel.isVisible()
      @hatenaBlogPanel.hide()
    else
      @hatenaBlogPanel.show()
