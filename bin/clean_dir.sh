#!/bin/sh
# -------------------------------
# Script: clean_pdf_dir
# Usage: clean_pdf_dir /path/to/directory
# Works on macOS, Linux, and Windows
# -------------------------------

# Detect GhostScript command based on OS
if command -v gswin64c.exe >/dev/null 2>&1; then
    GS_CMD="gswin64c.exe"
elif command -v gswin32c.exe >/dev/null 2>&1; then
    GS_CMD="gswin32c.exe"
elif command -v gs >/dev/null 2>&1; then
    GS_CMD="gs"
else
    echo "Error: GhostScript not found. Please install GhostScript."
    exit 1
fi

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
    "$GS_CMD" -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dPDFSETTINGS=//prepress \
       -sOutputFile="$OUTPUT" "$INPUT"

    if [ -f "$OUTPUT" ]; then
        echo "Cleaned PDF saved as: $OUTPUT"
    else
        echo "Failed to sanitize: $INPUT"
    fi
done
