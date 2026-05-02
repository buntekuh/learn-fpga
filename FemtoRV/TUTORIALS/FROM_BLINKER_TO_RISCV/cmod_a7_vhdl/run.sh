#!/usr/bin/env bash
# Simulate a VHDL step file with GHDL.
# Usage: bash run.sh step1.vhd
set -e
STEP=${1:-step1.vhd}
BENCH=bench_${STEP%.vhd}.vhd

ghdl -a --std=08 "$STEP" "$BENCH"
ghdl -e --std=08 bench
ghdl -r --std=08 bench --stop-time=500ms
