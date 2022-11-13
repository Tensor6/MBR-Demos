[bits 64]

%define INTERRUPT_GATE 0x8E
%define TRAP_GATE 0x8F

%define ENTRIES 32

%define KERNEL_CS 0x08

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
    mov rsi, IDT_REG
    lidt [rsi]
    ret
isr_init:
    mov rax, isr_0
    mov rdx, 0
    call set_idt_gate
    call idt_init
    ret

; RAX = handler
; RDX = idt index
set_idt_gate:
    push rbp
    mov rsp, rbp
    sub rsp, 0x10
    mov QWORD [rbp-8], rax ; handler address
    mov QWORD [rbp-16], rdx ; idt index
    
    mov rsi, 0

    mov rax, rdx
    mov rcx, 128
    mul rcx
    mov rdi, ENTRIES
    add rdi, rax

    mov rax, QWORD [rbp-8]
    mov rdx, rax
    
    mov WORD [rdi], ax ; offset1
    mov ax, KERNEL_CS
    mov WORD [rdi+2], ax ; selector
    xor rax, rax
    mov BYTE [rdi+3], al ; ist
    mov al, INTERRUPT_GATE
    mov BYTE [rdi+4], al ; type_attributes
    mov rax, rdx
    shr rax, 16
    shr rdx, 32
    mov WORD [rdi+6], ax ; offset2
    mov DWORD [rdi+10], edx ; offset3
    xor rax, rax
    mov DWORD [rdi+14], eax ; zero

    mov rbp, rsp
    pop rbp
    ret

isr_0:
    iretq


[SECTION .rodata]

; IDT gate structure (128 bytes)

;typedef struct {
;    uint16_t offset_1;
;    uint16_t selector;
;    uint8_t  ist;
;    uint8_t  type_attributes;
;    uint16_t offset_2;
;    uint32_t offset_3;
;    uint32_t zero;
;} __attribute__((packed)) idt_gate64;

IDT_REG:
    dq IDT_ENTRIES
    dd IDT_SIZE

IDT_ENTRIES:

    times ENTRIES * 128 db 0x00

IDT_END:

IDT_SIZE: equ IDT_END - IDT_ENTRIES - 1

