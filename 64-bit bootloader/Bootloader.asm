[org 0x7c00]
[bits 16]

jmp boot
nop

KERNEL_SECTOR_COUNT equ 0x04 ; How many sectors does kernel occupies

KERNEL_ADDRESS equ 0x5000 ; Address where the kernel will be loaded
BOOTLOADER_SECTOR_READ_COUNT equ 0x03 ; How many sector the bootloader occupies

boot:
	mov [BOOT_DRIVE], dl

	cli
	xor ax, ax
	mov ds, ax
	mov sp, bp
	mov bp, 0x9000
	sti

	mov ax, 0x03
	int 0x10

	mov ax, 0xEC00
	mov bl, 0x03
	int 0x15
	
	call disk_load

	jmp LOAD_ADDRESS


disk_load:
	mov ah, 0x02
	mov al, BOOTLOADER_SECTOR_READ_COUNT
	xor bx, bx
	mov es, bx
	mov ch, 0x00
	mov cl, 0x02
	mov dh, 0x00
	mov dl, [BOOT_DRIVE]
	mov bx, LOAD_ADDRESS
	int 0x13
	jc .disk_error
	cmp al, BOOTLOADER_SECTOR_READ_COUNT
	jne .sector_error
	ret
.disk_error:
	mov si, DISK_ERROR_MSG
	call print_string
	jmp halt
.sector_error:
	mov si, SECTOR_ERROR_MSG
	call print_string

halt:
	cli
halt2:
	hlt
	jmp halt2

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

DISK_ERROR_MSG: db " Disk read error!",0xD,0xA,0x00
SECTOR_ERROR_MSG: db "Sector read error!",0xD,0xA,0x00
BOOT_DRIVE: db 0x00
ERROR_CODE: db 0x00
times 510-($-$$) db 0x00
dw 0xAA55

LOAD_ADDRESS:
	call disk_reset
	call load_kernel
	cli
	mov si, gdt_descriptor
	lgdt [si]
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:start_32bit

load_kernel:
	mov ah, 0x02
	mov al, KERNEL_SECTOR_COUNT
	mov bx, 0x00
	mov es, bx
	mov ch, 0x00
	mov cl, 0x04
	mov dh, 0x00
	mov si, BOOT_DRIVE
	mov dl, [si]
	mov bx, KERNEL_ADDRESS
	int 0x13
	jc .kdisk_error
	cmp al, KERNEL_SECTOR_COUNT
	jne .ksector_error
	ret
.kdisk_error:
	mov si, KDR
	call print_string
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


[bits 32]
start_32bit:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ebp, 0x90000
	mov esp, ebp
	pushfd
	pop eax
	mov ecx, eax
	xor eax, 1 << 21
	push eax
	popfd
	pushfd
	pop eax
	push ecx
	popfd
	xor eax, ecx
	jz CPUID_unavailable
	mov eax, 0x80000000
	cpuid
	cmp eax, 0x80000001
	jb cpu64_unavailable
	mov eax, 0x80000001
	cpuid
	test edx, 1 << 29
	jz cpu64_unavailable
	jmp switch_64bit

CPUID_unavailable:
	mov esi, NO_CPUID
	call print_string32
	jmp halt
cpu64_unavailable:
	mov esi, NOT_64BIT_COMPAT
	call print_string32
	jmp halt

print_string32:
	pusha
	push ebx
	mov ebx, 0xb8000
.loop:
	lodsb
	cmp al, 0x00
	je .end
	or eax, 0x0100
	mov WORD [ebx], ax
	mov WORD [ebx + 1], 0x0F
	add ebx, 2
	jmp .loop
.end:
	popa
	pop ebx
	ret
switch_64bit:
	mov eax, cr0
	and eax, 0x7FFFFFFF
	mov cr0, eax
	mov edi, 0x1000
	mov cr3, edi
	xor eax, eax
	mov ecx, 0x1000
	rep stosd
	mov edi, cr3

	mov DWORD [edi], 0x2003
	add edi, 0x1000
	mov DWORD [edi], 0x3003
	add edi, 0x1000
	mov DWORD [edi], 0x4003
	add edi, 0x1000
	mov ebx, 0x00000003
	mov ecx, 0x200
switch_64bit_set_entry:
	mov DWORD [edi], ebx
	add ebx, 0x1000
	add edi, 8
	loop switch_64bit_set_entry

switch_64bit_enable_paging:
	mov eax, cr4
	or eax, 1 << 5
	mov cr4, eax
	mov ecx, 0xC0000080
	rdmsr
	or eax, 1 << 8
	wrmsr
	mov eax, cr0
	or eax, 1 << 31
	mov cr0, eax
	mov si, gdt_descriptor
	lgdt [si]
	jmp CODE_SEG:start64

[bits 64]

start64:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ebp, 0x90000
	mov esp, ebp

	jmp KERNEL_ADDRESS

times 1024 - ($ - $$) db 0x00

gdt_start:
gdt_null:
	dd 0x0
	dd 0x0

gdt_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0

gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

gdt_end:
gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

NOT_64BIT_COMPAT: db "The processor does not support long mode (64-bit mode)!",0x00
NO_CPUID: db "The processor does not support CPUID!",0x00
KDR: db "Failed to read the kernel!",0x00
DISK_RESET_ERROR: db "Disk reset fail!",0xA,0x00

times 1536 - ($ - $$) db 0x00