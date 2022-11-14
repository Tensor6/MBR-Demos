#include "Kernel.h"
//#include "Drivers/ATA_Driver.h"
#include "CPU/Ports.h"
#include "Drivers/Video_driver.h"
#include "Memory.h"

void initialize_kernel() {
    clear_screen();
}

__attribute__((noreturn)) void halt_kernel(){
    __asm__ __volatile__ ("cli");
    while(1){
        __asm__ __volatile__ ("hlt");
    }
    __builtin_unreachable();
}

static const uint8_t letter[16] = {
    0,
    0,
    0,
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
    0,0,0
};

void kernel_main() {
    UNUSED(letter);
    set_pixel(0,160,0x30);
}