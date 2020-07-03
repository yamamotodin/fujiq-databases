#Dockerfile

#使うDockerイメージ
FROM mysql:5.7

#ポートを開ける
EXPOSE 3306

#MySQL設定ファイルをイメージ内にコピー
ADD ./conf/custom.cnf /etc/mysql/conf.d/

#docker runに実行される
CMD ["mysqld", "--general_log", "--general_log_file=/tmp/query.log"]
