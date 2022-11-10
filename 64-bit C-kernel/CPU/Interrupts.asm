[bits 64]

%define INTERRUPT_GATE 0x8E
%define TRAP_GATE 0x8F

%define ENTRIES 32

%define KERNEL_CS 0x08

%define LOW_16(address) ((address - $$) & 0xFFFF)
%define HIGH_16(address) (((address - $$) >> 16) & 0xFFFF)
%define HIGH_32(address) (((address - $$) >> 32) & 0xFFFFFFFF)

%define IRQ0 32
%define IRQ1 33
%define IRQ2 34
%define IRQ3 35
%define IRQ4 36
%define IRQ5 37
%define IRQ6 38
%define IRQ7 39
%define IRQ8 40
%define IRQ9 41
%define IRQ10 42
%define IRQ11 43
%define IRQ12 44
%define IRQ13 45
%define IRQ14 46
%define IRQ15 47

[section .text]

idt_init:

    ret
isr_init:

    ret

; RAX = handler
; RDX = idt index
set_idt_gate:
    push rbp
    mov rsp, rbp
    sub rsp, 0x10
    mov QWORD [rbp-8], rax
    mov QWORD [rbp-16], rdx
    mov rax, rdx
    mov rdi, IDT_ENTRIES
    mov rcx, 128
    add rcx, rdx
    mul rcx

    mov rbp, rsp
    pop rbp
    ret

isr_0:
    iretq


[SECTION .rodata]

;%macro IDT_GATE 0
;    dw LOW_16(%1)     ; offset1
;    dw KERNEL_CS      ; selector
;    db 0              ; ist
;    db INTERRUPT_GATE ; type_attributes
;    dw HIGH_16(%1)    ; offset2
;    dd HIGH_32(%1)    ; offset3
;    dd 0              ; zero
;%endmacro

IDT_REG:
    dq IDT_ENTRIES
    dd IDT_SIZE

IDT_ENTRIES:

    times ENTRIES * 128 db 0x00

IDT_END:

IDT_SIZE: equ IDT_END - IDT_ENTRIES - 1

