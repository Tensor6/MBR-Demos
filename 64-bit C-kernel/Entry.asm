[bits 64]

global _start

[extern kernel_main]
[extern init_video]
[extern init_interrupts]

[section .boot]

_start:
    call init_interrupts
    call init_video
    call kernel_main
    cli
halt:
    hlt
    jmp halt