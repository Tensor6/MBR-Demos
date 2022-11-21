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
; bgcolor -> R8D 8   R8D
draw_char:
    push rbp
    mov rbp, rsp
    sub rsp, 17

    mov DWORD [rbp-4], esi
    mov DWORD [rbp-8], edx
    mov DWORD [rbp-12], ecx
    mov DWORD [rbp-16], r8d
    mov BYTE [rbp-17], 128

    mov rsi, 0xA0000
    mov ecx, edi
    mov eax, 16
    mul ecx
    add esi, eax

    mov BYTE [rbp-17], 128
    mov rcx, CHARACTER_HEIGHT
.row_loop:
    push rcx
    mov rcx, 8
.col_loop:
    lodsb
    test eax, eax
    jz .skip_loop

    test BYTE [rbp-17], al

.use_background:


    shr BYTE [rbp-17], 1
    loop .col_loop
    mov BYTE [rbp-17], 128
    pop rcx
.skip_loop:
    loop .row_loop

    leave
    ret