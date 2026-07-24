#!/usr/bin/env bash
# show-aa.sh - Show /AA content from a PDF using pdf-parser (script in bin, parser in lib)

set -e

# Check argument
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <pdf-file>"
    exit 1
fi

PDF_FILE="$1"

# Check that the PDF file exists
if [ ! -f "$PDF_FILE" ]; then
    echo "Error: PDF file '$PDF_FILE' does not exist"
    exit 2
fi

# Path to pdf-parser.py relative to this script
PDF_PARSER="$(dirname "$0")/../../lib/pdf-parser.py"

if [ ! -f "$PDF_PARSER" ]; then
    echo "Error: pdf-parser.py not found at '$PDF_PARSER'"
    exit 3
fi

# Run pdf-parser
python3 "$PDF_PARSER" -s /AA "$PDF_FILE"

