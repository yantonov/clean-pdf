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

# Create output directory
OUTPUT_DIR="$DIR/output"
mkdir -p "$OUTPUT_DIR"

# Determine stats.sh path
SCRIPT_DIR=$(dirname "$0")
STATS_SCRIPT="$SCRIPT_DIR/stats.sh"

# Check if stats.sh exists
if [ ! -f "$STATS_SCRIPT" ]; then
    echo "Error: stats.sh not found at $STATS_SCRIPT"
    exit 1
fi

# Process PDFs
for INPUT in "$DIR"/*.pdf; do
    [ -e "$INPUT" ] || { echo "No PDF files found in $DIR"; exit 0; }

    INPUT_FILE=$(basename "$INPUT")
    OUTPUT="$OUTPUT_DIR/${INPUT_FILE%.pdf}.pdf"

    echo "Processing: $INPUT_FILE"

    # Check for dangerous content using stats.sh
    "$STATS_SCRIPT" "$INPUT" > /dev/null 2>&1
    STATS_EXIT_CODE=$?

    if [ $STATS_EXIT_CODE -eq 0 ]; then
        # Clean file - just copy it
        echo "  [OK] No dangerous content detected - copying file"
        cp "$INPUT" "$OUTPUT"
        if [ -f "$OUTPUT" ]; then
            echo "  Copied to: $OUTPUT"
        else
            echo "  Failed to copy: $INPUT"
        fi
    else
        # Dangerous content detected - process with Ghostscript
        echo "  [WARN] Potentially dangerous content detected - cleaning with Ghostscript"

        "$GS_CMD" \
            -dSAFER \
            -dBATCH \
            -dNOPAUSE \
            -sDEVICE=pdfwrite \
            -dPDFSETTINGS="$PDFSETTINGS" \
            -sOutputFile="$OUTPUT" \
            "$INPUT"

        if [ -f "$OUTPUT" ]; then
            echo "  Cleaned PDF saved as: $OUTPUT"
        else
            echo "  Failed to sanitize: $INPUT"
        fi
    fi
    echo
done
