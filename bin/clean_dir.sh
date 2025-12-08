#!/bin/sh
# -------------------------------
# Script: clean_pdf_dir
# Usage: clean_pdf_dir /path/to/directory
# Works on macOS and Linux
# -------------------------------

# Check input
if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/directory"
    exit 1
fi

DIR="$1"

# Check if directory exists
if [ ! -d "$DIR" ]; then
    echo "Error: Directory not found: $DIR"
    exit 1
fi

# Process each PDF in the directory
for INPUT in "$DIR"/*.pdf; do
    # Skip if no PDF found
    [ -e "$INPUT" ] || { echo "No PDF files found in $DIR"; exit 0; }

    # Get absolute path of input file (portable)
    INPUT_DIR=$(dirname "$INPUT")
    INPUT_FILE=$(basename "$INPUT")
    OLDPWD=$(pwd)
    cd "$INPUT_DIR" || continue
    ABS_DIR=$(pwd)
    cd "$OLDPWD" || continue
    ABS_INPUT="$ABS_DIR/$INPUT_FILE"

    # Determine output file in same directory
    OUTPUT="$ABS_DIR/${INPUT_FILE%.pdf}_cleaned.pdf"

    # Run Ghostscript
    gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress \
       -sOutputFile="$OUTPUT" "$ABS_INPUT"

    echo "Cleaned PDF saved as: $OUTPUT"
done
