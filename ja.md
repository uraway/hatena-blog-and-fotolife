# hatena-blog-entry-post

このパッケージを使えば、Atomから[はてなブログ](http://hatenablog.com/)にエントリーを投稿、[フォトライフ](http://f.hatena.ne.jp/)に画像をアップロードすることが出来ます。

## エントリーを投稿する

![post](https://cloud.githubusercontent.com/assets/15242484/15038403/6d8b222a-12de-11e6-8ce5-60257b8dc153.gif)

## エントリーを更新する
![update](https://cloud.githubusercontent.com/assets/15242484/15038407/76a75a54-12de-11e6-971f-68ef5097a13b.gif)

エントリーの次の要素を扱うことが出来ます:
- タイトル (内容の見出し(#)がタイトルになります)
- カテゴリー
- 下書きか公開か

#### カテゴリーを編集する
- カテゴリーテクストを入力します
- Enterを押して、カテゴリーアイテムに追加します
- カテゴリーリストをクリックして、アイテムを削除することも出来ます

## 画像をアップロードする

![](https://zippy.gfycat.com/HardtofindDampIrishredandwhitesetter.gif)

## コマンド
- **Post Current File (⌥⌘P)** エディタのアクティブなファイルを投稿します
- **Post Selection (⇧⌥⌘P)** エディタの選択部分を投稿します

## 必要な設定
このパッケージを使ってエントリーを投稿するには、以下の情報を設定する必要があります。各フィールドにコピー&ペーストで入力して下さい

画像のアップロードには、はてなIDとAPIキーを使用します。

- はてなID
- [ブログ URL](http://blog.hatena.ne.jp/my/config)
- [API キー](http://blog.hatena.ne.jp/my/config/detail)

## オプション

- Open After Post

エントリーを投稿後、そのURLを開きます

- Remove Title

エントリーのタイトルとなる見出し(#)がエントリーの内容から削除されます
