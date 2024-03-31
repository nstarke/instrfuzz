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


if [ -z "${TIMEOUT}" ]; then
	TIMEOUT=60
fi

echo "Iteration Execution time should be less than ${TIMEOUT} seconds"

QEMU="qemu-system-i386"

if ! command -v "${QEMU}" &> /dev/null; then
	echo "${QEMU} is not in \$PATH"
	exit 1
fi

ACCELERATION=""

if [[ $(cat /proc/cpuinfo | grep -i intel) ]]; then
	ACCELERATION="-accel kvm"
fi

while :
do
	OUTDATE=$(date +'%Y%m%d%H%M%S')
	START=$(date +'%s')
	OUTPUT=$(timeout --foreground ${TIMEOUT} "${QEMU}" -boot a -fda instrfuzz.img ${ACCELERATION} -nographic > "/tmp/${OUTDATE}.tmp" 2> /dev/null)
	QEMU_SIG="$?"
	END=$(date +'%s')
	LEN=$((END-START))

	if [ "$QEMU_SIG" -ne 124 ] || [ $TIMEOUT -gt "$LEN" ]; then
		echo 'Abnormal Signal Detected!'
		mv "/tmp/${OUTDATE}.tmp" "instrfuzz-${OUTDATE}.log"
	else 
		echo "Ending Iteration:  $(date)"
		echo "Execution time in seconds: ${LEN}"
	fi

	rm "/tmp/${OUTDATE}.tmp"
done
