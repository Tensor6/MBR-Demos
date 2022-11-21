[bits 64]
[section .text]

%define DISPLAY_WIDTH 320
%define VIDEO_MEMORY 0xA0000
%define VGA_BIOS_FONT 0x9E000

%define CHARACTER_HEIGHT 16

global set_pixel
global draw_char

; X     -> EDI
; Y     -> ESI
; COLOR -> EDX
set_pixel:
    push rdx
    mov ebx, VIDEO_MEMORY
    mov eax, DISPLAY_WIDTH
    mul esi
    pop rdx
    add eax, edi
    add ebx, eax
    mov BYTE [rbx], dl
    ret

; C       -> EDI 8   DIL
; X       -> ESI 16  SI
; Y       -> EDX 16  DX
; fgcolor -> ECX 8   CL
; bgcolor -> R8D 8   R8B
draw_char:
    push rbp
    mov rbp, rsp
    sub rsp, 17

    mov DWORD [rbp-4], esi
    mov DWORD [rbp-8], edx
    mov DWORD [rbp-12], ecx
    mov DWORD [rbp-16], r8d
    mov BYTE [rbp-17], 128

    mov rsi, VGA_BIOS_FONT
    mov ecx, edi
    mov eax, 16
    mul ecx
    add esi, eax

    mov rcx, CHARACTER_HEIGHT
.row_loop:
    lodsb
    ;test al, al
    ;jz .skip_loop
    call .column_loop_func
;.skip_loop:
    loop .row_loop

    leave
    ret

.column_loop_func:
    push rcx
    push rsi
    mov edi, DWORD [rbp-4] ; X
    mov esi, DWORD [rbp-8] ; Y
    mov BYTE [rbp-17], 128
    mov ecx, 8
.loop_col:
    push rax
    test BYTE [rbp-17], al
    jz .use_background
    mov edx, DWORD [rbp-12]
    jmp .draw
.use_background:
    mov edx, DWORD [rbp-16]
.draw:
    call set_pixel
    inc edi
    shr BYTE [rbp-17], 1
    pop rax
    loop .loop_col
    inc DWORD [rbp-8]
    pop rsi
    pop rcx
    ret