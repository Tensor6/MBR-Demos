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
global reset_cpu

global rebuild_PML4

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
    mov rcx, rdx
    rep movsq
    ret

memset64:
    mov rcx, rdx
    mov rax, rsi
    rep stosq
    ret

read_tsc:
    rdtsc
    shr rdx, 32
    or rax, rdx
    ret

rebuild_PML4:
    mov rdi, 0x100000
    mov rbx, 0x100000000
.loop:
    mov [rdi], rax
    add rax, 0x1000
    add rdi, 8
    cmp rax, rbx
    jb .loop
    ret

stop_kernel:
    cli
.halt:
    hlt
    jmp .halt

reset_cpu:
    mov rdi, 0xCC80
    mov QWORD [rdi], 0
    mov QWORD [rdi + 8], 0
    lidt [rdi]
    int 0x00