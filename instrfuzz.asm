; INSTRFUZZ
; 
; Copyright (c) 2024 Nicholas Starke
; https://github.com/nstarke/instrfuzz
;
; run: `bash instrfuzz.sh`

[bits 16]

; MBR boot sector address
org 0x7c00

start:

    ; vga video mode bios settings
    mov al, 0x2
    mov ah, 0x12
    int 0x10

    ; vga video memory map
    mov ax, 0xb800
    mov ds, ax
    mov es, ax
    
    ; set up code segment
    push cs
    
    ; set up stack
    pop ds
    
    ; print banner / options
    mov bx, banner_str
    call print_string

fuzz:
    ; print '\r'
    mov al, 0xd
    call print_letter
    
    ; print '\n'
    mov al, 0xa
    call print_letter

    ; print "INSN:"
    mov bx, insn_str
    call print_string
    
    ; put random value in ax
    call get_random
    
    mov dx, ax
    call print_hex

    mov [exec_context+6], dx
    ; get second random value
    call get_random

    ; move second random value into cx.
    mov cx, ax

    ; get third random value
    call get_random

    ; multiply second and third random values to 
    ; redistribute operand ranges.
    mul cx

    mov [exec_context+4], ax

    mov dx, ax
    call print_hex

    jmp exec_context

exec_context:
    pusha
    nop
    nop
    nop
    nop ; this and the next 3 byte are overwritten
    nop ; overwritten
    nop ; overwritten
    nop ; overwritten
    nop
    nop
    nop
    popa
    jmp reboot

reboot:
    int 0x19

; relies on BIOS Services timer to create
; 'random' values returned in ax.
get_random:
    push bx
    push cx
    push dx
    push si
    push di
    xor ax, ax
    in al, (0x40)
    mov cl, 2
    mov ah, al
    in al, (0x40)
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    ret

; Utility functions that aren't very interesting
; Collected from:
; * https://stackoverflow.com/questions/27636985/printing-hex-from-dx-with-nasm
; * https://github.com/nanochess/book8088
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

print_hex:
    pusha
    mov si, hex_str
    mov cx, 0

next_character:
    inc cx
    mov bx, dx
    and bx, 0xf000
    shr bx, 4
    add bh, 0x30
    cmp bh, 0x39
    jg add_7

add_character_hex:
    mov [si], bh
    inc si
    shl dx, 4
    cmp cx, 4
    jnz next_character
    jmp _done

_done:
    mov bx, hex_str
    call print_string
    popa
    ret

add_7:
    add bh, 0x7
    jmp add_character_hex

hex_str:
    db '0000', 0x0

banner_str:
    db "Instructionfuzz By Nick Starke (https://github.com/nstarke)", 0xa, 0xd, 0xa

insn_str:
    db "INSN:0x", 0x0

times 510-($-$$) db 0
db 0x55,0xaa 