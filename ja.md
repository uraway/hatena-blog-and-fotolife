# hatena-blog-and-fotolife

このパッケージは、Atomから[はてなブログ](http://hatenablog.com/)のエントリーを投稿、更新、削除し、[フォトライフ](http://f.hatena.ne.jp/)に画像をアップロードする最良の方法です。

## エントリーを投稿する

![post](https://cloud.githubusercontent.com/assets/15242484/15038403/6d8b222a-12de-11e6-8ce5-60257b8dc153.gif)

## エントリーを更新する
![update](https://cloud.githubusercontent.com/assets/15242484/15038407/76a75a54-12de-11e6-971f-68ef5097a13b.gif)

## エントリーを削除する

![delete](https://cloud.githubusercontent.com/assets/15242484/16063420/1c8e1394-32d4-11e6-98f8-c286e9809c01.gif)

## エントリーインデックスを取得する

![index](https://cloud.githubusercontent.com/assets/15242484/16293971/b61dd578-3958-11e6-94ff-dcb77a10fa60.gif)

## エントリーを取得する

![get](https://cloud.githubusercontent.com/assets/15242484/16293997/eb3014b0-3958-11e6-99eb-e0a5d3e21099.gif)


#### カテゴリーを編集する
- カテゴリーテクストを入力します
- Enterを押して、カテゴリーアイテムに追加します
- カテゴリーリストをクリックして、最も新しいアイテムを削除することも出来ます

## 画像をアップロードする

![](https://zippy.gfycat.com/HardtofindDampIrishredandwhitesetter.gif)

## コマンド
- **Post/Update/Delete Current File (⌥⌘P)** エディタのアクティブなファイルを投稿/更新/削除します
- **Post/Update Selection (⇧⌥⌘P)** エディタの選択部分を投稿/更新します
- **Index Entries (⌥⌘I)** エントリーのインデックスを取得します。エントリーの内容を取得することも出来ます。

## 必要な設定
このパッケージを使ってエントリーを投稿/更新/削除するには、以下の情報を設定する必要があります。各フィールドにコピー&ペーストで入力して下さい

画像のアップロードには、はてなIDとAPIキーを使用します。

- はてなID
- [ブログ URL](http://blog.hatena.ne.jp/my/config) (`http://`を除く)

![](https://i.imgur.com/k1wVB8K.png)

- [API キー](http://blog.hatena.ne.jp/my/config/detail)

![](https://i.imgur.com/iHIWa74.png)

## オプション

- Open After Post

エントリーを投稿後、そのURLを開きます

- Remove Title

エントリーのタイトルとなる見出し(#)がエントリーの内容から削除されます
