[org 0x7C00]
[bits 16]

jmp _start

%define COLUMNS 640
%define ROWS 480

halt:
    cli
.hl:
    hlt
    jmp .hl

_start:
    cli
    mov  bp, 0x7C00
    xor  ax, ax
    mov  ds, ax
    mov  es, ax
    mov  ss, ax
    mov  sp, bp
    sti

    xor ax,ax
    mov al, 0x10
    int 0x10
    
    ;call disk_load

    mov si,0x7B00
    call draw

    jmp halt


draw:
    mov ah, 0x0C
    mov bh, 0x00
    xor cx,cx ; X coord
    xor dx,dx ; Y coord
.draw_call:
    lodsb
    int 0x10
    cmp cx, COLUMNS
    je .next_row
    inc cx
    jmp .draw_call
.next_row:
    cmp dx, ROWS
    je .end
    xor cx,cx
    inc dx
    jmp .draw_call
.end:
    ret

disk_load:
    xor bx,bx
    mov es,bx
    mov cx, 0xFA00
    mov di, 0x7F00
    mov al, 0xDD
    rep stosb
    ret

times 510 - ($ - $$) db 0x00
dw 0xAA55