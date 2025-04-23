#!/bin/bash

# Set the folder containing the images (default to current directory)
DIR="${1:-.}"
cd "$DIR" || exit 1

# Rename files in reverse order to prevent name collisions
for file in $(ls pic*.webp | sort -r); do
  if [[ "$file" =~ ^pic([0-9]+)\.webp$ ]]; then
    num="${BASH_REMATCH[1]}"
    new_num=$(printf "%02d" $((10#$num + 1)))  # preserve leading 0
    new_name="pic${new_num}.webp"
    echo "Renaming $file → $new_name"
    mv "$file" "$new_name"
  fi
done