#!/usr/bin/env bash
PROJECT_NAME=SOC
DB_DIR=${FEMTORV32_DIR:+$FEMTORV32_DIR/tools/prjxray-extract/opt/nextpnr-xilinx/external/prjxray-db}
DB_DIR=${DB_DIR:-/usr/share/nextpnr/prjxray-db}
CHIPDB_DIR=${FEMTORV32_DIR:+$FEMTORV32_DIR/resources}
CHIPDB_DIR=${CHIPDB_DIR:-/usr/share/nextpnr/xilinx-chipdb}
PART=xc7a35tcpg236-1
INPUT=${1:-cmod_a7_vhdl/step1.vhd}
MODE=${2:-br}
BOARD_FREQ=100
CPU_FREQ=100

set -ex
if [[ "$MODE" == "b" || "$MODE" == "br" ]]; then
    if [[ "$INPUT" == *.vhd || "$INPUT" == *.vhdl ]]; then
        # VHDL: use ghdl synth to produce Verilog, then synthesise with yosys
        # Analyze library files first so their entities are visible to the step file.
        VHDL_LIB=$(dirname "$INPUT")/library
        VHDL_DEPS=$(ls "$VHDL_LIB"/*.vhd 2>/dev/null || true)
        ghdl synth --std=08 --out=verilog $VHDL_DEPS "$INPUT" -e SOC > ${PROJECT_NAME}_ghdl.v
        VERILOGS=${PROJECT_NAME}_ghdl.v
    else
        VERILOGS=$INPUT
    fi
    yosys -DCMODA7 -DBOARD_FREQ=$BOARD_FREQ -DCPU_FREQ=$CPU_FREQ -p "scratchpad -set xilinx_dsp.multonly 1" -p "synth_xilinx -nowidelut -flatten -abc9 -arch xc7 -top SOC; delete t:\$scopeinfo; write_json ${PROJECT_NAME}.json" ${VERILOGS}
    nextpnr-xilinx --chipdb ${CHIPDB_DIR}/xc7a35tcpg236-1.bin --xdc BOARDS/cmod_a7.xdc --json ${PROJECT_NAME}.json --write ${PROJECT_NAME}_routed.json --fasm ${PROJECT_NAME}.fasm
    fasm2frames --part ${PART} --db-root ${DB_DIR}/artix7 ${PROJECT_NAME}.fasm > ${PROJECT_NAME}.frames
    xc7frames2bit --part_file ${DB_DIR}/artix7/${PART}/part.yaml --part_name ${PART} --frm_file ${PROJECT_NAME}.frames --output_file ${PROJECT_NAME}.bit
fi
if [[ "$MODE" == "r" || "$MODE" == "br" ]]; then
    openFPGALoader --freq 30e6 -c digilent --fpga-part xc7a35 ${PROJECT_NAME}.bit
fi
#To send to FLASH:
# openFPGALoader --freq 30e6 -c digilent --fpga-part xc7a35tcpg236 -f ${PROJECT_NAME}.bit
