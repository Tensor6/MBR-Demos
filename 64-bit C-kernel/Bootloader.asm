[org 0x7c00]
[bits 16]

%define KERNEL_SECTOR_COUNT 16
%define KERNEL_ADDRESS 0x1000

%define VESA_INFO_STRUCT 0xFC00
%define VESA_MODE_INFO_STRUCT 0xFE00


; MODE    RESOLUTION  BITS PER PIXEL  MAXIMUM COLORS
; 0x0100  640x400     8               256
; 0x0101  640x480     8               256
; 0x0102  800x600     4               16
; 0x0103  800x600     8               256
; 0x010D  320x200     15              32k
; 0x010E  320x200     16              64k
; 0x010F  320x200     24/32*          16m
; 0x0110  640x480     15              32k
; 0x0111  640x480     16              64k
; 0x0112  640x480     24/32*          16m
; 0x0113  800x600     15              32k
; 0x0114  800x600     16              64k
; 0x0115  800x600     24/32*          16m
; 0x0116  1024x768    15              32k
; 0x0117  1024x768    16              64k
; 0x0118  1024x768    24/32*          16m

%define VESA_VIDEO_MODE 0x0118

%define PAGE_ATTR 0x03

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

DISK_ERROR_MSG: db "Disk read error!",0xD,0xA,0x00
SECTOR_ERROR_MSG: db "Sector read error!",0xD,0xA,0x00
NO_CPUID: db "CPUID is not supported!",0x00
NO_CPU64: db "Long mode (64-bit) is not supported!",0x00
MCF: db "Memory check failed or not enough memory!",0x00
BOOT_DRIVE: db 0x00

times 510-($-$$) db 0x00
dw 0xAA55

LOAD_ADDRESS:
    call disk_reset
    call load_kernel
    call A20_enable
    call load_bios_font
	call VESA_video_mode_initialize
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
    ret
    
start64:
    mov di, 0x9000
    push di
	mov ecx, 0x1000
	xor eax, eax
	cld
	rep stosd
	pop di
	lea eax, [es:di + 0x1000]
	or eax, PAGE_ATTR
	mov [es:di], eax
	lea eax, [es:di + 0x2000]
	or eax, PAGE_ATTR
	mov [es:di + 0x1000], eax

	lea eax, [es:di + 0x3000]
	or eax, PAGE_ATTR
	mov [es:di + 0x2000], eax
    lea eax, [es:di + 0x3008]
	or eax, PAGE_ATTR
	mov [es:di + 0x2008], eax
    lea eax, [es:di + 0x3010]
	or eax, PAGE_ATTR
	mov [es:di + 0x2010], eax
    lea eax, [es:di + 0x3018]
	or eax, PAGE_ATTR
	mov [es:di + 0x2018], eax
    lea eax, [es:di + 0x3026]
	or eax, PAGE_ATTR
	mov [es:di + 0x2026], eax
    lea eax, [es:di + 0x302E]
	or eax, PAGE_ATTR
	mov [es:di + 0x202E], eax

	push di
	lea di, [di + 0x3000]
	mov eax, PAGE_ATTR
.loop_pages:
	mov [es:di], eax
	add eax, 0x1000
	add di, 8
	cmp eax, 0xA00000
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
NO_A20: db "Failed to enable A20!",0x00


times 1024 - ($ - $$) db 0x00

; VESA offsets

[bits 16]

VESA_video_mode_initialize:
    mov ax, 0x4F00
    xor bx, bx
    mov es, bx
    mov di, VESA_INFO_STRUCT
    int 0x10
    cmp ax, 0x004F
    jne .no_vesa
    mov si, VIDEO_ERROR ; First 4 bytes are "VESA"
    mov di, VESA_INFO_STRUCT
    cmpsd
    jne .no_vesa
    mov ax, [VESA_INFO_STRUCT + 4]
    cmp ax, 0x200
    jb .no_vesa
    call check_video_mode_support
    mov ax, 0x4F01
    mov cx, VESA_VIDEO_MODE
    xor bx, bx
    mov es, bx
    mov di, VESA_MODE_INFO_STRUCT
    int 0x10
    cmp ax, 0x004F
    jne .video_fail
    mov WORD ax, [di]
    test ax, 0x80
    jz .no_linear
    mov ax, 0x4F02
    mov bx, (0x4000 | VESA_VIDEO_MODE)
    int 0x10
    cmp ax, 0x004F
    jne .video_fail
	ret
.no_vesa:
    mov si, NO_VESA
.error_code:
    call print_string
    push ax
    call print_hex_word
    jmp halt
.video_fail:
	mov si, VIDEO_ERROR
	jmp .error_code
.no_linear:
    mov si, NO_LINEAR
    call print_string
    jmp halt


check_video_mode_support:
    push ds
    mov WORD ax, [VESA_INFO_STRUCT + 16]
    mov ds, ax
    mov WORD si, [VESA_INFO_STRUCT + 14]
.loop:
    lodsw
    cmp ax, VESA_VIDEO_MODE
    je .end
    cmp ax, 0xFFFF
    je .video_mode_no_support
    jmp .loop
.end:
    pop ds
    ret
.video_mode_no_support:
    pop ds
    mov si, VM_NO_SUPPORT
    call print_string
    push WORD VESA_VIDEO_MODE
    call print_hex_word
    mov si, VM_NO_SUPPORT2
    call print_string
    jmp halt
    
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

VIDEO_ERROR: db "VESA video service error!",0xA,0xD,0x00
NO_VESA: db "BIOS does not support VESA 2.0 video services!",0xA,0xD,0x00
NO_LINEAR: db "Video mode does not support linear framebuffer!",0x00
VM_NO_SUPPORT: db "video mode ( 0x",0x00
VM_NO_SUPPORT2: db " ) not supported by BIOS",0xD,0xA,0x00

times 1536 - ($ - $$) db 0x00
;pml4:
;    dq PTE_PRESENT | PTE_WRITE | PTE_USER
;    resb 4096
;
;times 2048 - ($ - $$) db 0x00