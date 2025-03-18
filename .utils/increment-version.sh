#!/bin/sh
# @desc Increment version number
# @changed 2024.12.02, 12:54

scriptsPath=$(dirname "$(echo "$0" | sed -e 's,\\,/,g')")
rootPath=`dirname "$scriptsPath"`
prjPath="$rootPath" # `pwd`

# Import config variables...
test -f "$scriptsPath/config.sh" && . "$scriptsPath/config.sh"

# Check basic required variables...
test -f "$scriptsPath/config-check.sh" && . "$scriptsPath/config-check.sh" --omit-publish-folder-check

# Update version code (if file specified)
if [ ! -z "$VERSION_CODE_FILE" ]; then
  VERSION_CODE_PATH="$rootPath/${VERSION_CODE_FILE}"
  VERSION_CODE="1"
  if [ -f "$VERSION_CODE_PATH" ]; then
    VERSION_CODE=`cat "$VERSION_CODE_PATH"`
    # Increment version code number
    VERSION_CODE=`expr $VERSION_CODE + 1`
  fi
  echo "$VERSION_CODE" > "$VERSION_CODE_PATH"
  echo "Updated version code: $VERSION_CODE"
fi

# Read version from file...
VERSION_PATH="$rootPath/${VERSION_FILE}"
# Update version
NEXT_PATCH_NUMBER="0"
if [ ! -f "$VERSION_PATH" ]; then
  echo "NO PREVIOUS VERSION INFO!"
  echo "0.0.0" > "$VERSION_PATH"
else
  PATCH_NUMBER=`cat "$VERSION_PATH" | sed "s/^\(.*\)\.\([0-9]\+\)$/\2/"`
  # Increment patch number
  NEXT_PATCH_NUMBER=`expr $PATCH_NUMBER + 1`
fi
BACKUP="$VERSION_PATH.bak"
cp "$VERSION_PATH" "$BACKUP" \
  && cat "$BACKUP" \
    | sed "s/^\(.*\)\.\([0-9]\+\)$/\1.$NEXT_PATCH_NUMBER/" \
    > "$VERSION_PATH" \
  && rm "$BACKUP" \
  && echo "Updated version: `cat $VERSION_PATH`" \
  && sh "$scriptsPath/update-build-variables.sh" \
  && VERSION=`cat "$VERSION_PATH"` \
  && echo "Updated version: $VERSION"
