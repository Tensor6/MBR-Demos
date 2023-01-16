[bits 64]

global _start

[extern kernel_main]
[extern init_video]
[extern init_interrupts]
[extern rebuild_PML4]

[section .boot]

_start:
    call init_interrupts
    call rebuild_PML4
    call init_video
    call kernel_main
    cli
halt:
    hlt
    jmp halt