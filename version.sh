#!/bin/bash

BLOCKS_COUNT=3
VERSION_FILE="Version.txt"

function join { local IFS="$1"; shift; echo "$*"; }

block_idx=-1
case "$1" in
  "major")
    block_idx=0
    ;;
  "minor")
    block_idx=1
    ;;
  "patch")
    block_idx=2
    ;;
  *)
    echo "The script automatically bumps the OSXVnc application version"
    echo "Usage '$(basename "$0") major|minor|patch'"
    exit 1
    ;;
esac

current_version=`cat "$VERSION_FILE"`
IFS='.' read -r -a blocks <<< "$current_version"
if [ ${#blocks[@]} -ne $BLOCKS_COUNT ]; then
    echo "The current application version '$current_version' must include $BLOCKS_COUNT blocks of numbers"
    exit 1
fi
(( blocks[$block_idx]++ ))
for (( idx=$block_idx+1; idx<$BLOCKS_COUNT; idx++ )); do
    blocks[$idx]=0
done

new_version=$(join . ${blocks[@]})
echo "The updated version number: $new_version"
echo "$new_version" > "$VERSION_FILE"
git add "$VERSION_FILE"
git commit -m "Update to version $new_version"
git tag "v.$new_version"
