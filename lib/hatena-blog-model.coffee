moment = require('moment')
https = require('https')
request = require('superagent')

module.exports = class HatenaBlogPost
  constructor: ->
    @isPublic = null
    @entryTitle = ""
    @entryBody = ""

  getHatenaId: ->
    atom.config.get("hatena-blog.hatenaId")

  getBlogId: ->
    atom.config.get("hatena-blog.blogId")

  getApiKey: ->
    atom.config.get("hatena-blog.apiKey")

  postEntry: (callback) ->
    draft = if @isPublic then 'no' else 'yes'

    requestBody = """
      <?xml version="1.0" encoding="utf-8"?>
        <entry  xmlns="http://www.w3.org/2005/Atom"
                xmlns:app="http://www.w3.org/2007/app">

        <title>#{@entryTitle}</title>

        <author><name>#{@getHatenaId()}</name></author>

        <content type="text/plain">#{@entryBody}</content>
        
        <updated>#{moment().format("YYYY-MM-DDTHH:mm:ss")}</updated>

        <category />

        <app:control>
          <app:draft>#{draft}</app:draft>
        </app:control>
        </entry>
    """

    options =
      hostname: 'blog.hatena.ne.jp'
      path: "/#{@getHatenaId()}/#{@getBlogId()}/atom/entry"
      method: 'POST'
      auth: "#{@getHatenaId()}:#{@getApiKey()}"

    request
      .post("https://blog.hatena.ne.jp/#{@getHatenaId()}/#{@getBlogId()}/atom/entry")
      .auth("#{@getHatenaId()}:#{@getApiKey()}")
      .send(requestBody)
      .end(callback)
