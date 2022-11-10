[bits 64]
[section .text]

global outb
global outw
global inb
global inw
global memcpy_portw

outb:
    mov eax, esi
    mov edx, edi
    out dx, al
    ret

outw:
    mov eax, esi
    mov edx, edi
    out dx, ax
    ret

inb:
    mov edx, esi
    in al, dx
    ret

inw:
    mov edx, edi
    in ax, dx
    ret

memcpy_portw:
    mov ecx, edx
    mov edx, esi
    rep insw
    ret