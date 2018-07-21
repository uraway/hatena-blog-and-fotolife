{CompositeDisposable} = require 'atom'
{SelectListView} = require 'atom-space-pen-views'

HatenaBlogPost = require './hatena-blog-and-fotolife-model'

module.exports =
class IndexListView extends SelectListView
  initialize: ->
    super
    atom.commands.add 'atom-text-editor',
      'hatena-blog-and-fotolife:index': => @index()
    @hatenaBlogPost = null
    @indexes = []
    @contextCommentRegExp = /^<!--([\s\S]*?)-->\n?/

  index: ->
    @hatenaBlogPost = new HatenaBlogPost()
    @hatenaBlogPost.indexEntries (res, err) =>

      @addClass('overlay from-top')
      @addClass('loading loading-spinner-medium')
      @panel ?= atom.workspace.addModalPanel(item: this)
      @panel.show()

      if err
        @panel.hide()
        console.log err
      else
        console.log res
        i = 0
        entryMaxNum = 9
        if res.feed.entry.length < 9
          entryMaxNum = res.feed.entry.length - 1
        while i <= entryMaxNum
          @categories = []
          if res.feed.entry[i].category
            for k in res.feed.entry[i].category
              @categories.push k.$.term

          @indexes[i] = {id: @parseEntryId(res.feed.entry[i].id), title: res.feed.entry[i].title._, content: res.feed.entry[i].content._, categories: @categories, draft: res.feed.entry[i]['app:control']['app:draft']._}
          @removeClass('loading loading-spinner-medium')
          i++
          @setItems(@indexes)
          @focusFilterEditor()

  viewForItem: (item) ->
    "<li>#{item.title}</li>"

  confirmed: (item) ->
    @panel.hide()

    @saveContext({
      id: item.id
      title: item.title
      categories: item.categories
      draft: item.draft
      }, item.content)

  cancelled: ->
    @panel.hide()

  saveContext: (context, content) ->
    comment = [
      '<!--',
      JSON.stringify(context),
      '-->'
    ].join('\n')
    activeEditor = atom.workspace.getActiveTextEditor()

    # add new context comment
    fileContent = [comment, content].join('\n')
    activeEditor.setText(fileContent)

  removeContextComment: (content) ->
    return content.replace @contextCommentRegExp, ''

  parseEntryId: (id) ->
    return id._.match(/^tag:[^:]+:[^-]+-[^-]+-\d+-(\d+)$/)[1]
