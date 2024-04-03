section .text
global _start

%define system_call int 0x80

_start:
    nop
    nop
    nop
    nop

    ; exit process
    xor ebx, ebx
    mov eax, 0x1
    system_call