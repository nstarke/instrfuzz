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
0xf541c7a7
0x0c1edff7
0x4FFC09F5
0x3AEDFF7
```
