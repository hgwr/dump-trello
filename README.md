# dump-trello
Trello ボードをダンプする Ruby スクリプト

# インストール

    $ git clone https://github.com/hgwr/dump-trello.git
    $ cd dump-trello
    $ bundle install
    $ cp config.yml.sample config.yml

https://trello.com/app-key で開発者向けAPIキーを取得し、 config.yml の trello_developer_api_key: のあとに書き込みます。

次に、同じページのなかの「手動でトークンを生成できます」の「トークン」のリンク先から、
https://trello.com/1/token/approve まですすんで、トークン文字列を取得します。
そしてそのトークンを config.yml の trello_token: のあとに書き込みます。

# 使い方

## ボード一覧の表示

    $ bundle exec ruby ls-board.rb 
    Shigeru Hagiwara
    Name: Hgwr Test ID: XXXX_BOARD_ID_XXXX
    Name: Welcome Board ID: YYYY_BOARD_ID_YYYY

## ボードの JSON ダンプ

上で取得したボード ID を使ってボードを指定して、 JSON ダンプを得ます。

    $ bundle exec ruby dump-trello.rb XXXX_BOARD_ID_XXXX

リストごと、カードごと、コメントごとの JSON がダンプされます。

## ボードの Markdown ダンプ

上で取得したボード ID を使ってボードを指定して、 Markdown ダンプを得ます。

    $ bundle exec ruby dump-trello-md.rb XXXX_BOARD_ID_XXXX

