#!/bin/sh
# -------------------------------
# Script: clean_pdf_dir
# Usage: clean_pdf_dir /path/to/directory
# -------------------------------

# Detect Ghostscript command and platform
if command -v gswin64c.exe >/dev/null 2>&1; then
    GS_CMD="gswin64c.exe"
    PDFSETTINGS="//prepress"
elif command -v gswin32c.exe >/dev/null 2>&1; then
    GS_CMD="gswin32c.exe"
    PDFSETTINGS="//prepress"
elif command -v gs >/dev/null 2>&1; then
    GS_CMD="gs"
    PDFSETTINGS="/prepress"
else
    echo "Error: Ghostscript not found. Please install Ghostscript."
    exit 1
fi

# Validate input
if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/directory"
    exit 1
fi

DIR="$1"

if [ ! -d "$DIR" ]; then
    echo "Error: Directory not found: $DIR"
    exit 1
fi

# Create cleaned directory
CLEANED_DIR="$DIR/cleaned"
mkdir -p "$CLEANED_DIR"

# Process PDFs
for INPUT in "$DIR"/*.pdf; do
    [ -e "$INPUT" ] || { echo "No PDF files found in $DIR"; exit 0; }

    INPUT_FILE=$(basename "$INPUT")
    OUTPUT="$CLEANED_DIR/${INPUT_FILE%.pdf}.pdf"

    "$GS_CMD" \
        -dSAFER \
        -dBATCH \
        -dNOPAUSE \
        -sDEVICE=pdfwrite \
        -dPDFSETTINGS="$PDFSETTINGS" \
        -sOutputFile="$OUTPUT" \
        "$INPUT"

    if [ -f "$OUTPUT" ]; then
        echo "Cleaned PDF saved as: $OUTPUT"
    else
        echo "Failed to sanitize: $INPUT"
    fi
done
