[org 0x7c00]
[bits 16]

%define KERNEL_SECTOR_COUNT 16
%define KERNEL_ADDRESS 0x1000

%define VESA_INFO_STRUCT 0xFC00
%define VESA_MODE_INFO_STRUCT 0xFE00 

%define PAGE_PRESENT (1 << 0)
%define PAGE_WRITE (1 << 1)
%define CODE_SEG 8
%define DATA_SEG 16

Main:
    jmp 0x0000:boot

halt:
    cli
.lock:
    hlt
    jmp .lock

boot:
    cli
    xor ax, ax
    mov ss, ax
    mov sp, Main
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    sti

    mov [BOOT_DRIVE], dl

    mov ax, 0x03
    int 0x10

    mov ax, 0xEC00
    mov bl, 0x03
    int 0x15

    call checkCPU

    call disk_load

    jmp LOAD_ADDRESS

checkCPU:
    pushfd
    pop eax
    mov ecx, eax
    xor eax, 0x200000
    push eax
    popfd
    pushfd
    pop eax
    xor eax, ecx
    shr eax, 21
    and eax, 1
    push ecx
    popfd
    test eax, eax
    jz .no_cpuid
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jc .no_cpu64
    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz .no_cpu64
    ret
.no_cpuid:
    mov si, NO_CPUID
    call print_string
    jmp halt
.no_cpu64:
    mov si, NO_CPU64
    call print_string
    jmp halt

disk_load:
    mov ah, 0x02
    mov al, 3
    xor bx, bx
    mov es, bx
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    mov dl, [BOOT_DRIVE]
    mov bx, LOAD_ADDRESS
    int 0x13
    jc .disk_error
    cmp al, 3
    jne .sector_error
    ret
.disk_error:
    mov si, DISK_ERROR_MSG
    call print_string
    mov al, 0x0
    push ax
    call print_hex_word
    jmp halt
.sector_error:
    mov si, SECTOR_ERROR_MSG
    call print_string

print_string:
    push cx
    pusha
.print_string_loop:
    lodsb
    cmp al, 0x00
    je .print_string_ret
    mov ah, 0x0E
    int 0x10
    jmp .print_string_loop
.print_string_ret:
    popa
    pop cx
    ret

print_hex_word:
    pusha
    mov bp, sp
    mov cx, 0x0404
    mov dx, [bp+18]
    mov bx, [bp+20]
.loop:
    rol dx, cl
    mov ax, 0x0e0f
    and al, dl
    add al, 0x90
    daa
    adc al, 0x40
    daa
    int 0x10
    dec ch
    jnz .loop
    popa
    ret

A20_check:
    push ds
    push es
    push di
    push si
    cli
    xor ax, ax
    mov es, ax
    not ax
    mov ds, ax
    mov di, 0x0500
    mov si, 0x0510
    mov al, BYTE [es:di]
    push ax
    mov al, BYTE [ds:si]
    push ax
    mov BYTE [es:di], 0x00
    mov BYTE [ds:si], 0xFF
    cmp BYTE [es:di], 0xFF
    pop ax
    mov BYTE [ds:si], al
    pop ax
    mov BYTE [es:di], al
    clc
    je .end_check_a20
    stc
.end_check_a20:
    pop si
    pop di
    pop es
    pop ds
    ret

A20_enable:
    pusha
    pushf
    call A20_check
    jc .enable_exit

    mov ax, 0x2403
    int 0x15
    jb .next_stage
    cmp ah, 0
    jnz .next_stage
    mov ax, 0x2402
    int 0x15
    jb .next_stage
    cmp ah, 0
    jnz .next_stage
    cmp al, 1
    jz .next_stage
    mov ax, 0x2401
    int 0x15
.next_stage:
    call A20_check
    jc .enable_exit

    in al, 0x92
    or al, 2
    out 0x92, al

    call A20_check
    jc .enable_exit

    in al, 0xEE

    call A20_check
    jc .enable_exit

    mov si, NO_A20
    call print_string
    jmp halt

.enable_exit:
    popf
    popa
    ret

DISK_ERROR_MSG: db "Disk read error!",0xD,0xA,0x00
SECTOR_ERROR_MSG: db "Sector read error!",0xD,0xA,0x00
NO_CPUID: db "CPUID is not supported!",0x00
NO_CPU64: db "Long mode (64-bit) is not supported!",0x00
BOOT_DRIVE: db 0x00

times 510-($-$$) db 0x00
dw 0xAA55

LOAD_ADDRESS:
    call disk_reset
    call load_kernel
    call A20_enable
    call load_bios_font

	call VESA_video_mode_initialize

    mov edi, 0x9000    
    jmp start64


load_bios_font:
    mov di, 0x0
    push ds
    push es
    mov ax, 0x1130
    mov bh, 0x06
    int 0x10
    push es
    pop ds
    mov si, bp
    mov cx, 1024
    mov ax, 0x9E00
    mov es, ax
    rep movsd
    pop es
    pop ds
    ret

load_kernel:
    mov ah, 0x02
    mov al, KERNEL_SECTOR_COUNT
    mov ch, 0x00
    mov cl, 0x04
    mov dh, 0x00
    mov dl, [BOOT_DRIVE]
    xor bx, bx
    mov es, bx
    mov bx, KERNEL_ADDRESS
    int 0x13
    jc .kdisk_error
    cmp al, KERNEL_SECTOR_COUNT
    jne .ksector_error
    ret
.kdisk_error:
    mov si, KDR
    call print_string
    mov al, 0x0
    push ax
    call print_hex_word
    jmp halt
.ksector_error:
    mov si, SECTOR_ERROR_MSG
    call print_string
    jmp halt

disk_reset:
    mov ah, 0x00
    mov dl, [BOOT_DRIVE]
    int 0x13
    jc .reset_error
    ret
.reset_error:
    mov si, DISK_RESET_ERROR
    call print_string
    ret

start64:
    push di
    mov ecx, 0x1000
    xor eax, eax
    cld
    rep stosd
    pop di
    lea eax, [es:di + 0x1000]
    or eax, PAGE_PRESENT | PAGE_WRITE
    mov [es:di], eax
    lea eax, [es:di + 0x2000]
    or eax, PAGE_PRESENT | PAGE_WRITE
    mov [es:di + 0x1000], eax
    lea eax, [es:di + 0x3000]
    or eax, PAGE_PRESENT | PAGE_WRITE
    mov [es:di + 0x2000], eax
    push di
    lea di, [di + 0x3000]
    mov eax, PAGE_PRESENT | PAGE_WRITE
.loop_pages:
    mov [es:di], eax
    add eax, 0x1000
    add di, 8
    cmp eax, 0x200000
    jc .loop_pages
    pop di
    mov al, 0xFF
    out 0xA1, al
    out 0x21, al
    lidt [NULL_IDT]
    mov eax, 0b10100000
    mov cr4, eax
    mov edx, edi
    mov cr3, edx
    mov ecx, 0xC0000080
    rdmsr
    or eax, 0x00000100
    wrmsr
    mov ebx, cr0
    or ebx, 0x80000001
    mov cr0, ebx
    lgdt [GDT_Pointer]
    jmp CODE_SEG:Long_mode
[bits 64]

Long_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov rbp, 0x90000
    mov rsp, rbp
    jmp KERNEL_ADDRESS

GDT:
    dq 0x0
    dq 0x00209A0000000000
    dq 0x0000920000000000
ALIGN 4
    dw 0

GDT_Pointer:
    dw $ - GDT - 1
    dd GDT

ALIGN 4
NULL_IDT:
    dw 0
    dd 0

KDR: db "Failed to read the kernel!",0xA,0xD,0x00
DISK_RESET_ERROR: db "Disk reset fail!",0xA,0x00
NO_A20: db "Failed to enable A20!",0x00


times 1024 - ($ - $$) db 0x00

; VESA offsets

[bits 16]

VESA_video_mode_initialize:
    push es
    mov ax, 0x4F01
    mov cx, 0x0118
    mov bx, 0x9000
    mov es, bx
    xor si, si
    int 0x10
    pop es
    cmp ax, 0x004F
    jne video_fail
    mov ax, 0x4F02
    mov bx, 0x4118
    int 0x10
    cmp ax, 0x004F
    jne video_fail
	ret

video_fail:
	mov si, VIDEO_ERROR
	call print_string
	jmp halt

VIDEO_ERROR: db "Failed to set VESA video mode (1024 x 768 @ 16M)!",0x00

times 1536 - ($ - $$) db 0x00