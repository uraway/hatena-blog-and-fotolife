{CompositeDisposable} = require 'atom'
{TextEditorView, View} = require 'atom-space-pen-views'
open = require 'open'

HatenaBlogPost = require './hatena-blog-model'

module.exports =
class HatenablogView extends View

  @content: ->
    @div class: 'hatena-blog overlay tool-panel padded', =>
      @div class: 'inset-panel', =>

        @div class: 'panel-heading', =>
          @span outlet: 'title'

        @div class: 'panel-body', =>
          @div outlet: 'postForm', =>

            @subview 'titleEditor', new TextEditorView(mini: true)

            @div class: 'btn-group', outlet: 'toolbar', =>
              @button outlet: 'postButton', class: 'btn btn-primary inline-block-tight', 'POST'
              @button outlet: 'cancelButton', class: 'btn inline-block-tight', 'Cancel'

          @div class: 'btn-toolbar pull-right', outlet: 'toolbar', =>
            @div class: 'btn-group', =>
              @button outlet: 'draftButton', class: 'btn', 'Draft'

              @button outlet: 'publicButton', class: 'btn', 'Public'
          @div outlet: 'progressIndicator', =>
            @span class: 'loading loading-spinner-medium'

        @div outlet: 'cancel', =>
          @button outlet: 'cancelButton', class: 'btn', 'CANCEL'

  initialize: (serializeState) ->
    @hatenaBlogPost = null
    @subscriptions = new CompositeDisposable

    @handleEvents()

    atom.commands.add 'atom-text-editor',
      'hatena-blog:post-current-file': => @postCurrentFile(),
      'hatena-blog:post-selection': => @postSelection()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()
    @subscriptions.dispose()
    atom.views.getView(atom.workspace).focus()

  handleEvents: ->
    @draftButton.on 'click', => @entryDraft()
    @publicButton.on 'click', => @entryPublic()
    @postButton.on 'click', => @post()
    @cancelButton.on 'click', => @destroy()

    @on 'focus', =>
      @titleEditor.focus()

  postCurrentFile: ->
    activeEditor = atom.workspace.getActiveTextEditor()
    fileContent = activeEditor.getText()

    if (!!fileContent.trim())
      @hatenaBlogPost = new HatenaBlogPost()
      @hatenaBlogPost.entryBody = fileContent

      @title.text 'Post Current File'
      @presentSelf()

    else
      atom.notifications.addError('Entry could not be posted: The current file is empty.')

  postSelection: ->
    activeEditor = atom.workspace.getActiveTextEditor()
    selectedText = activeEditor.getSelectedText()

    if (!!selectedText.trim())
      @hatenaBlogPost = new HatenaBlogPost()

      @hatenaBlogPost.entryBody = selectedText

      @title.text 'Post Selection'
      @presentSelf()
    else
      atom.notifications.addError('Entry could not be created: The current selection is empty.')

  presentSelf: ->
    @showEntryForm()
    atom.workspace.addTopPanel(item: this)
    @titleEditor.focus()

  post: ->
    @showProgressIndicator()

    @hatenaBlogPost.entryTitle = @titleEditor.getText()

    @hatenaBlogPost.postEntry (res, err) =>
      if err
        atom.notifications.addError("#{err}", dismissable: true)
        console.log err
      else
        entryURL = res.entry.link[1].$.href
        atom.notifications.addSuccess("Posted at #{entryURL}", dismissable: true)
        console.log res

        if atom.config.get('hatena-blog-entry-post.openAfterPost') is true
          console.log "open #{entryURL}"
          open "#{entryURL}"

    setTimeout (=>
      @destroy()
    ), 1000

  entryDraft: ->
    @draftButton.addClass('selected')
    @publicButton.removeClass('selected')
    @hatenaBlogPost.isPublic = false

  entryPublic: ->
    @draftButton.removeClass('selected')
    @publicButton.addClass('selected')
    @hatenaBlogPost.isPublic = true

  showEntryForm: ->
    if @hatenaBlogPost.isPublic then @entryPublic() else @entryDraft()
    @titleEditor.setText @hatenaBlogPost.entryTitle

    @toolbar.show()
    @postForm.show()
    @progressIndicator.hide()

    @cancelButton.hide()

  showProgressIndicator: ->
    @toolbar.hide()
    @postForm.hide()
    @progressIndicator.show()

    @cancelButton.show()
