#!/bin/sh
# Retrieve a `tracks-info.sqlite3` database from the Android VM to a local file
mkdir -p .databases
APP_NAME="team.march.march_tales_app"
ADB_DB_NAME="databases/tracks-info.sqlite3"
DATE_ID=`date "+%y%m%d-%H%M"`
LOCAL_DB_FOLDER=".databases"
LOCAL_DB_NAME="$LOCAL_DB_FOLDER/db-tracks-info-$DATE_ID.sqlite3"
adb shell "run-as $APP_NAME cat $ADB_DB_NAME" > "$LOCAL_DB_NAME"
ls -lah "$LOCAL_DB_FOLDER" | grep sqlite
