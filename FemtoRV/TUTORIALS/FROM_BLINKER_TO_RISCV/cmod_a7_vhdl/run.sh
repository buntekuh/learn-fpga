#!/usr/bin/env bash
# Simulate a VHDL step file with GHDL.
# Usage: bash run.sh step1.vhd
set -e
STEP=${1:-step1.vhd}
BENCH=bench_${STEP%.vhd}.vhd

VHDL_DEPS=$(ls library/*.vhd 2>/dev/null || true)
ghdl -a --std=08 $VHDL_DEPS "$STEP" "$BENCH"
ghdl -e --std=08 bench
ghdl -r --std=08 bench --stop-time=500ms
