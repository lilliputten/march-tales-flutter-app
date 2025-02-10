#!/bin/sh
# Format and analyze the code
dart run import_sorter:main \
&& dart format . \
&& dart analyze . \
&& echo Done
