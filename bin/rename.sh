#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

PYTHON_SCRIPT="$SCRIPT_DIR/../lib/rename.py"

DIR="$1"
if [ -z "${DIR}" ]; then
    DIR=${HOME}/Downloads/output
fi

python3 "$PYTHON_SCRIPT" "$DIR"
