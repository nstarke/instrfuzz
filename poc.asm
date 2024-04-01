; BOOTFUZZ
; 
; Copyright (c) 2024 Nicholas Starke
; https://github.com/nstarke/bootfuzz
;
; assemble with `nasm -f bin -o bootfuzz.img bootfuzz.asm`
; run in qemu: `qemu-system-i386 -fda bootfuzz.img -nographic -accel kvm`

[bits 16]
org 0x7c00

start:
; vga video mode bios settings
    mov ah, 0x0
    mov al, 0x2
    int 0x10

    ; vga video memory map
    mov ax, 0xb000
    mov ds, ax
    mov es, ax
    
    ; set up code segment
    push cs
    
    ; set up stack
    pop ds
    
    mov bx, before_str
    call print_string

    mov ax, 0xc7a7
    mov [exec_context+3], ax
    mov ax, 0xf541
    mov [exec_context+1], ax
   
    jmp exec_context

after:
    mov bx, after_str
    call print_string
loop_forever:
    jmp loop_forever

print_letter:
    pusha
    mov ah, 0xe
    mov bx, 0xf
    int 0x10
    popa
    ret

print_string:
    pusha
print_string_begin:
    mov al, [bx]
    test al, al
    je print_string_end
    push bx
    call print_letter
    pop bx
    inc bx
    jmp print_string_begin
print_string_end:
    popa
    ret

exec_context:
    pusha
    nop
    nop
    nop
    nop
    popa
    jmp after

before_str:
db "Before", 0xa, 0xd, 0x0

after_str:
db "After", 0xa, 0xd, 0x0

times 510-($-$$) db 0
db 0x55, 0xaa 
