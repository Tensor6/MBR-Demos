[bits 64]

[global set_idt]
[global load_isr_entries]

[extern set_idt_entry]
[extern send_EOI]
[extern ISR_handler]
[extern IRQ_handler]

set_idt:
    lidt [rdi]
    ret

; edi -> index
; rsi -> handler address
load_isr_entries:
    mov edi, 0
    mov rsi, isr0
    call set_idt_entry
    mov edi, 1
    mov rsi, isr1
    call set_idt_entry
    mov edi, 2
    mov rsi, isr2
    call set_idt_entry
    mov edi, 3
    mov rsi, isr3
    call set_idt_entry
    mov edi, 4
    mov rsi, isr4
    call set_idt_entry
    mov edi, 5
    mov rsi, isr5
    call set_idt_entry
    mov edi, 6
    mov rsi, isr6
    call set_idt_entry
    mov edi, 7
    mov rsi, isr7
    call set_idt_entry
    mov edi, 8
    mov rsi, isr8
    call set_idt_entry
    mov edi, 9
    mov rsi, isr9
    call set_idt_entry
    mov edi, 10
    mov rsi, isr10
    call set_idt_entry
    mov edi, 11
    mov rsi, isr11
    call set_idt_entry
    mov edi, 12
    mov rsi, isr12
    call set_idt_entry
    mov edi, 13
    mov rsi, isr13
    call set_idt_entry
    mov edi, 14
    mov rsi, isr14
    call set_idt_entry
    mov edi, 15
    mov rsi, isr15
    call set_idt_entry
    mov edi, 16
    mov rsi, isr16
    call set_idt_entry
    mov edi, 17
    mov rsi, isr17
    call set_idt_entry
    mov edi, 18
    mov rsi, isr18
    call set_idt_entry
    mov edi, 19
    mov rsi, isr19
    call set_idt_entry
    mov edi, 20
    mov rsi, isr20
    call set_idt_entry
    mov edi, 21
    mov rsi, isr21
    call set_idt_entry
    mov edi, 22
    mov rsi, isr22
    call set_idt_entry
    mov edi, 23
    mov rsi, isr23
    call set_idt_entry
    mov edi, 24
    mov rsi, isr24
    call set_idt_entry
    mov edi, 25
    mov rsi, isr25
    call set_idt_entry
    mov edi, 26
    mov rsi, isr26
    call set_idt_entry
    mov edi, 27
    mov rsi, isr27
    call set_idt_entry
    mov edi, 28
    mov rsi, isr28
    call set_idt_entry
    mov edi, 29
    mov rsi, isr29
    call set_idt_entry
    mov edi, 30
    mov rsi, isr30
    call set_idt_entry
    mov edi, 31
    mov rsi, isr31
    call set_idt_entry
    ret

isr_common:
    push rdi
    mov rdi, rsp
    add rdi, 8
    push rax
    push rcx
    push rdx
    push rbx
    push rsi
    ;push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15

    mov ax, ds
    push rax
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call ISR_handler

    pop rax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    ;pop rdi
    pop rsi
    pop rbx
    pop rdx
    pop rcx
    pop rax
    pop rdi

    add rsp, 10
    sti
    iretq

irq_common:
    push rdi
    mov rdi, rsp
    add rdi, 8
    push rax
    push rcx
    push rdx
    push rbx
    push rsi
    ;push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15

    mov ax, ds
    push rax
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call IRQ_handler

    pop rax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    ;pop rdi
    pop rsi
    pop rbx
    pop rdx
    pop rcx
    pop rax
    pop rdi

    add rsp, 10
    sti
    iretq

isr0:
    cli
    push QWORD 0
    push WORD 0
    jmp isr_common

isr1:
    cli
    push QWORD 0
    push WORD 1
    jmp isr_common

isr2:
    cli
    push QWORD 0
    push WORD 2
    jmp isr_common

isr3:
    cli
    push QWORD 0
    push WORD 3
    jmp isr_common

isr4:
    cli
    push QWORD 0
    push WORD 4
    jmp isr_common

isr5:
    cli
    push QWORD 0
    push WORD 5
    jmp isr_common

isr6:
    cli
    push QWORD 0
    push WORD 6
    jmp isr_common

isr7:
    cli
    push QWORD 0
    push WORD 7
    jmp isr_common

isr8:
    cli
    push WORD 8
    jmp isr_common

isr9:
    cli
    push QWORD 0
    push WORD 9
    jmp isr_common

isr10:
    cli
    push WORD 10
    jmp isr_common

isr11:
    cli
    push WORD 11
    jmp isr_common

isr12:
    cli
    push WORD 12
    jmp isr_common

isr13:
    cli
    push WORD 13
    jmp isr_common

isr14:
    cli
    push WORD 14
    jmp isr_common

isr15:
    cli
    push QWORD 0
    push WORD 15
    jmp isr_common

isr16:
    cli
    push QWORD 0
    push WORD 16
    jmp isr_common

isr17:
    cli
    push WORD 17
    jmp isr_common

isr18:
    cli
    push QWORD 0
    push WORD 18
    jmp isr_common

isr19:
    cli
    push QWORD 0
    push WORD 19
    jmp isr_common

isr20:
    cli
    push QWORD 0
    push WORD 20
    jmp isr_common

isr21:
    cli
    push WORD 21
    jmp isr_common

isr22:
    cli
    push QWORD 0
    push WORD 22
    jmp isr_common

isr23:
    cli
    push QWORD 0
    push WORD 23
    jmp isr_common

isr24:
    cli
    push QWORD 0
    push WORD 24
    jmp isr_common

isr25:
    cli
    push QWORD 0
    push WORD 25
    jmp isr_common

isr26:
    cli
    push QWORD 0
    push WORD 26
    jmp isr_common

isr27:
    cli
    push QWORD 0
    push WORD 22
    jmp isr_common

isr28:
    cli
    push QWORD 0
    push WORD 28
    jmp isr_common

isr29:
    cli
    push WORD 29
    jmp isr_common

isr30:
    cli
    push WORD 30
    jmp isr_common

isr31:
    cli
    push QWORD 0
    push WORD 31
    jmp isr_common


irq0:
