# IMApp_Account（IM会計）をダイレクトホスト方式で運用

新居雅行 (nii@msyk.net)

IM会計をダイレクトホストで運用する場合のセットアップや利用方法について説明します。
開発当初はこの方法での運用が中心的であると考えていました。利用するコンピュータ上でのみ公開されるWebサイトとして、IM会計は稼働します。
PHPのサーバモードを利用して稼働させ、認証はなく、データはホーム直下の.im_dbフォルダにあるSQLite3のデータベースに保存します。

## 動作するための準備
PHP、git、composer、SQLite、Node.jsが稼働するようにしておいてください。必要なら、Apache等Webアプリケーションも用意してください。
私は普段はMacしか使っていません。この記事は基本的にMac上で動作させる手順をまとめています。
Macは「純正Unix」であることから、このシステムはLinux上でも同様に動きます。

最新のM1チップ（Apple silicon）を搭載したMac上各種開発ツールをインストールするならHomebrew（注１）を使うのが便利で確実です。
また、データベースシステムのSQLiteはmacOSに最初から装備されていますので、新たにインストールする必要はありません。
INTER-Mediatorは最新のPHPで稼働するように現在もメンテナンスは続けていますので、
```
$ brew install php
```
を実行してPHPの最新系列をインストールしておいてください。
PHP 7.4でも動作しますので、事情があって7系列で運用したいという方はそうしてください。
その場合は、```php```の代わりに```php@7.4```などとバージョンを指定してインストールすることが可能です。

Windows OSに関しては、この手順通りに同様な操作をすればWindows Subsystem for Linux (WSL)上でのインストールと稼働が可能なことは確認しました。

## セットアップ
このアプリケーションはcomposerによってセットアップされます。
まず、レポジトリをご自分のローカルマシン内の適当なフォルダにクローンしてください。
```
git clone https://github.com/msyk/IMApp_Account
cd IMApp_Account
```

これでIMApp_Accountディレクトリ内に移動していますので、以下のようにcomposerコマンドを実行します。
```
composer install
```
初めてインストールする場合には必要な環境をかき集め、構築しますので数分間かかります。

独自のレポジトリにこのアプリケーションを収めたいなら、GitHubのテンプレートレポジトリの機能を利用できます。
そうすれば、プライベートなレポジトリにアプリケーションや場合によってはバックアップデータを保持できます。

## アプリケーションの開始
アプリケーションを開始する簡単な方法は、phpのサーバモードを使うのが良いでしょう。
```
php -S localhost:9000
```
コマンド入力後、同じMac/PC等のブラウザで「 http://localhost:9000/ 」を開くと、アプリケーションにアクセスできます。

## Setup for S3

続いてAmazonのクラウドサービスAWS内に構築するストレージ「S3」に請求書・納品書・領収書などの関連帳票類を収める仕組みを構築します。（注２）

IM会計に必要な情報は、privateディレクトリに ```aws_settings.php``` というファイルを作ってそこに記述します。
このファイルにS3のアカウント情報などを保存などを保存します。
詳細は、privateディレクトリにあるREADME.mdファイルを読んでください。

S3側では、IAMサービスでS3のフルアクセス機能を持ったユーザを作っておく必要があります。
また、S3には帳票のファイルデータを保存するためのバケットを用意します。
バケット名はprivateディレクトリ内に作るaws_settings.phpというファイル内で指定する ```$rootBucket``` と同じものを設定してください。

## データベースに対する処理

```composer install```コマンドを実行すれば、データベースファイルがホーム直下の.im_dbディレクトリ内に作られ、スキーマが適用されます。もし、そのファイルが既に存在すれば、コマンド内で上書きするかそのままにするかを選択できます。

```composer db-backup```コマンドを実行すれば、現状のデータベースファイルをレポジトリのdb-backupディレクトリにコピーします。ファイル名にはタイムスタンプの文字列が追加されます。

```composer db-restore```コマンドを実行すれば、db-backupディレクトリにある一番新しいファイルが.im_dbディレクトリにコピーされます。

これにより、「IM会計」が取り扱っているデータはバックアップされた時点に復元されます。

## 「IM会計」アップデートの作業

IMApp_Accountのレポジトリをクローンして運用している場合、```composer update```コマンドを実行すれば、INTER-Mediatorを含むPHPやJavaScriptのライブラリを更新します。

このコマンドでは、ビューの定義を再定義しますが、テーブル定義などのスキーマの変更があった場合には、先にスキーマの変更をしてから、```composer update```コマンドを入力してください。
そうしないと、コマンドの途中でエラーが出ると想定されますので、スキーマ変更後にもう一度、```composer update```コマンドを入れます。

この作業を行わないと「会計項目詳細編集」画面に移動したあと、「回転する歯車」画像が出て先に進めなくなってしまいます。

スキーマの変更は今後ほとんど発生しないと思われます。開発初期には頻繁に行いましたが、一定の機能を実装し終えた2022年3月末以降は変更は極力抑える方針です。変更せざるを得ない場合は変更情報をここに記載します。

現状のデータベースをいつの時点で作成したかをレポジトリの日付で確認し（例えば、```git log```を利用）、それ以降の変更の履歴を適用することで、必要なコマンドを入力してスキーマ更新します。通常はフィールドの追加が多いと思われます。
そうすれば、データをそのままに、データベースやもちろん他のファイルも含めて更新が可能です。
ただ、念のため、前述の「データベースに対する処理」に記載の方法で、データベースファイルのバックアップを取っておくことをお勧めします。

## スキーマ変更の履歴とDBスキーマの更新方法

### 2023-11-23修正

```
echo "ALTER TABLE account ADD COLUMN 'minus' INTEGER"|sqlite3 ~/.im_db/imapp_account.sqlite3
echo "ALTER TABLE assort_pattern ADD COLUMN 'order' INTEGER"|sqlite3 ~/.im_db/imapp_account.sqlite3
sqlite3 ~/.im_db/imapp_account.sqlite3 < lib/schema_views.sql
```

### 2023-04-15修正

2023-04-15の```commit dccbf42c60ac7d1dc443b6ec4f0dd158d3c235ad```において、itemテーブルに変更が発生しました。また、ビューについても変更が発生しました。
それ以前のデータベースをそのまま使いたい場合は、以下のコマンドをそのままコピー&amp;ペーストで入力して、フィールドの追加をお願いします。レポジトリのルートをカレントディレクトにしてコマンドを実行してください。

```
echo "ALTER TABLE item ADD COLUMN is_other_exp INTEGER"|sqlite3 ~/.im_db/imapp_account.sqlite3
sqlite3 ~/.im_db/imapp_account.sqlite3 < lib/schema_views.sql
```

### 2022-04-01修正

2022-04-01の```commit fd2f53797d1d6df5583cc0b5045960e6cab0cfde```において、accountテーブルに変更が発生しました。
それ以前のデータベースをそのまま使いたい場合は、以下のコマンドをそのままコピー&amp;ペーストで入力して、フィールドの追加をお願いします。

```echo "ALTER TABLE account ADD COLUMN comment TEXT"|sqlite3 ~/.im_db/imapp_account.sqlite3```

正常に終了したら```composer update```コマンドを実行してください。

### 2022-04-14修正

2022-04-14の```commit 0ebc142269697422252779a2aaf048005e402fd3```において、account、detail、operationlogテーブルに変更が発生しました。
それ以前のデータベースをそのまま使いたい場合は、以下のコマンドをそのままコピー&amp;ペーストで入力して、フィールドの追加をお願いします。

```
echo "ALTER TABLE operationlog ADD COLUMN key_value INTEGER"|sqlite3 ~/.im_db/imapp_account.sqlite3
echo "ALTER TABLE operationlog ADD COLUMN edit_field VARCHAR(20)"|sqlite3 ~/.im_db/imapp_account.sqlite3
echo "ALTER TABLE operationlog ADD COLUMN edit_value TEXT"|sqlite3 ~/.im_db/imapp_account.sqlite3
echo "ALTER TABLE account ADD COLUMN 'delete' INTEGER"|sqlite3 ~/.im_db/imapp_account.sqlite3
echo "ALTER TABLE detail ADD COLUMN 'delete' INTEGER"|sqlite3 ~/.im_db/imapp_account.sqlite3
```
正常に終了したら```composer update```コマンドを実行してください。

### 2022-05-11修正

2022-05-11の```commit 630b9e787b98c4a7f26f4c4b872c0a3688c6d222```において、スキーマ定義に以下のインデックス作成ステートメントを追加しました。
それ以前のデータベースをそのまま使いたい場合は、以下のコマンドをそのままコピー&amp;ペーストで入力して、フィールドの追加をお願いします。

```
echo 'CREATE INDEX account_delete ON account ("delete")'|sqlite3 ~/.im_db/imapp_account.sqlite3
echo 'CREATE INDEX detail_delete ON detail ("delete")'|sqlite3 ~/.im_db/imapp_account.sqlite3
```

### 2022-09-30修正

2022-05-11の```commit 630b9e787b98c4a7f26f4c4b872c0a3688c6d222```において、スキーマ定義に以下のインデックス作成ステートメントを追加しました。
それ以前のデータベースをそのまま使いたい場合は、以下のコマンドをそのままコピー&amp;ペーストで入力して、フィールドの追加をお願いします。

```
echo 'ALTER TABLE preference ADD COLUMN copy_detail INTEGER DEFAULT 0 NOT NULL'|sqlite3 ~/.im_db/imapp_account.sqlite3
sqlite3 ~/.im_db/imapp_account.sqlite3 < lib/schema_update01.sql
```

# 独自のレポジトリでの運用

このレポジトリはパブリックなので、当然ながらセンシティブな情報はここにはアップロードできません。このレポジトリがプライベートであることで問題が解決するなら、GitHubのテンプレート機能を使ってみましょう。プライベートなレポジトリであれば、もしあなたが気にしないのであれば、プライベートな情報を保持できます。例えば、データのバックアップや独自のページを追加できます。一方、そのようにすると、オリジナルのレポジトリは切り離され、オリジナルのレポジトリへの更新結果を反映させるのは難しくなります。

- プライベートなレポジトリを作成するには、このレポジトリのトップページにある「Use this Template」をクリックして、レポジトリを作ります。
- 作ったレポジトリを、クローンして利用してください。
- ```composer db-backup```や```composer db-restore```コマンドにより、レポジトリ内にデータのバックアップを作成したり、リストアができます。
- 具体的な手順についてはprivateディレクトリのREADME.mdファイルをご覧ください。
- 作成したファイルなどをレポジトリ側に反映させるために、.gitignoreファイルから、 「db-backup」「private/\*.sql」「private/\*.php」の記述を削除してください。

レポジトリにプライベートな情報を保存するのは安全でしょうか？　この問いへの回答は確かに難しいのですが、少なくとも管理の甘いオンプレミスなサーバよりよほど安全ではないでしょうか。

---
注１）Macに各種開発ツールをインストールするにはHomebrewという仕組みを使うのが便利で確実です。 https://brew.sh/index_ja にアクセスすると日本語の本家ページが開きます。そこに書かれた１行のインストールコマンドをコピーしてターミナルにペーストするだけでHomebrewが実行可能になります。このページにはさまざまな有益な情報が満載ですので、探索してみてください。

注２）S3はクラウド上にファイル保存できる仕組みで、税務書類など長期間に渡って参照されることなく保存しておくだけといった利用形態ならきわめて低料金で利用できます。青色申告に使った帳票類は７年間、法人の場合は帳票によって10年間の保存義務がありますが、その間ほとんどダウンロードして表示させることはありません。こうした利用形態にはうってつけの仕組みです。改正電子帳簿保存法ではタイムスタンプの付与などに関して大幅に条件が緩和されましたが、緩和の条件としてクラウド上に保存した帳票の追加や訂正などが生じた時にその履歴が記録されるシステムであることという要件が加わりました。S3はそうした操作記録がすべて残される上に、訂正する前のファイルも復元してダウンロードできます。これらの機能により、立入り税務調査などの場合にも対応できるシステムを構築することができるわけです。

## 謝辞

- haya-san ドキュメントの監修ありがとうございます。