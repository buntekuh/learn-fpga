# Extracts compilation flags from selected board, and
# write them to FIRMWARE/config.mk
cd RTL
if command -v iverilog > /dev/null 2>&1; then
    iverilog -I PROCESSOR $1 -o tmp.vvp get_config.v
    vvp tmp.vvp > ../FIRMWARE/config.mk
    rm -f tmp.vvp
    echo BOARD=$BOARD >> ../FIRMWARE/config.mk
else
    echo "Warning: iverilog not found, preserving existing FIRMWARE/config.mk" >&2
    # Only update BOARD line if config.mk already has ARCH set
    if grep -q "^ARCH=" ../FIRMWARE/config.mk 2>/dev/null; then
        sed -i "s/^BOARD=.*/BOARD=$BOARD/" ../FIRMWARE/config.mk
    else
        echo "Error: FIRMWARE/config.mk missing or incomplete. Install iverilog or create it manually." >&2
        exit 1
    fi
fi
cat ../FIRMWARE/config.mk
