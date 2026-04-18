#!/bin/bash
# Script to generate extension icons in required sizes from a source SVG
# Requires Inkscape or rsvg-convert to be installed

SIZES=(16 32 48 128)
SOURCE_SVG="icon.svg"

# Check for rsvg-convert first, then fall back to Inkscape
if command -v rsvg-convert &> /dev/null; then
  CONVERTER="rsvg"
elif command -v inkscape &> /dev/null; then
  CONVERTER="inkscape"
else
  echo "Error: Neither rsvg-convert nor Inkscape found. Please install one of them."
  exit 1
fi

if [ ! -f "$SOURCE_SVG" ]; then
  echo "Error: Source SVG file '$SOURCE_SVG' not found."
  exit 1
fi

for SIZE in "${SIZES[@]}"; do
  OUTPUT="icon${SIZE}.png"
  echo "Generating ${OUTPUT}..."
  if [ "$CONVERTER" = "rsvg" ]; then
    rsvg-convert -w $SIZE -h $SIZE "$SOURCE_SVG" -o "$OUTPUT"
  else
    inkscape --export-png="$OUTPUT" -w $SIZE -h $SIZE "$SOURCE_SVG" 2>/dev/null
  fi
  if [ $? -eq 0 ]; then
    echo "  -> ${OUTPUT} created successfully."
  else
    echo "  -> Failed to create ${OUTPUT}."
  fi
done

echo "Done."
