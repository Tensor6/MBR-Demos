[bits 64]

global _start

[extern kernel_main]
[extern initialize_kernel]

[section .boot]

_start:
    call initialize_kernel
    call kernel_main
    cli
halt:
    hlt
    jmp halt