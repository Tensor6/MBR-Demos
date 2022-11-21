#include "Kernel.h"
//#include "Drivers/ATA_Driver.h"
#include "CPU/Ports.h"
#include "Drivers/Video_driver.h"
#include "Memory.h"

void initialize_kernel() {
    clear_screen();
}

void kernel_main() {
    draw_char('T',8*0,0,0x07,0);
    draw_char('o',8*1,0,0x07,0);
    draw_char('i',8*2,0,0x07,0);
    draw_char('m',8*3,0,0x07,0);
    draw_char('i',8*4,0,0x07,0);
    draw_char('i',8*5,0,0x07,0);
    draw_char('k',8*6,0,0x07,0);
    draw_char('o',8*7,0,0x07,0);
    draw_char('?',8*8,0,0x07,0);
    
    //stop_kernel();
}