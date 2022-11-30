ENTRY(_start)
OUTPUT_FORMAT("binary")
SECTIONS {
    . = 0x00005000;
    _start = .;
    .text :
    {
        *(.boot)
        *(.text)
        . = ALIGN(4096);
    }
    .rodata :
    {
        *(.rodata)
        . = ALIGN(4096);
    }
    .data :
    {
        *(.data)
        . = ALIGN(4096);
    }
    .bss :
    {
        *(.bss)
        . = ALIGN(4096);
    }
    /DISCARD/ : 
    {
        *(.note.gnu.property)
        *(.comment)
    }
}