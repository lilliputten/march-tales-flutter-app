#!/bin/sh

# Google Play signup resources
# @see https://docs.flutter.dev/deployment/android#sign-the-app
# @see files:
# .scripts/create-signup-key.sh
# keystroke.jks
# android/key.properties

scriptsPath=$(dirname "$(echo "$0" | sed -e 's,\\,/,g')")
rootPath=`dirname "$scriptsPath"`
utilsPath="$rootPath/.utils"

# Import config variables (expected variable `$PUBLISH_FOLDER`)...
test -f "$utilsPath/config.sh" && . "$utilsPath/config.sh"

# Check basic required variables...
test -f "$utilsPath/config-check.sh" && . "$utilsPath/config-check.sh"

KEYSTROKE_FILE="E:/flutter-keystores/keystroke.jks"
KEYSTROKE_ALIAS="lilliputten-key"

keytool \
  -genkey -v -keystore $KEYSTROKE_FILE \
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 \
  -alias $KEYSTROKE_ALIAS
