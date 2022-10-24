[org 0x7C00]
[bits 16]

jmp _start

%define COLUMNS 640
%define ROWS 480

[CPU 286]

halt:
    cli
.hl:
    hlt
    jmp .hl

_start:
    cli
    xor ax,ax
    mov ds,ax
    mov sp,bp
    mov bp, 0x9000
    sti

    xor ax,ax
    mov al, 0x12
    int 0x10
    
    mov al, 0xAA
.redraw:
    call draw
    add al, 0x11
    jmp .redraw

    jmp halt


draw:
    mov ah, 0x0C
    mov bh, 0x00
    xor cx,cx ; X coord
    xor dx,dx ; Y coord
.draw_call:
    int 0x10
.next_coord:
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

times 510 - ($ - $$) db 0x00
dw 0xAA55