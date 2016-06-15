# hatena-blog-and-fotolife

- [日本語ドキュメント](https://github.com/uraway/hatena-blog-and-fotolife/blob/master/ja.md)

This is the best way to **POST** / **UPDATE** / **DELETE** your [Hatena Blog](http://hatenablog.com/) entry and upload an image to your [fotolife](http://f.hatena.ne.jp/)

## POST

![post](https://cloud.githubusercontent.com/assets/15242484/15038403/6d8b222a-12de-11e6-8ce5-60257b8dc153.gif)

## UPDATE

![update](https://cloud.githubusercontent.com/assets/15242484/15038407/76a75a54-12de-11e6-971f-68ef5097a13b.gif)

## DELETE

![delete](https://cloud.githubusercontent.com/assets/15242484/16063420/1c8e1394-32d4-11e6-98f8-c286e9809c01.gif)


You can handle the entry's:
- title (#h1 of the first line)
- category
- draft status

#### Add a category
- Input a category text
- Enter to add the category
- Click the last item to delete a category from the list

## Upload an Image

![](https://zippy.gfycat.com/HardtofindDampIrishredandwhitesetter.gif)

## Commands
- **Post/Update/Delete Current File (⌥⌘P)** posts/updates/deletes the contents of the current file in the editor.
- **Post/Update/Delete Selection (⇧⌥⌘P)** posts/updates/deletes the contents of the current selection.

## Required settings
You need the following to post, update or delete an entry via this package. Copy and paste them into the each setting field.

Only Hatena ID and API Key allow the package to upload an image.

- Hatena ID
- [Blog URL](http://blog.hatena.ne.jp/my/config)
- [API Key](http://blog.hatena.ne.jp/my/config/detail)

## Optional settings

- Open After Post

If it is enabled, your default web browser opens the URL after posting an entry.

- Remove Title

If it is enabled, an entry's title (#h1) will be removed from the content.
