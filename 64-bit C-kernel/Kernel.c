#include "Kernel.h"
//#include "Drivers/ATA_Driver.h"
#include "CPU/Ports.h"
#include "Drivers/Video_driver.h"
#include "Memory.h"

void initialize_kernel() {
    clear_screen();
}

__attribute__((noreturn)) __attribute__((naked)) void halt_kernel(){
    __asm__ __volatile__ ("cli");
    while(1){
        __asm__ __volatile__ ("hlt");
    }
    __builtin_unreachable();
}

static const uint8_t letter[16] = {
    0b00000000,
    0b00000000,
    0b00000000,
    0b00010000,
    0b00111000,
    0b01101100,
    0b11000110,
    0b11000110,
    0b11111110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b11000110,
    0b00000000,
    0b00000000,
    0b00000000
};

static const uint8_t char_mask[8] = {
    0b00000001,
    0b00000010,
    0b00000100,
    0b00001000,
    0b00010000,
    0b00100000,
    0b01000000,
    0b10000000
};

void kernel_main() {
    UNUSED(letter);
    UNUSED(char_mask);
    draw_char('A',1,1,0x30,0x28);
    /*set_pixel(0,0,0);
    set_pixel(1,0,0);
    set_pixel(2,0,0);
    set_pixel(3,0,0);
    set_pixel(4,0,0);
    set_pixel(5,0,0);
    set_pixel(6,0,0);
    set_pixel(7,0,0);

    set_pixel(0,1,0);
    set_pixel(1,1,0);
    set_pixel(2,1,0);
    set_pixel(3,1,0);
    set_pixel(4,1,0);
    set_pixel(5,1,0);
    set_pixel(6,1,0);
    set_pixel(7,1,0);

    set_pixel(0,2,0);
    set_pixel(1,2,0);
    set_pixel(2,2,0);
    set_pixel(3,2,0);
    set_pixel(4,2,0);
    set_pixel(5,2,0);
    set_pixel(6,2,0);
    set_pixel(7,2,0);

    set_pixel(0,3,0);
    set_pixel(1,3,0);
    set_pixel(2,3,0);
    set_pixel(3,3,0x30);
    set_pixel(4,3,0);
    set_pixel(5,3,0);
    set_pixel(6,3,0);
    set_pixel(7,3,0);

    set_pixel(0,4,0);
    set_pixel(1,4,0);
    set_pixel(2,4,0x30);
    set_pixel(3,4,0x30);
    set_pixel(4,4,0x30);
    set_pixel(5,4,0);
    set_pixel(6,4,0);
    set_pixel(7,4,0);

    set_pixel(0,5,0);
    set_pixel(1,5,0x30);
    set_pixel(2,5,0x30);
    set_pixel(3,5,0);
    set_pixel(4,5,0x30);
    set_pixel(5,5,0x30);
    set_pixel(6,5,0);
    set_pixel(7,5,0);

    set_pixel(0,6,0x30);
    set_pixel(1,6,0x30);
    set_pixel(2,6,0);
    set_pixel(3,6,0);
    set_pixel(4,6,0);
    set_pixel(5,6,0x30);
    set_pixel(6,6,0x30);
    set_pixel(7,6,0);

    set_pixel(0,7,0x30);
    set_pixel(1,7,0x30);
    set_pixel(2,7,0);
    set_pixel(3,7,0);
    set_pixel(4,7,0);
    set_pixel(5,7,0x30);
    set_pixel(6,7,0x30);
    set_pixel(7,7,0);

    set_pixel(0,7,0x30);
    set_pixel(1,7,0x30);
    set_pixel(2,7,0x30);
    set_pixel(3,7,0x30);
    set_pixel(4,7,0x30);
    set_pixel(5,7,0x30);
    set_pixel(6,7,0x30);
    set_pixel(7,7,0);

    set_pixel(0,8,0x30);
    set_pixel(1,8,0x30);
    set_pixel(2,8,0);
    set_pixel(3,8,0);
    set_pixel(4,8,0);
    set_pixel(5,8,0x30);
    set_pixel(6,8,0x30);
    set_pixel(7,8,0);

    set_pixel(0,9,0x30);
    set_pixel(1,9,0x30);
    set_pixel(2,9,0);
    set_pixel(3,9,0);
    set_pixel(4,9,0);
    set_pixel(5,9,0x30);
    set_pixel(6,9,0x30);
    set_pixel(7,9,0);

    set_pixel(0,10,0x30);
    set_pixel(1,10,0x30);
    set_pixel(2,10,0);
    set_pixel(3,10,0);
    set_pixel(4,10,0);
    set_pixel(5,10,0x30);
    set_pixel(6,10,0x30);
    set_pixel(7,10,0);

    set_pixel(0,11,0x30);
    set_pixel(1,11,0x30);
    set_pixel(2,11,0);
    set_pixel(3,11,0);
    set_pixel(4,11,0);
    set_pixel(5,11,0x30);
    set_pixel(6,11,0x30);
    set_pixel(7,11,0);

    set_pixel(0,12,0);
    set_pixel(1,12,0);
    set_pixel(2,12,0);
    set_pixel(3,12,0);
    set_pixel(4,12,0);
    set_pixel(5,12,0);
    set_pixel(6,12,0);
    set_pixel(7,12,0);*/
}