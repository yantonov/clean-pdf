#!/bin/bash

cd "$(dirname "$0")/../../lib"

PYTHON_SCRIPT="rename.py"

DIR="$1"
if [ -z "${DIR}" ]; then
    DIR=${HOME}/Downloads/output
fi

python3 "$PYTHON_SCRIPT" "$DIR"
