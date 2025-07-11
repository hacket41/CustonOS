org 0x7C00
bits 16


%define ENDL 0x0D, 0x0A

start: 
  jmp main


;
; Prints a string to screen
; Params:
;  -ds:si points to a string 
;
puts:
  ; saves registers we will change
  push si 
  push ax

.loop:
  lodsb         ; loads next characetr in al
  or al, al     ; verify the next character in null
  jz .done

  mov ah, 0x0e
  int 0x10
  
  jmp .loop


.done:
  pop ax
  pop si 
  ret 



main:

  ; setup data segments
  mov ax, 0 
  mov ds, ax 
  mov es, ax

  ;setup stack
  mov ss, ax
  mov sp, 0x7C00 ;stack grows downwards from where we are loaded in memory

  ;prints the message
  mov si, msg_hello
  call puts

  hlt

.halt:
  jmp .halt



msg_hello: db 'Hello World', ENDL, 0

times 510-($-$$) db 0 
dw 0AA55h
