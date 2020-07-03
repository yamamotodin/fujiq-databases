# fujiq-database

プロジェクト内のデータベースのモデルを定義します。

DBを起動するときは docker (最終有効バージョン 2.1.0.5, **NOT** 2.2.0 or higher) をインストールしてください。

##  ディレクトリ構成

* docker データベース定義をアプリケーションから利用するために起動するdockerイメージを世話する
* fujiqdb/src/main/resources マイグレーション対象のDBのスキーマとテストデータ（後述）

## docker の起動方法

localhost:3306 でmysqlが起動するために下記のコマンドを起動します。(５分くらいかかります）

** fujiqdb/docker/docker-mysql.{sh|bat} **

### 下記はdocker-mysql.*の実行の例です。

最終的に jac-annon-manaeg 等のアプリケーションから接続できるようになっていればよいです。

```
kooh:jac-annon-model yamamotodin$ sh fujiqdb/docker/mysql/docker-mysql.sh 
mysql
mysql
Building mysql
Step 1/4 : FROM mysql:5.7
 ---> e1e1680ac726
Step 2/4 : EXPOSE 3306
 ---> Using cache
 ---> e1044bd3f42a
Step 3/4 : ADD ./conf/custom.cnf /etc/mysql/conf.d/
 ---> Using cache
 ---> 12a624e7a254
Step 4/4 : CMD ["mysqld", "--general_log", "--general_log_file=/tmp/query.log"]
 ---> Using cache
 ---> ff0cebae2256
Successfully built ff0cebae2256
Successfully tagged mysql_mysql:latest
Creating mysql ... done
Please wait while count down. 300s
mysql: [Warning] Using a password on the command line interface can be insecure.
mysql: [Warning] Using a password on the command line interface can be insecure.
mysql: [Warning] Using a password on the command line interface can be insecure.
mysql: [Warning] Using a password on the command line interface can be insecure.
mysql: [Warning] Using a password on the command line interface can be insecure.
mysql: [Warning] Using a password on the command line interface can be insecure.
mysql: [Warning] Using a password on the command line interface can be insecure.
mysql: [Warning] Using a password on the command line interface can be insecure.
mysql: [Warning] Using a password on the command line interface can be insecure.
mysql: [Warning] Using a password on the command line interface can be insecure.
mysql: [Warning] Using a password on the command line interface can be insecure.
mysql: [Warning] Using a password on the command line interface can be insecure.
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 13
Server version: 5.7.27-log MySQL Community Server (GPL)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show tables;
+--------------------------+
| Tables_in_fujiqdb        |
+--------------------------+
...
+--------------------------+
30 rows in set (0.00 sec)


```

### 最終的に下記のようになってれば良いです
```
kooh:jac-annon-model yamamotodin$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                               NAMES
d178e0a578c9        mysql_mysql         "docker-entrypoint.s…"   5 minutes ago       Up 5 minutes        0.0.0.0:3306->3306/tcp, 33060/tcp   mysql

```

## スキーマのバージョンアップをしたいとき
* fujiqdb/src/main/resources マイグレーション対象のDBのスキーマが４つあります。
  * fujiqdb

どのDBも概ね同じ構成で、下記のディレクトリがあります
* migration /* 旧DDL相当 */
  * V2020_01_01
    * V2020_01_01_001__BATCH_TASK.sql
    * ...
* testdata /* 旧DML相当 */
  * V2020_01_01
    * ...

### DDL, DMLの ディレクトリ及びファイル名の命名規則
* ディレクトリ名 ex: `V2020_01_01`
  * 'V': 固定
  * '2020_01_01': 日付。**採番した日付で良いですが、マージする時点でこれより未来の日付がある場合はそれ以降の日付に書き換えてください。ファイル名も然り。**
* ファイル名 `V2020_01_01_001__BATCH_TASK.sql`
  * 'V': 固定
  * '2020_01_01': 日付。同上
  * '001': ディレクトリ内のファイルの連番 000-449までDDL(migration), 500-999までDML(testdata)
  * '__': （アンダーバー２つ）バージョンとdescriptionの区切り文字　アンダーバーで区切りかんたんな要約を書きましょう。

## 注意事項
* flywayは後ろを顧みません　なので `2020_01_05` のSQLが適用されたあと、`2020_01_04` のディレクトリを作成しマージしても、顧みられることは有りません。マージするときに運用注意。
* 当面は山本(yamamotodin@gmail.com)の面倒みます、レビューを受けてください。
