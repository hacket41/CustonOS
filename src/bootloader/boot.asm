org 0x7C00
bits 16

start:
  ; Set up segments
  xor ax, ax
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, 0x7C00

  ; Set disk to read (drive 0)
  mov ah, 0x02        ;BIOS read sector function
  mov al, 1           ;read 1 sector
  mov ch, 0           ;cylinder
  mov cl, 2           ;sector
  mov dh, 0           ;head
  ;mov dl, 0x00        ;floppy drive
  mov bx, 0x7C00      ;address to load to
  int 0x13
  jc disk_error       ;jump if carry flag is set(reading failure)

  jmp 0x0000:0x7C00   ;jump to loaded main.asm


disk_error:
  ;Print error message during failure
  mov si, err_msg
  call print 
  jmp $

print:
  ;Print string at DS:string
  mov ah, 0x0E

.print_loop:
  lodsb
  or al, al
  jz .done
  int 0x10
  jmp .print_loop
.done:
  ret

err_msg db "Reading error on disk", 0 

times 510 - ($ -$$) db 0 
dw 0xAA55

