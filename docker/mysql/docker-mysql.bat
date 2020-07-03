@echo off

cd /d %~dp0

docker ps -a -f name=mysql| findstr "mysql" > nul
if errorlevel 1 (
docker-compose build
docker-compose up -d
echo Please wait while count down.
timeout /t 300
)

docker ps -f name=mysql | findstr "mysql" > nul
if errorlevel 1 (
docker start mysql
echo Please wait while count down.
timeout /t 30
)

cd ..\..\
call gradlew.bat fujiqdb flywayClean flywayMigrate -i -Penv=local

docker exec -it mysql /usr/bin/mysql -u root --password=mysql fujiqdb

