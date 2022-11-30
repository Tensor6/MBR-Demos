[bits 64]
[section .text]

global memory_copy
global memory_set
global read_tsc
global stop_kernel

memory_copy:
    mov ecx, edx
    rep movsb
    ret

memory_set:
    mov ecx, edx
    mov eax, esi
    rep stosb
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