#!/usr/bin/env bash
source "$(dirname "$0")/common.sh"

VARIANT="$1"
JOBS="${2:-1}"
if [[ "$JOBS" -gt 1 ]]; then
  PRE="taskset -c 1"
else
  PRE=""
fi
BUILD_ROOT="$BUILD_ROOT_BASE/$VARIANT"

# Create a timestamp (format: YYYYMMDD_HHMMSS)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Results directory with timestamp subfolder
RESULTS_ROOT="$RESULTS_ROOT_BASE/$VARIANT/$TIMESTAMP"
mkdir -p "$RESULTS_ROOT"

cd "$BUILD_ROOT"

for i in $(seq 1 "$RUNS"); do
  OUT="$RESULTS_ROOT/result_run$i.json"
  echo "[*] Running $VARIANT - Run #$i"
  eval "$PRE \"$LIT\" -j \"$JOBS\" External/SPEC/ -o \"$OUT\""
done
