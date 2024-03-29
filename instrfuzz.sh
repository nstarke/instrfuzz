#!/bin/bash

echo "Assembling fuzzing core"
nasm -f bin -o instrfuzz.img instrfuzz.asm
echo "Assembled fuzzing core"

echo "Beginning Test Iterations"

while :
do
	OUTPUT=$(timeout --foreground 0.25 qemu-system-i386 -boot a -fda instrfuzz.img -accel kvm -nographic 2>/dev/null)
	if [ "$?" -ne 124 ]; then
		echo 'Abnormal Signal Detected!'
		OUTDATE=$(date + '%Y%m%d%H%M%S')
		echo $OUTPUT > instrfuzz-$OUTDATE.log
		exit 0
	fi
	echo $OUTPUT
done
