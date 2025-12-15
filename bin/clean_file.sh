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

# Determine stats.sh path
SCRIPT_DIR=$(dirname "$0")
STATS_SCRIPT="$SCRIPT_DIR/stats.sh"

# Check if stats.sh exists
if [ ! -f "$STATS_SCRIPT" ]; then
    echo "Error: stats.sh not found at $STATS_SCRIPT"
    exit 1
fi

echo "Processing: $INPUT_FILE"

# Check for dangerous content using stats.sh
"$STATS_SCRIPT" "$ABS_INPUT" > /dev/null 2>&1
STATS_EXIT_CODE=$?

if [ $STATS_EXIT_CODE -eq 0 ]; then
    # Clean file - just copy it
    echo "  [OK] No dangerous content detected - copying file"
    cp "$ABS_INPUT" "$OUTPUT"
    if [ -f "$OUTPUT" ]; then
        echo "  Copied to: $OUTPUT"
    else
        echo "  Failed to copy: $INPUT"
        exit 1
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
        "$ABS_INPUT"

    if [ -f "$OUTPUT" ]; then
        echo "  Cleaned PDF saved as: $OUTPUT"
    else
        echo "  Failed to sanitize: $INPUT"
        exit 1
    fi
fi
