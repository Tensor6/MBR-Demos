[bits 64]
[section .text]

global memcpy8
global memset8

global memcpy16
global memset16

global memcpy32
global memset32

global memcpy64
global memset64

global read_tsc
global stop_kernel

memcpy8:
    mov ecx, edx
    rep movsb
    ret

memset8:
    mov ecx, edx
    mov eax, esi
    rep stosb
    ret

memcpy16:
    mov ecx, edx
    rep movsw
    ret

memset16:
    mov ecx, edx
    mov eax, esi
    rep stosw
    ret

memcpy32:
    mov ecx, edx
    rep movsd
    ret

memset32:
    mov ecx, edx
    mov eax, esi
    rep stosd
    ret

memcpy64:
    mov ecx, edx
    rep movsq
    ret

memset64:
    mov ecx, edx
    mov eax, esi
    rep stosq
    ret

read_tsc:
    rdtsc
    shr rdx, 32
    or rax, rdx
    ret

stop_kernel:
    cli
.halt:
    hlt
    jmp .halt