#!/bin/sh
# Retrieve the `tracks-info.sqlite3` database from an Android VM to a local file
adb shell "run-as team.march.march_tales_app rm -vf databases/tracks-info.sqlite3"
