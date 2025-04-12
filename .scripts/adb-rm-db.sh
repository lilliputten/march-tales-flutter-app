#!/bin/sh
# Remove a `tracks-info.sqlite3` database from the Android VM
APP_NAME="team.march.march_tales_app"
ADB_DB_NAME="databases/tracks-info.sqlite3"
adb shell "run-as $APP_NAME rm -vf $ADB_DB_NAME"
