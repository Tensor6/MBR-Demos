[bits 64]
[section .text]

%define DISPLAY_WIDTH 320
%define VIDEO_MEMORY 0xA0000

global set_pixel

; X     -> EDI
; Y     -> ESI
; COLOR -> EDX
set_pixel:
    push rdx
    mov rbx, VIDEO_MEMORY
    mov rax, DISPLAY_WIDTH
    mul esi
    pop rdx
    add eax, edi
    add ebx, eax
    mov BYTE [rbx], dl
    ret