{CompositeDisposable} = require 'atom'
{View} = require 'space-pen'
{TextEditorView} = require 'atom-space-pen-views'
{parseString} = require 'xml2js'

HatenaBlogPost = require './hatena-blog-model'

module.exports =
class HatenablogView extends View

  @content: ->
    @div class: 'hatena-blog-container', =>

      @div class: 'hatena-blog overlay padded', =>
        @div class: 'hatena-blog-editr', "Hatena Blog Entry Post - Title Editor"
        @subview 'titleEditor', new TextEditorView(mini: true)

        @div class: 'result-container', =>
          @span outlet: 'status', class: 'text-subtle status-container', ''

        @button outlet: 'postButton', class: 'btn', 'POST'

        @div class: 'btn-toolbar pull-right', outlet: 'toolbar', =>
          @div class: 'btn-group', =>
            @button outlet: 'draftButton', class: 'btn', 'Draft'
            @button outlet: 'publicButton', class: 'btn', 'Public'

  initialize: (serializeState) ->
    @handleEvents()
    hatenaBlogPost = null

    @hatenaBlogPost = new HatenaBlogPost()
    @hatenaBlogPost.entryBody = atom.workspace.getActiveTextEditor().getText()

  # Returns an object that can be retrieved when package is activated
  #serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()
    @subscriptions.dispose()

  handleEvents: ->
    @draftButton.on 'click', => @entryDraft()
    @publicButton.on 'click', => @entryPublic()
    @postButton.on 'click', => @post()

  entryDraft: ->

    @draftButton.addClass('selected')
    @publicButton.removeClass('selected')

    @hatenaBlogPost.isPublic = false

  entryPublic: ->

    @draftButton.removeClass('selected')
    @publicButton.addClass('selected')

    @hatenaBlogPost.isPublic = true

  post: ->
    @hatenaBlogPost.entryTitle = @titleEditor.getText()

    @hatenaBlogPost.postEntry (response)  =>
      parseString response, (err, result) =>
        if err
          text = "#{err}"

          @status.text text
          console.log err
          console.dir result
        else
          console.dir result
          text = "'#{result.entry.title}' was successfully posted!! " 
          @status.text text

          entryURL = result.entry.link[1].$.href

          console.log entryURL
          @titleEditor.setText entryURL
