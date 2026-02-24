#!/usr/bin/env bash
set -euo pipefail

# Ensure terminal is restored on exit or interruption
orig_stty=""
if orig_stty=$(stty -g 2>/dev/null); then
  restore_tty() { stty "$orig_stty" 2>/dev/null || true; }
  trap restore_tty EXIT INT TERM
fi

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
RUN_DIR="$ROOT_DIR/run"
LOG_DIR="$RUN_DIR/logs"
mkdir -p "$LOG_DIR"

MODE=batch
SIM_TIME=""
CLEAN=0
PASSTHRU=()

for arg in "$@"; do
  case "$arg" in
    --gui) MODE=gui ;;
    --clean) CLEAN=1 ;;
    --time) shift; SIM_TIME="$1" ;;
    *) PASSTHRU+=("$arg") ;;
  esac
done

if [[ $CLEAN -eq 1 ]]; then
  echo "Cleaning run artifacts..."
  rm -rf "$RUN_DIR/sim" "$LOG_DIR" "${RUN_DIR}/.Xil"
  mkdir -p "$LOG_DIR"
fi

LOG_FILE="$LOG_DIR/vivado.log"
SIM_LOG="$LOG_DIR/sim.log"

echo "Vivado 2024.2 simulation ($MODE)" | tee "$SIM_LOG"

# Build vivado command
VIVADO_CMD=(vivado -mode batch -nolog -nojournal -notrace -source "$RUN_DIR/run_sim.tcl" -tclargs mode "$MODE")

if [[ -n "$SIM_TIME" && "$MODE" == "batch" ]]; then
  VIVADO_CMD+=(sim_time "$SIM_TIME")
fi

# Append plusargs passthrough (e.g., +UVM_TESTNAME=...)
for p in "${PASSTHRU[@]}"; do
  VIVADO_CMD+=("$p")
done

echo "Running: ${VIVADO_CMD[*]}" | tee -a "$SIM_LOG"

set +e
"${VIVADO_CMD[@]}" 2>&1 | tee -a "$SIM_LOG"
RC=${PIPESTATUS[0]}
set -e

# Also save a copy to vivado.log
cp -f "$SIM_LOG" "$LOG_FILE" || true

if [[ $RC -ne 0 ]]; then
  echo "Vivado run failed with code $RC" | tee -a "$SIM_LOG"
  exit $RC
fi

echo "Done. Logs: $SIM_LOG, $LOG_FILE" | tee -a "$SIM_LOG"
echo "Wave DB: $RUN_DIR/sim/xsim.wdb" | tee -a "$SIM_LOG"

if [[ "$MODE" == "gui" ]]; then
  echo "GUI launched by Vivado/xsim; close it to end." | tee -a "$SIM_LOG"
fi
