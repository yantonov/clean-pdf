#!/usr/bin/env sh
set -o errexit -o nounset

cd "$(dirname "$0")"

./service/convert.sh

./service/cleanup.sh

./service/rename.sh
