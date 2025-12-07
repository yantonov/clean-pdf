#!/bin/sh
# -------------------------------
# Script: check_pdf_exec.sh
# Usage: check_pdf_exec.sh /path/to/input.pdf
# Checks for executable content using PDFiD located in ../lib
# -------------------------------

# Check input
if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/input.pdf"
    exit 1
fi

INPUT="$1"

# Check if input file exists
if [ ! -f "$INPUT" ]; then
    echo "Error: File not found: $INPUT"
    exit 1
fi

# Get absolute path of input (portable)
INPUT_DIR=$(dirname "$INPUT")
INPUT_FILE=$(basename "$INPUT")
OLDPWD=$(pwd)
cd "$INPUT_DIR" || exit 1
ABS_DIR=$(pwd)
cd "$OLDPWD" || exit 1
ABS_INPUT="$ABS_DIR/$INPUT_FILE"

# Determine script directory
SCRIPT_DIR=$(dirname "$0")
# Assume lib is sibling of bin
PDFID_PATH="$SCRIPT_DIR/../lib/pdfid.py"

# Check if PDFiD exists
if [ ! -f "$PDFID_PATH" ]; then
    echo "Error: PDFiD not found at $PDFID_PATH"
    exit 1
fi

echo "Checking PDF for executable content: $ABS_INPUT"
echo "------------------------------------------------"

# Run PDFiD using Python
python3 "$PDFID_PATH" "$ABS_INPUT"

# Highlight potential executable tags
echo
echo "Summary of potential executable content:"
python3 "$PDFID_PATH" "$ABS_INPUT" | grep -E '(/JavaScript|/JS|/AA|/Launch|/EmbeddedFile)'
