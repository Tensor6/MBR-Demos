#include "Kernel.h"
//#include "Drivers/ATA_Driver.h"
#include "CPU/Ports.h"
#include "Drivers/Video_driver.h"
#include "CPU/Interrupts.h"
#include "Memory.h"

void kernel_main() {
                  //AARRGGBB
    set_pixel(0,0,0xFF000000);
    set_pixel(1,1,0x00FF0000);
    set_pixel(2,2,0x0000FF00);
    set_pixel(2,2,0x000000FF);
}