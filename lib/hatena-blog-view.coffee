{CompositeDisposable} = require 'atom'
{TextEditorView, View} = require 'atom-space-pen-views'
open = require 'open'

HatenaBlogPost = require './hatena-blog-model'

module.exports =
class HatenablogView extends View
  titleRegExp: /^ *# (.*)/
  contextCommentRegExp: /^<!---([\s\S]*?)--->\n?/
  category: []
  image: null
  @content: ->
    @div class: 'hatena-blog panel overlay from-top', =>
      @div class: 'inset-panel', =>

        @div class: 'panel-heading', =>
          @span outlet: 'title'
          @input style: 'display:none;', type: 'file', outlet: 'file', accept: 'image/*'
          @a href: '#', outlet: 'fileSelect', class: 'icon icon-cloud-upload pull-right'

        @div class: 'panel-body', =>
          @div outlet: 'postForm', =>
            @subview 'titleEditor', new TextEditorView(mini: true, placeholderText: 'Edit title...')

            @div class: 'category-container', =>
              @span outlet: 'categoryList'
              @subview 'categoryEditor', new TextEditorView(mini: true, placeholderText: 'Add a new category item...' )

            @div class: 'btn-group', =>
              @button outlet: 'draftButton', class: 'btn', 'Draft'
              @button outlet: 'publicButton', class: 'btn', 'Public'

            @div class: 'btn-group pull-right', outlet: 'toolbar', =>
              @button outlet: 'postButton', class: 'btn btn-primary inline-block-tight', 'POST'
              @button outlet: 'cancelButton', class: 'btn inline-block-tight', 'Cancel'

          @div outlet: 'progressIndicator', =>
            @span class: 'loading loading-spinner-medium'

  initialize: (serializeState) ->
    @hatenaBlogPost = null
    @subscriptions = new CompositeDisposable
    @handleEvents()

    # render category items above the category editor
    for key in @category
      @categoryList.append("#{key}/")

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

  deactivate: ->
    @destroy()

  handleEvents: ->
    @draftButton.on 'click', => @entryDraft()
    @publicButton.on 'click', => @entryPublic()
    @postButton.on 'click', => @postOrUpdate()
    @cancelButton.on 'click', => @destroy()
    @categoryList.on 'click', => @deleteCategoryItem()
    @categoryEditor.on 'keydown', event, => @addCategoryItem(event, @categoryEditor.getText())
    @file.on 'change', => @uploadImage()

    # file element click event handler
    @fileSelect.on "click", event, =>
      @file.click()  if @file
      event.preventDefault() # "#" に移動するのを防ぐ
      false

    @on 'focus', =>
      @titleEditor.focus()

  # upload image to fotolife
  uploadImage: () ->
    @image = @file[0].files[0].path

    @hatenaBlogPost.uploadImage @image

  # delete last item of the category array
  deleteCategoryItem: () ->
    @category.pop()

    # render category items above the category editor after initializing the content
    @categoryList.empty()
    for key in @category
      @categoryList.append("#{key}/")

  addCategoryItem: (event, item) ->
    if (event.keyCode is 13)
      console.log item
      @category.push item
      @categoryEditor.setText("")

      # render category items above the category editor after initializing the content
      @renderCategoryItem()

  renderCategoryItem: () ->
    @categoryList.empty()
    for key in @category
      @categoryList.append("#{key}/")

  postCurrentFile: () ->
    activeEditor = atom.workspace.getActiveTextEditor()
    fileContent = activeEditor.getText()

    if (!!fileContent.trim())
      @hatenaBlogPost = new HatenaBlogPost()
      @hatenaBlogPost.entryBody = @removeTitle(@removeContextComment(fileContent))

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

  postOrUpdate: ->
    if @hatenaBlogPost.entryId
      console.log('Update entry ' + @hatenaBlogPost.entryId)
      @update()
    else
      console.log('Post new entry')
      @post()

  update: ->
    @showProgressIndicator()

    # set categoy item
    @hatenaBlogPost.categories = @category

    # set entry title
    @hatenaBlogPost.entryTitle = @titleEditor.getText()

    # post entry and parse response
    @hatenaBlogPost.updateEntry (res, err) =>
      if err
        atom.notifications.addError("#{err}", dismissable: true)
        console.log err
      else
        entryURL = res.entry.link[1].$.href
        atom.notifications.addSuccess("Updated #{entryURL}", dismissable: true)
        @saveContext({
          id: @hatenaBlogPost.entryId,
          title: @hatenaBlogPost.entryTitle,
          categories: @hatenaBlogPost.categories
          })
        console.log res

        if atom.config.get('hatena-blog.openAfterPost') is true
          console.log "open #{entryURL}"
          open "#{entryURL}"

    # timeout is needed when error occures
    setTimeout (=>
      @destroy()
    ), 1000

  post: ->
    @showProgressIndicator()

    # set categoy item
    @hatenaBlogPost.categories = @category

    # set entry title
    @hatenaBlogPost.entryTitle = @titleEditor.getText()

    # post entry and parse response
    @hatenaBlogPost.postEntry (res, err) =>
      if err
        atom.notifications.addError("#{err}", dismissable: true)
        console.log err
      else
        entryURL = res.entry.link[1].$.href
        atom.notifications.addSuccess("Posted at #{entryURL}", dismissable: true)
        @saveContext({
          id: @hatenaBlogPost.entryId,
          title: @hatenaBlogPost.entryTitle,
          categories: @hatenaBlogPost.categories
          })
        console.log res

        if atom.config.get('hatena-blog-entry-post.openAfterPost') is true
          console.log "open #{entryURL}"
          open "#{entryURL}"

    # timeout is needed when error occures
    setTimeout (=>
      @destroy()
    ), 1000

  # draft button switched
  entryDraft: ->
    @draftButton.addClass('selected')
    @publicButton.removeClass('selected')
    @hatenaBlogPost.isPublic = false

  # public button switched
  entryPublic: ->
    @draftButton.removeClass('selected')
    @publicButton.addClass('selected')
    @hatenaBlogPost.isPublic = true

  # toggle this package when the Form is hidden
  showEntryForm: ->
    context = @parseContext()
    @hatenaBlogPost.entryTitle = @getTitle()
    if context.id?
      @hatenaBlogPost.entryId = context.id
    if context.title?
      @hatenaBlogPost.entryTitle = context.title
    if context.categories?
      @hatenaBlogPost.categories = context.categories
      @category = context.categories
      @renderCategoryItem()
    if @hatenaBlogPost.isPublic
      @entryPublic()
    else
      @entryDraft()
    @titleEditor.setText @hatenaBlogPost.entryTitle

    @toolbar.show()
    @postForm.show()
    @progressIndicator.hide()

  # show indicator after post
  showProgressIndicator: ->
    @toolbar.hide()
    @postForm.hide()
    @progressIndicator.show()

  parseContext: ->
    activeEditor = atom.workspace.getActiveTextEditor()
    fileContent = activeEditor.getText()
    comment = fileContent.match @contextCommentRegExp
    try
      if comment
        return JSON.parse(comment[1])
      else
        return {}
    catch err
      console.log err
      return {}

  saveContext: (context) ->
    comment = [
      '<!---',
      JSON.stringify(context),
      '--->'
    ].join('\n')
    activeEditor = atom.workspace.getActiveTextEditor()
    fileContent = @removeContextComment activeEditor.getText()
    # add new context comment
    fileContent = [comment, fileContent].join('\n')
    activeEditor.setText(fileContent)

  removeContextComment: (content) ->
    return content.replace @contextCommentRegExp, ''

  getTitle: ->
    activeEditor = atom.workspace.getActiveTextEditor()
    fileContent = @removeContextComment activeEditor.getText()
    title = fileContent.match @titleRegExp
    if title
      return title[1].trim()
    else
      return ""

  removeTitle: (content) ->
    return content.replace(@titleRegExp, '').trim()
