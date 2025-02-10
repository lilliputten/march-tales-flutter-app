#!/bin/sh
# Retrieve the `tracks-info.sqlite3` database from an Android VM to a local file
adb shell "run-as team.march.march_tales_app cat databases/tracks-info.sqlite3" > databases/db-tracks-info.sqlite3
