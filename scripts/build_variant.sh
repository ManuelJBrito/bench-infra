#!/usr/bin/env bash
source "$(dirname "$0")/common.sh"

VARIANT="$1"
RUN_TYPE="${2:-ref}"  # test or ref(default)

BUILD_ROOT="$BUILD_ROOT_BASE/$VARIANT"
mkdir -p "$BUILD_ROOT"

# Load FLAGS from variant JSON file
VARIANT_FILE="$VARIANTS/${VARIANT}.json"
if [[ ! -f "$VARIANT_FILE" ]]; then
  echo "Variant file not found: $VARIANT_FILE" >&2
  exit 1
fi

# Extract FLAGS value using jq
VARIANT_FLAGS=$(jq -r '.FLAGS' "$VARIANT_FILE")
CFLAGS="$COMMON_FLAGS $VARIANT_FLAGS"

# Configure the build
cmake -GNinja \
  -B "$BUILD_ROOT" \
  -S "$TEST_SUITE_DIR" \
  -DCMAKE_C_FLAGS="$CFLAGS" \
  -DCMAKE_C_COMPILER="$CC" \
  -DCMAKE_CXX_COMPILER="$CXX" \
  -DTEST_SUITE_SPEC2017_ROOT="$SPEC_DIR" \
  -DTEST_SUITE_RUN_TYPE="$RUN_TYPE"

cd "$BUILD_ROOT"
ninja -j"$NINJA_JOBS" External/SPEC/all
