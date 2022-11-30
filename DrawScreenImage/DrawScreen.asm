[org 0x7C00]
[bits 16]

%define COLUMNS 320
%define ROWS 200

_start:
    cli
    mov  bp, 0x600
    xor  ax, ax
    mov  ds, ax
    mov  es, ax
    mov  ss, ax
    mov  sp, bp
    sti

    mov BYTE [BOOT_DRIVE], dl

    mov si, DATA_LOADING
    call print_string

    mov ch, 0x00
    call disk_load

.redo:

    xor ax,ax
    mov ah, 0x03
    int 0x10

    mov BYTE [GRAPHICS], 0

    mov si, DATA_LOAD
    call print_string

.again:
    xor ax,ax
    int 0x16
    cmp al, 'x'
    je .xcont
    cmp al, 27 ; ESC
    je .blank
    jmp .again
.blank:
    call draw_blank
    jmp .redo
.xcont:

    mov al, [GRAPHICS]
    test al,al
    jnz .blank

    mov BYTE [GRAPHICS], 1

    xor ax,ax
    mov al, 0x13
    int 0x10

    mov esi,LOAD
    call draw

    jmp .again

draw:
    mov ah, 0x0C
    mov bh, 0x00
    xor cx,cx ; X coord
    xor dx,dx ; Y coord
.draw_call:
    mov al, [esi]
    inc esi
    int 0x10
    cmp cx, COLUMNS - 1
    je .next_row
    inc cx
    jmp .draw_call
.next_row:
    cmp dx, ROWS - 1
    je .end
    xor cx,cx
    inc dx
    jmp .draw_call
.end:
    ret

draw_blank:
    mov ah, 0x0C
    mov bh, 0x00
    xor cx,cx ; X coord
    xor dx,dx ; Y coord
.draw_call:
    mov al, 0x00
    int 0x10
    cmp cx, COLUMNS - 1
    je .next_row
    inc cx
    jmp .draw_call
.next_row:
    cmp dx, ROWS - 1
    je .end
    xor cx,cx
    inc dx
    jmp .draw_call
.end:
    ret


disk_reset:
    mov dl, [BOOT_DRIVE]
    mov ah, 0x0
    int 0x13
    ret

disk_load:
    
    mov ah, 0x02
	mov al, 0x7D
	xor bx, bx
	mov es, bx
	;mov ch, 0x00
	mov cl, 0x02
	mov dh, 0x00
    mov BYTE dl, [BOOT_DRIVE]
	mov bx, LOAD
	int 0x13
	jc disk_error
    ret

print_hex_word:
    pusha
    mov bp, sp
    mov cx, 0x0404
    mov dx, [bp+18]
    mov bx, [bp+20]
.loop:
    rol dx, cl
    mov ax, 0x0e0f
    and al, dl
    add al, 0x90
    daa
    adc al, 0x40
    daa
    int 0x10
    dec ch
    jnz .loop
    mov ax, 0x0E0A
    int 0x10
    mov ax, 0x0E0D
    int 0x10
    popa
    ret

print_string:
    push ax
.loop:
    lodsb
    cmp al, 0x0
    je .end
    mov ah, 0x0E
    int 0x10
    jmp .loop
.end:
    pop ax
    ret

disk_error:
    mov si, DISK_ERROR
    call print_string
    mov al, 0x00
    push ax
    call print_hex_word
halt:
    cli
.hl:
    hlt
    jmp .hl

DATA_LOADING: db "Loading image...",0xA,0xD,0x0
DATA_LOAD: db "Image is loaded!",0xA,0xD,0xA,0xD,"Press X to draw!",0xA,0xD,"Press ESC to return!",0x0
DISK_ERROR: db "Failed to load image from disk!",0xA,0xD,"Error code: ",0x00
BOOT_DRIVE: db 0x00
GRAPHICS: db 0x00

times 510 - ($ - $$) db 0x00
dw 0xAA55

LOAD: