[bits 64]
[section .text]

global memory_copy
global memory_set

memory_copy:
    mov ecx, edx
    rep movsb
    ret

memory_set:
    mov ecx, edx
    mov eax, esi
    rep stosb
    ret