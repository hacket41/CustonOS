[BITS 32]

section .text
global kernel_main

kernel_main:
    mov edi, 0xB8000       ; VGA text mode buffer address
    mov ecx, 9             ; length of message
    mov esi, msg

.print_loop:
    lodsb                  ; load byte from [esi] into al and increment esi
    cmp al, 0
    je .done
    mov ah, 0x07           ; attribute byte: light gray on black
    stosw                  ; store ax (char + attribute) at [edi], increment edi by 2
    loop .print_loop

.done:
    hlt                    ; halt CPU
    jmp .done              ; infinite loop

section .data
msg db "Hello PM!", 0

