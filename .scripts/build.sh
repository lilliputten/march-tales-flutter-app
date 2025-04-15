#!/bin/sh
# @desc Create apk/aab build
# @changed 2025.04.15, 15:23

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

VERSION_CODE_PATH="$rootPath/${VERSION_CODE_FILE}"
VERSION_CODE=`cat "$VERSION_CODE_PATH"`

# TIMESTAMP=`date -r "$VERSION_PATH" "+%Y.%m.%d %H:%M:%S %z"`
# TIMETAG=`date -r "$VERSION_PATH" "+%y%m%d-%H%M"`

# Create apk build
if [[ "$ARGS" =~ .*--apk.* ]]; then
  APK_FOLDER="build/app/outputs/apk/release"
  echo "Generating apk build $PROJECT_INFO #${VERSION_CODE}..."
  flutter build apk \
    --build-name=$VERSION \
    --dart-define-from-file=.env \
    && echo "See release in $APK_FOLDER" \
    && ls -lah $APK_FOLDER/*${VERSION}*.apk \
    && echo "OK"
fi

# Create signed bundle (aab)
if [[ "$ARGS" =~ .*--aab.* ]]; then
  AAB_FOLDER="build/app/outputs/bundle/release"
  echo "Generating aab bundle $PROJECT_INFO #${VERSION_CODE}..."
  DEBUG_INFO_PATH="build/app/intermediates/merged_native_libs/release/out/lib"
  DEBUG_INFO_ARC="debug-symbols-${VERSION}-${VERSION_CODE}.zip"
  flutter build appbundle \
    --build-name=$VERSION \
    --dart-define-from-file=.env \
    --obfuscate \
    --split-debug-info="debug-info/"
  echo "Creating the debug symbols archive..."
  cd "$DEBUG_INFO_PATH" && zip -r "$DEBUG_INFO_ARC" * ; cd -
  mv "$DEBUG_INFO_PATH/$DEBUG_INFO_ARC" "$AAB_FOLDER/"
  echo "See release in $AAB_FOLDER"
  cd $AAB_FOLDER && ls -lah *${VERSION}* ; cd -
  echo "OK"
fi

