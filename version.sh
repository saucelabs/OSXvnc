#!/bin/bash

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

current_version=`cat Version.txt`
IFS='.' read -r -a blocks <<< "$current_version"
if [ ${#blocks[@]} -ne 3 ]; then
    echo "The current application version '$current_version' must include three blocks of numbers"
    exit 1
fi
(( blocks[$block_idx]++ ))

new_version=$(join . ${blocks[@]})
echo "The updated version number: $new_version"
echo "$new_version" > Version.txt
git tag "v.$new_version"
