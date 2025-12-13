#!/bin/sh
# -------------------------------
# Script: clean_pdf
# Usage: clean_pdf /path/to/input.pdf
# Works on macOS, Linux, and Windows
# -------------------------------

# Detect Ghostscript command and PDFSETTINGS value
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

# Output file
OUTPUT="$ABS_DIR/${INPUT_FILE%.pdf}_cleaned.pdf"

# Run Ghostscript
"$GS_CMD" \
    -dSAFER \
    -dBATCH \
    -dNOPAUSE \
    -sDEVICE=pdfwrite \
    -dPDFSETTINGS="$PDFSETTINGS" \
    -sOutputFile="$OUTPUT" \
    "$ABS_INPUT"

if [ -f "$OUTPUT" ]; then
    echo "Cleaned PDF saved as: $OUTPUT"
else
    echo "Failed to sanitize: $INPUT"
    exit 1
fi
