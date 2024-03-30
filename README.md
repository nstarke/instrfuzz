# Instrfuzz

This is an x86 CPU instruction fuzzer. I built this to test for CPU-level bugs using QEMU.  

## Prior Art

A much better x86 CPU instruction fuzzer is [sandsifter](https://github.com/xoreaxeaxeax/sandsifter).  Sandsifter inspired this project

## Instal Dependencies
Use your package manager of choice to install:

* `qemu-system`
* `nasm`

For example, for Debian-based distributions:

```
sudo apt install qemu-system nasm
```

## How to run

Clone the repository and then run `bash instrfuzz.sh` in the newly cloned repository directory

## Bugs?

TBD