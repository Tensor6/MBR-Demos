#include "Kernel.h"
//#include "Drivers/ATA_Driver.h"
#include "CPU/Ports.h"
#include "Drivers/Video_driver.h"
#include "CPU/Interrupts.h"
#include "Memory.h"

void kernel_main() {
    uint32_t* fb = (uint32_t*) (uint64_t) getModeInfo()->framebuffer;
    for (uint16_t i = 0; i < 500; i += sizeof(uint32_t*)) {
        *(fb + i) = 0xFFFFFF00;
    }
}