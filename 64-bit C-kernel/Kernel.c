#include "Kernel.h"
//#include "Drivers/ATA_Driver.h"
#include "CPU/Ports.h"
#include "Drivers/Video_driver.h"
#include "Memory.h"

void initialize_kernel() {
    init_video();
}

void kernel_main() {
    memset64((void*) 0xA0000, 0xFFAAFF00FFAAFF00, 16);
}