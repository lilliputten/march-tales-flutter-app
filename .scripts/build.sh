#!/bin/sh
# @desc Create/update version tag (from build folder)
# @changed 2025.01.22, 21:19

# scriptsPath=$(dirname "$(echo "$0" | sed -e 's,\\,/,g')")
# rootPath=`dirname "$scriptsPath"`
# prjPath="$rootPath" # `pwd`
scriptsPath=$(dirname "$(echo "$0" | sed -e 's,\\,/,g')")
rootPath=`dirname "$scriptsPath"`
utilsPath="$rootPath/.utils"

# Import config variables (expected variable `$PUBLISH_FOLDER`)...
test -f "$utilsPath/config.sh" && . "$utilsPath/config.sh"

# Check basic required variables...
test -f "$utilsPath/config-check.sh" && . "$utilsPath/config-check.sh"

PROJECT_INFO=`cat "$rootPath/$PROJECT_INFO_FILE"`
# APP_ID=`cat "$rootPath/$APP_ID_FILE"`
VERSION_PATH="$rootPath/${VERSION_FILE}"
VERSION=`cat "$VERSION_PATH"`
# TIMESTAMP=`date -r "$VERSION_PATH" "+%Y.%m.%d %H:%M:%S %z"`
# TIMETAG=`date -r "$VERSION_PATH" "+%y%m%d-%H%M"`

echo "Generating build $PROJECT_INFO..."

APK_FOLDER="build/app/outputs/apk/release"

flutter build apk \
  --build-name=$VERSION \
  --dart-define-from-file=.env \
  && echo "See release in $APK_FOLDER:" \
  && ls -lah $APK_FOLDER/*.apk \
  && echo "OK"

