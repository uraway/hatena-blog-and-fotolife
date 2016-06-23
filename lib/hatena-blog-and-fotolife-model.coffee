blog = require 'hatena-blog-api'
fotolife = require 'hatena-fotolife-api'

module.exports = class HatenaBlogPost
  constructor: ->
    @draft = true
    @entryTitle = ""
    @entryBody = ""
    @categories = []

  getHatenaId: ->
    atom.config.get("hatena-blog-and-fotolife.hatenaId")

  getBlogId: ->
    atom.config.get("hatena-blog-and-fotolife.blogId")

  getApiKey: ->
    atom.config.get("hatena-blog-and-fotolife.apiKey")

  uploadImage: (@image) ->
    client = fotolife(
      type: 'wsse'
      username: @getHatenaId()
      apikey: @getApiKey()
    )

    options =
      title: image
      file: image

    # insert loading text
    editor = atom.workspace.getActiveTextEditor()
    range = editor.insertText('Uploading...')

    client.create options, (err, res) ->
      if err
        markdown = "#{err.statusCode}"
        editor.setTextInBufferRange(range[0], markdown)
      else
        # console.log res.entry
        imageurl = res.entry["hatena:imageurl"]._
        markdown = "![](#{imageurl})"
        editor.setTextInBufferRange(range[0], markdown)

  parseEntryId: (id) ->
    return id._.match(/^tag:[^:]+:[^-]+-[^-]+-\d+-(\d+)$/)[1]

  postEntry: (callback) ->
    client = blog(
      type: 'wsse'
      username: @getHatenaId()
      blogId:   @getBlogId()
      apikey:   @getApiKey()
    )

    client.create {
      title: @entryTitle
      content: @entryBody
      categories: @categories
      draft: @draft
    }, (err, res) =>
      if err
        callback res, err
      else
        @entryId = @parseEntryId(res.entry.id)
        callback res, err
      return

  updateEntry: (callback) ->
    client = blog(
      type: 'wsse'
      username: @getHatenaId()
      blogId:   @getBlogId()
      apikey:   @getApiKey()
    )

    client.update {
      id: @entryId
      title: @entryTitle
      content: @entryBody
      categories: @categories
      draft: @draft
    }, (err, res) ->
      callback res, err

  deleteEntry: (callback) ->
    client = blog(
      type: 'wsse'
      username: @getHatenaId()
      blogId:   @getBlogId()
      apikey:   @getApiKey()
    )

    client.destroy {
      id: @entryId
      }, (err, res) ->
        callback res, err

  indexEntries: (callback) ->
    client = blog(
      type: 'wsse'
      username: @getHatenaId()
      blogId:   @getBlogId()
      apikey:   @getApiKey()
    )

    client.index (err, res) ->
      callback res, err
