#!/bin/sh
# -------------------------------
# Script: clean_pdf
# Usage: clean_pdf /path/to/input.pdf
# Works on macOS and Linux
# -------------------------------

# Check input
if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/input.pdf"
    exit 1
fi

INPUT="$1"

# Check if file exists
if [ ! -f "$INPUT" ]; then
    echo "Error: File not found: $INPUT"
    exit 1
fi

# Get absolute path of input file (portable)
INPUT_DIR=$(dirname "$INPUT")
INPUT_FILE=$(basename "$INPUT")
OLDPWD=$(pwd)
cd "$INPUT_DIR" || exit 1
ABS_DIR=$(pwd)
cd "$OLDPWD" || exit 1
ABS_INPUT="$ABS_DIR/$INPUT_FILE"

# Determine output file in same directory
OUTPUT="$ABS_DIR/${INPUT_FILE%.pdf}_cleaned.pdf"

# Run Ghostscript
gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress \
   -sOutputFile="$OUTPUT" "$ABS_INPUT"

echo "Cleaned PDF saved as: $OUTPUT"
