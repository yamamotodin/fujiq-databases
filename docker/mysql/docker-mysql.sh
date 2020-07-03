#!/bin/bash

cd `dirname $0`

databases="fujiqdb"
if [ $# != 0 ]; then
  databases=$@
fi

echo "Migration Databases are ${databases}."

if docker ps -f "name=mysql" --format '{{.Status}}'|grep "^Up"; then
  echo '(Recycle mode) Please wait while count down. 10s'
  sleep 10
else
  docker stop mysql
  docker rm mysql
  docker-compose build
  docker-compose up -d
  echo Please wait while count down. 300s
  sleep 300
fi
cd ../../
for db in $databases; do
  if ! sh ./gradlew $db flywayClean flywayMigrate -i -Penv=local ; then
    echo "Database '${db}' migration is failed."
  fi
done

docker exec -it mysql /usr/bin/mysql -u root --password=mysql fujiqdb
