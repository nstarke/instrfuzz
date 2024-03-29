#!/bin/bash

echo "Assembling fuzzing core"
nasm -f bin -o instrfuzz.img instrfuzz.asm
echo "Assembled fuzzing core"

echo "Beginning Test Iterations"

while :
do
	OUTPUT=$(timeout --foreground 0.25 qemu-system-i386 -boot a -fda instrfuzz.img -accel kvm -nographic)
	if [ "$?" -eq 139 ]; then
		echo 'SIGSEGV Detected!'
		echo $OUTPUT > instrfuzz.log
		exit 0
	fi
done
