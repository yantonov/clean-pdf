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
PDFID_PATH="$SCRIPT_DIR/../../lib/pdfid.py"

# Check if PDFiD exists
if [ ! -f "$PDFID_PATH" ]; then
    echo "Error: PDFiD not found at $PDFID_PATH"
    exit 1
fi

echo "Checking PDF for executable content: $ABS_INPUT"
echo "------------------------------------------------"

# Run PDFiD using Python and capture output
PDFID_OUTPUT=$(python3 "$PDFID_PATH" "$ABS_INPUT")

# Display full output
echo "$PDFID_OUTPUT"

# Highlight potential executable tags
echo
echo "Summary of potential executable content:"
DANGEROUS_CONTENT=$(echo "$PDFID_OUTPUT" | grep -E '(/JavaScript|/JS|/AA|/Launch|/EmbeddedFile)')
echo "$DANGEROUS_CONTENT"

# Check if any dangerous content exists (count > 0)
DANGER_COUNT=0
if [ -n "$DANGEROUS_CONTENT" ]; then
    # Extract counts from the dangerous content lines and sum them
    DANGER_COUNT=$(echo "$DANGEROUS_CONTENT" | awk '{sum += $2} END {print sum}')
fi

# Return appropriate message and exit code
echo
if [ "$DANGER_COUNT" -gt 0 ]; then
    echo "[WARN] potentially dangerous content"
    exit 1
else
    echo "[OK]"
    exit 0
fi
