#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Path to the rename.py script
PYTHON_SCRIPT="$SCRIPT_DIR/../lib/rename.py"

# Check if argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Run the Python script with the provided directory
python3 "$PYTHON_SCRIPT" "$1"
