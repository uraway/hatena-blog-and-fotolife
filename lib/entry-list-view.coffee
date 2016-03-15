{SelectListView, TextEditorView, View} = require 'atom-space-pen-views'

module.exports =
class EntryListView extends SelectListView
 initialize: (items)->
   super
   @addClass('overlay from-top')
   @setItems(items)
   @panel ?= atom.workspace.addModalPanel(item: this)
   @panel.show()
   @focusFilterEditor()

 viewForItem: (item) ->
   console.log item
   "<li>#{item.title}</li>"

 getFilterKey: -> "title"

 confirmed: (item) ->
  new Tutorial(item)
  @panel.hide()

 cancelled: ->
   console.log("This view was cancelled")
   @panel.hide()
