# Instrfuzz

This is an x86 CPU instruction fuzzer. I built this to test for CPU-level bugs using QEMU.  

## Prior Art

A much better x86 CPU instruction fuzzer is [sandsifter](https://github.com/xoreaxeaxeax/sandsifter).  Sandsifter inspired this project

## Install Dependencies

Use your package manager of choice to install:

* `qemu-system`
* `nasm`

For example, for Debian-based distributions:

```
sudo apt install qemu-system nasm
```

For macOS:

```
brew install qemu-system nasm
```

## How to run

Clone the repository and then run `bash instrfuzz.sh` in the newly cloned repository directory

## Bugs?

The following CPU instructions result in anoymalous behavior:

```
0xf541c7a7 ; 0x909090C7 works too.  Something with the '0xc7' opcode.
0x0c1edff7
0x4FFC09F5
0x03AEDFF7
0x39F0F650 ; this one causes a segfault in QEMU
0xA7F03DF0 ; crashes qemu / illegal instruction coredump in elf
0xEA413CA0 ; not even sure what is going on with this.
```

## Triaging

There are two scripts that can be used to triage fuzzer results:

* `test-instruction.sh $INSN`
* `elf-test.py $INSN`

`test-instruction.sh` will test the instruction as part of the MBR, which means no memory protections or operating system protections are in place

* `elf-test.py $INSN` will test the instruction as part of a elf file linked with GLIBC.  I would never run this script as root :-)

For example, try running this shell one-liner:

```
./`python3 elf-test.py 0x39F0F650`
```

This will create a .elf file and then execute that .elf file (the elf filename/path is printed to stdout after the sub shell command is run)