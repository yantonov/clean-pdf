#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$SCRIPT_DIR/../../lib"

echo "Installing pdfid and pdf-parser into $INSTALL_DIR ..."

# Create the directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Base URL for Didier Stevens Suite
REPO_URL="https://raw.githubusercontent.com/DidierStevens/DidierStevensSuite/master"

# -----------------------------
# Install pdfid.py
# -----------------------------
echo "Downloading pdfid.py ..."
curl -L "$REPO_URL/pdfid.py" -o "$INSTALL_DIR/pdfid.py"
chmod +x "$INSTALL_DIR/pdfid.py"

# -----------------------------
# Install pdf-parser.py
# -----------------------------
echo "Downloading pdf-parser.py ..."
curl -L "$REPO_URL/pdf-parser.py" -o "$INSTALL_DIR/pdf-parser.py"
chmod +x "$INSTALL_DIR/pdf-parser.py"

echo "Installation complete!"
echo "Run with: $INSTALL_DIR/pdfid.py <file.pdf> or $INSTALL_DIR/pdf-parser.py <file.pdf>"
