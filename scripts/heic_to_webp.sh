#!/bin/bash

# Allow passing input and output directories as arguments
INPUT_DIR="${1:-.}"           # Default to current directory if not provided
OUTPUT_DIR="${2:-webp_output}" # Default to 'webp_output' if not provided

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through all HEIC files in the input directory
for file in "$INPUT_DIR"/*.HEIC; do
  [ -e "$file" ] || continue  # Skip if no .heic files found

  filename=$(basename "$file" .HEIC)
  output_file="$OUTPUT_DIR/${filename}.webp"

  echo "Converting $file → $output_file"

  magick "$file" -strip -quality 75 -define webp:method=4 "$output_file"
done

# Loop through all JPG files in the input directory
for file in "$INPUT_DIR"/*.jpg; do
  [ -e "$file" ] || continue  # Skip if no .jpg files found

  filename=$(basename "$file" .jpg)
  output_file="$OUTPUT_DIR/${filename}.webp"

  echo "Converting $file → $output_file"

  magick "$file" -strip -quality 75 -define webp:method=4 "$output_file"
done

echo "✅ Conversion complete. Files saved in '$OUTPUT_DIR'"

#terminal commands
#/Users/nicole/nicoleshoblom.github.io/scripts/heic_to_webp.sh /Users/nicole/Downloads /Users/nicole/Downloads

#/Users/nicole/nicoleshoblom.github.io/scripts/heic_to_webp.sh /Users/nicole/Downloads/Photos-1-001 /Users/nicole/nicoleshoblom.github.io/src/assets/kagoshima_20ksteps