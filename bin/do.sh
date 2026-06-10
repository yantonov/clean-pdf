#!/usr/bin/env sh
set -o errexit -o nounset

cd "$(dirname "$0")"

./convert.sh

./cleanup.sh

./rename.sh
