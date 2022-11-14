#include "kstdint.h"
#include "Kernel.h"
#include "Drivers/ATA_Driver.h"
#include "CPU/Ports.h"
#include "Drivers/Video_driver.h"
#include "Memory.h"

void initialize_kernel() {
    
}

void kernel_main() {
    drawchar_default(0,0,'A');
}