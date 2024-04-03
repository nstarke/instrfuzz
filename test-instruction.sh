#!/bin/bash
#
INSN="$1"

if [ ${#INSN} -eq 8 ]; then
    NIBBLE1=${INSN:0:4}
    NIBBLE2=${INSN:4:8}
elif [ ${#INSN} -eq 10 ]; then
   NIBBLE1=${INSN:2:4}
   NIBBLE2=${INSN:6:10}
fi

OUTDATE=$(date +'%Y%m%d%H%M%S')

echo "Testing ${NIBBLE1}${NIBBLE2}"

cat poc.asm | sed "s/\$NBL1/$NIBBLE1/g" | sed "s/\$NBL2/$NIBBLE2/g" > "${OUTDATE}.test.asm"
nasm -f bin -o "${OUTDATE}.test.img" "${OUTDATE}.test.asm"

echo "Booting QEMU to test instruction.  Press CTRL-A + X to break out of QEMU..."
qemu-system-i386 -boot a -fda "{$OUTDATE}.test.img" -nographic

echo "Created ${OUTDATE}.test.img and ${OUTDATE}.test.asm.  Do you want to keep these files?"