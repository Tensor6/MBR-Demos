[bits 64]
[section .text]

%define DISPLAY_WIDTH 320
%define VIDEO_MEMORY 0xA0000
%define VGA_BIOS_FONT 0x9E000

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


; C       -> EDI
; X       -> ESI
; Y       -> EDX
; fgcolor -> ECX
; bgcolor -> R8D
draw_char:
    push rbp
    mov rsp, rbp
    sub 
    ret

[section .rodata]

CHAR_MASK:
    db 0b00000001
    db 0b00000010
    db 0b00000100
    db 0b00001000
    db 0b00010000
    db 0b00100000
    db 0b01000000
    db 0b10000000