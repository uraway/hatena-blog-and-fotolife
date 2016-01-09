{CompositeDisposable} = require 'atom'
{View} = require 'space-pen'
{TextEditorView} = require 'atom-space-pen-views'
Clipboard = require 'clipboard'

HatenaBlogPost = require './hatena-blog-model'

module.exports =
class HatenablogView extends View

  @content: ->
    @div class: 'hatena-blog-container', =>

      @div class: 'hatena-blog overlay padded', =>
        @div class: 'hatena-blog-editr', "Hatena Blog Post"
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

    @hatenaBlogPost.postEntry (err, response)  =>
        if err
          text = "#{err}
                  statusCode: #{response.statusCode}"
          @status.text text
          return
        text = "Successfully Posted!!"
        @status.text text
