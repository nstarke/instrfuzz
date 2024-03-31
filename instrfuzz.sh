#!/bin/bash

echo "Assembling fuzzing core"

if ! command -v "nasm" &> /dev/null; then
	echo "nasm is not in \$PATH"
	exit 1
fi

nasm -f bin -o instrfuzz.img instrfuzz.asm

if [ ! -f instrfuzz.img ]; then
	echo "instrfuzz.img does not exist"
	exit 1
fi

echo "Assembled fuzzing core"

echo "Beginning test iterations"

QEMU="qemu-system-i386"

if ! command -v "${QEMU}" &> /dev/null; then
	echo "${QEMU} is not in \$PATH"
	exit 1
fi

while :
do
	OUTPUT=$(timeout --foreground 60 "${QEMU}" -boot a -fda instrfuzz.img -accel kvm -nographic 2>/dev/null)
	if [ "$?" -ne 124 ]; then
		echo 'Abnormal Signal Detected!'
		OUTDATE=$(date +'%Y%m%d%H%M%S')
		echo "${OUTPUT}" > "instrfuzz-${OUTDATE}.log"
	fi
	echo "${OUTPUT}"
done
