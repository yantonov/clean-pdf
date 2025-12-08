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

# Create cleaned directory if it doesn't exist
CLEANED_DIR="$DIR/cleaned"
mkdir -p "$CLEANED_DIR"

# Process each PDF in the directory
for INPUT in "$DIR"/*.pdf; do
    # Skip if no PDF found
    [ -e "$INPUT" ] || { echo "No PDF files found in $DIR"; exit 0; }

    INPUT_FILE=$(basename "$INPUT")

    # Output file in cleaned directory
    OUTPUT="$CLEANED_DIR/${INPUT_FILE%.pdf}.pdf"

    # Run Ghostscript
    gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress \
       -sOutputFile="$OUTPUT" "$INPUT"

    if [ -f "$OUTPUT" ]; then
        echo "Cleaned PDF saved as: $OUTPUT"
    else
        echo "Failed to sanitize: $INPUT"
    fi
done
