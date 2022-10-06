# IMApp_Account（IM会計）

新居雅行 (nii@msyk.net)

[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/msyk/IMApp_Account/blob/master/README.en.md)

主に個人事業主をターゲットとした会計アプリケーション。INTER-Mediatorで開発しました。正式名称はまだ決めていませんが、「IM会計」と呼んでください。

## 2022年スタートした電子帳簿保存法に対応

この会計アプリケーションは作成者の新居が自身で必要な用途に向けて作ったものであって、特定の方向けに作ったものではありません。2022年1月1日にスタートした令和3年度税制改正では、国税関係帳簿書類の電子保存手続について、簡素化の観点から大幅な見直しが行われました。これにより、帳簿書類の電子保存が個人事業主など小規模な事業主にも簡単にできるようになりましたが、そのためのシステムを独自に準備するのはとてもハードルの高いものでした。

今回の改正電子帳簿保存法（電帳法）では、紙で受領した書類のスキャナ保存等の要件が大幅に緩和された一方で、電子取引については紙出力による保存が認められなくなるなど、多くの事業者にはインパクトの大きいものでした。これら要件を当システムではクリアできるようにさまざまな工夫を加えました。特に帳票の登録や修正・追加が行われた場合にはその内容と履歴が改変されないようシステムを用意する必要がありますがこの「IM会計」（仮称）はAmazonが提供するクラウド、AWS上に帳票を保存するようにして電帳法の求める要件をクリアしています。

全ソースを公開していますので、自由に改変して使っていただいて構いません。機能についての要望があればもちろんお伺いしますが、自分で便利であると思ったものは実装するかもしれませんが、そうでないものは実装しないかもしれません。もし、ご自分用に改造して欲しいという場合は、原則として請負業務としてお引き受けすることはやぶさかではありません。

## 動作するための準備
PHP、git、composer、SQLite、Node.jsが稼働するようにしておいてください。必要なら、Apache等Webアプリケーションも用意してください。
私は普段はMacしか使っていません。この記事は基本的にMac上で動作させる手順をまとめています。Macは「純正Unix」であることから、このシステムはLinux上でも同様に動きます。

最新のM1チップ（Apple silicon）を搭載したMac上各種開発ツールをインストールするならHomebrew（注１）を使うのが便利で確実です。また、データベースシステムのSQLiteはmacOSに最初から装備されていますので、新たにインストールする必要はありません。PHPは2022年３月17日現在、既に安定版の8.0.17が配布されていますので、
```
$ brew install php@8.0
```
を実行してPHP 8系列をインストールしておいてください。PHP 7でも動作しますので、事情があって7系列で運用したいという方はそうしてください。

Windows OSに関しては、この手順通りに同様な操作をすればWindows Subsystem for Linux (WSL)上でのインストールと稼働が可能なことは確認しました。

## セットアップ
このアプリケーションはcomposerによってセットアップされます。まず、レポジトリをご自分のローカルマシン内の適当なフォルダにクローンしてください。
```
git clone https://github.com/msyk/IMApp_Account
cd IMApp_Account
```

これでIMApp_Accountディレクトリ内に移動していますので、以下のようにcomposerコマンドを実行します。
```
composer install
```
初めてインストールする場合には必要な環境をかき集め、構築しますので数分間かかります。

独自のレポジトリにこのアプリケーションを収めたいなら、GitHubのテンプレートレポジトリの機能を利用できます。そうすれば、プライベートなレポジトリにアプリケーションや場合によってはバックアップデータを保持できます。


## アプリケーションの開始
アプリケーションを開始する簡単な方法は、phpのサーバモードを使うのが良いでしょう。
```
php -S localhost:9000
```
コマンド入力後、同じMac/PC等のブラウザで「 http://localhost:9000/ 」を開くと、アプリケーションにアクセスできます。

## Setup for S3

続いてAmazonのクラウドサービスAWS内に構築するストレージ「S3」に請求書・納品書・領収書などの関連帳票類を収める仕組みを構築します。（注２）

まず最初にS3側にIAMサービスでS3のフルアクセス機能を持ったユーザを作っておく必要があります。続いて、帳票のファイルデータを保存するためのバケットを用意します。バケット名はprivateディレクトリ内に作るaws_settings.phpというファイル内で指定する ```$rootBucket``` と同じものを設定してください。

詳細は、privateディレクトリにあるREADME.mdファイルを読んでください。このディレクトリに、S3のアカウント情報などを保存した ```aws_settings.php``` というファイルを作ります。

## データベースに対する処理

```composer install```コマンドを実行すれば、データベースファイルがホーム直下の.im_dbディレクトリ内に作られ、スキーマが適用されます。もし、そのファイルが既に存在すれば、コマンド内で上書きするかそのままにするかを選択できます。

```composer db-backup```コマンドを実行すれば、現状のデータベースファイルをレポジトリのdb-backupディレクトリにコピーします。ファイル名にはタイムスタンプの文字列が追加されます。

```composer db-restore```コマンドを実行すれば、db-backupディレクトリにある一番新しいファイルが.im_dbディレクトリにコピーされます。

これにより、「IM会計」が取り扱っているデータはバックアップされた時点に復元されます。

# 「IM会計」アップデートの作業

IMApp_Accountのレポジトリをクローンして運用している場合、```composer update```コマンドを実行すれば、INTER-Mediatorを含むPHPやJavaScriptのライブラリを更新します。

このコマンドでは、ビューの定義を再定義しますが、テーブル定義などのスキーマの変更があった場合には、先にスキーマの変更をしてから、```composer update```コマンドを入力してください。
そうしないと、コマンドの途中でエラーが出ると想定されますので、スキーマ変更後にもう一度、```composer update```コマンドを入れます。

この作業を行わないと「会計項目詳細編集」画面に移動したあと、「回転する歯車」画像が出て先に進めなくなってしまいます。

スキーマの変更は今後ほとんど発生しないと思われます。開発初期には頻繁に行いましたが、一定の機能を実装し終えた2022年3月末以降は変更は極力抑える方針です。変更せざるを得ない場合は変更情報をここに記載します。

現状のデータベースをいつの時点で作成したかをレポジトリの日付で確認し（例えば、```git log```を利用）、それ以降の変更の履歴を適用することで、必要なコマンドを入力してスキーマ更新します。通常はフィールドの追加が多いと思われます。
そうすれば、データをそのままに、データベースやもちろん他のファイルも含めて更新が可能です。
ただ、念のため、前述の「データベースに対する処理」に記載の方法で、データベースファイルのバックアップを取っておくことをお勧めします。

## スキーマ変更の履歴とDBスキーマの更新方法

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
echo ' ALTER TABLE preference ADD COLUMN copy_detail INTEGER DEFAULT 0 NOT NULL'|sqlite3 ~/.im_db/imapp_account.sqlite3
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
