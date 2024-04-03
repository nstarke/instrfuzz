#!/usr/bin/env python3

import argparse, subprocess, datetime, os, stat

def get_umask():
    umask = os.umask(0)
    os.umask(umask)
    return umask

def chmod_plus_x(path):
    os.chmod(
        path,
        os.stat(path).st_mode |
        (
            (
                stat.S_IXUSR |
                stat.S_IXGRP |
                stat.S_IXOTH
            )
            & ~get_umask()
        )
    )
    
def main():
    parser = argparse.ArgumentParser('Instrfuzz test-elf.py')
    parser.add_argument('instruction', help='The instruction to test')

    args = parser.parse_args()
    insn = bytearray.fromhex(args.__dict__["instruction"].replace('0x', ''))
    subprocess.run("nasm -f elf32 -o test-elf.o test-elf.asm", shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    subprocess.run("ld -m elf_i386 -o test-elf test-elf.o", shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    with open("test-elf", "rb") as bin_file:
        data = bin_file.read()
        data = bytearray(data)
        idx = data.find(b"\x90\x90\x90\x90")
        data[idx + 3] = insn[0]
        data[idx + 2] = insn[1]
        data[idx + 1] = insn[2]
        data[idx] = insn[3]

        today = datetime.datetime.now()
        today = today.strftime("%Y%m%d%H%M%S")
        with open(today + ".test.elf", 'wb') as out_file:
            out_file.write(data)
        
        chmod_plus_x(today + '.test.elf')
        print(today + ".test.elf")
       
if __name__ == '__main__':
    main()