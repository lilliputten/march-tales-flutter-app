#!/bin/sh
# @desc Create apk/aab build
# @changed 2025.03.18, 05:06

if [ $# -lt 1 ]; then
  echo "Usage: $0 [--apk] [--aab]"
  exit 0
fi

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

APK_FOLDER="build/app/outputs/apk/release"
AAB_FOLDER="build/app/outputs/bundle/release"

if [[ "$ARGS" =~ .*--apk.* ]]; then
  echo "Generating apk build $PROJECT_INFO..."
  flutter build apk \
    --build-name=$VERSION \
    --dart-define-from-file=.env \
    && echo "See release in $APK_FOLDER" \
    && ls -lah $APK_FOLDER/*.apk \
    && echo "OK"
fi

# Create signed bundle (aab)
if [[ "$ARGS" =~ .*--aab.* ]]; then
  echo "Generating aab bundle $PROJECT_INFO..."
  flutter build appbundle \
    --build-name=$VERSION \
    --dart-define-from-file=.env \
    && echo "See release in $AAB_FOLDER" \
    ; ls -lah $AAB_FOLDER/*.aab \
    && echo "OK"
fi

