#!/bin/bash

set -euo pipefail

# Check argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <new-post>"
  exit 1
fi

NEW_POST="$1"

ASSETS_BASE="/Users/nicole/nicoleshoblom.github.io/src/assets"
DROP_FOLDER="/Users/nicole/blog-assets-drop"
POSTS_FOLDER="/Users/nicole/nicoleshoblom.github.io/src/pages/posts"
TEMPLATE_FILE="$POSTS_FOLDER/ulsanday2.astro"

NEW_ASSETS_FOLDER="$ASSETS_BASE/$NEW_POST"
NEW_POST_FILE="$POSTS_FOLDER/$NEW_POST.astro"

# 1. Create the new assets folder
mkdir -p "$NEW_ASSETS_FOLDER"

# 2. Copy all .webp files from blog-assets-drop into the new assets folder
shopt -s nullglob
WEBP_FILES=("$DROP_FOLDER"/*.webp)

if [ ${#WEBP_FILES[@]} -eq 0 ]; then
  echo "No .webp files found in $DROP_FOLDER"
else
  cp "${WEBP_FILES[@]}" "$NEW_ASSETS_FOLDER"/
fi

# 3. Duplicate the template astro file with the new post name
if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "Template file not found: $TEMPLATE_FILE"
  exit 1
fi

cp "$TEMPLATE_FILE" "$NEW_POST_FILE"

echo "Done."
echo "Created folder: $NEW_ASSETS_FOLDER"
echo "Copied ${#WEBP_FILES[@]} .webp file(s)"
echo "Created post file: $NEW_POST_FILE"