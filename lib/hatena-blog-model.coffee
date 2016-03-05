moment = require('moment')
https = require 'https'
request = require 'request'
_ = require 'underscore'

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
      <?xml version="1.0" encoding="UTF-8"?>
      <entry xmlns="http://www.w3.org/2005/Atom"
             xmlns:app="http://www.w3.org/2007/app">
        <title>#{@entryTitle}</title>
        <author><name>#{@getHatenaId()}</name></author>
        <content type="text/plain">
          #{_.escape(@entryBody)}
        </content>
        <updated>#{moment().format('YYYY-MM-DDTHH:mm:ss')}</updated>
        <app:control>
          <app:draft>#{draft}</app:draft>
        </app:control>
      </entry>
    """

    options =
      hostname: 'blog.hatena.ne.jp'
      path: "/#{@getHatenaId()}/#{@getBlogId()}/atom/entry"
      auth: "#{@getHatenaId()}:#{@getApiKey()}"
      method: 'POST'

    request = https.request options, (res) ->
      res.setEncoding "utf-8"
      body = ''
      res.on "data", (chunk) ->
        body += chunk
      res.on "end", ->
        callback(body)


    request.write requestBody
    request.end()
