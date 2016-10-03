#!/usr/bin/env bash

set -e

TILE_GEN_DIR="$( cd "$1" && pwd )"
POOL_DIR="$( cd "$2" && pwd )"

PCF=${TILE_GEN_DIR}/bin/pcf

cd ${POOL_DIR}

echo "No integration tests in place yet"

exit 0

