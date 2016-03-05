moment = require 'moment'
blog = require 'hatena-blog-api'

module.exports = class HatenaBlogPost
  constructor: ->
    @isPublic = null
    @entryTitle = ""
    @entryBody = ""
    @categories = []

  getHatenaId: ->
    atom.config.get("hatena-blog-entry-post.hatenaId")

  getBlogId: ->
    atom.config.get("hatena-blog-entry-post.blogId")

  getApiKey: ->
    atom.config.get("hatena-blog-entry-post.apiKey")

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
      draft: !@isPublic
    }, (err, res) ->
      if err
        callback err
      else
        callback res
      return
