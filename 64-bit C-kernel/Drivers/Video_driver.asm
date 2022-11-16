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

; C       -> EDI 8
; X       -> ESI 16
; Y       -> EDX 16
; fgcolor -> ECX 8
; bgcolor -> R8D 8
draw_char:
    push rbp
    mov rsp, rbp
    sub rsp, 8

    mov BYTE [rbp], di    ; Character
    mov WORD [rbp-2], si  ; X-coordinate
    mov WORD [rbp-4], dx  ; Y-coordinate
    mov BYTE [rbp-5], cl  ; foreground color
    mov BYTE [rbp-6], r8  ; background color

    mov rsi, VGA_BIOS_FONT
    mov rax, 16
    mul rdi
    add esi, eax

    mov rcx, CHARACTER_HEIGHT
    mov bx, WORD [rbp-2]
    mov dx, WORD [rbp-4]
.char_loop:
    lodsb
    test al, al
    jz .skip_loop

    push edi
    push esi
    push edx
    
    
    mov edi, bx
    mov esi, dx
    mov di, BYTE [rbp-6]
    movzx edx, di

    test al, 128
    jz .s1
    
    
.s1:
    test al, 64
    jz .s2

.s2:
    test al, 32
    jz .s3

.s3:
    test al, 16
    jz .s4

.s4:
    test al, 8
    jz .s5

.s5:
    test al, 4
    jz .s6

.s6:
    test al, 2
    jz .s7

.s7:
    test al, 1
    jz .s8

.s8:
    
.skip_loop:
    pop edx
    pop esi
    pop edi
    loop .char_loop
    mov rsp, rbp
    pop rbp
    ret