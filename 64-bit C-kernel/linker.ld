ENTRY(_start)
OUTPUT_FORMAT("binary")
SECTIONS {
    .text :
    {
        *(.boot)
        *(.text)
    }
    .rodata :
    {
        *(.rodata)
    }
    .data :
    {
        *(.data)
    }
    .bss :
    {
        *(.bss)
    }
    /DISCARD/ : 
    {
        *(.note.gnu.property)
    }
}