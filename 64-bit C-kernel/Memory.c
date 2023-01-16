#include "Memory.h"
#include "Kernel.h"

void* readSegAddr32(uint32_t address) {
    uint16_t seg = (address >> 16) & 0xFFFF;
    uint16_t addr = address & 0xFFFF;
    return (void*) ((uint64_t) (seg * 16 + addr));
};

void* readSegAddr16(uint16_t seg, uint16_t addr) {
    return (void*) ((uint64_t) (seg * 16 + addr));
};

void rebuild_PML4(){
    *((uint64_t*) 0x10000) = 0x11000 | 0x03;
    *((uint64_t*) 0x11000) = 0x12000 | 0x03;
    uint64_t* pd = (uint64_t*) 0x12000;
    for (uint32_t i = 0; i < 1024; i++){
        *pd++ = (0x3000 + (i * 8)) | 0x03;
    }
    uint64_t* pt = (uint64_t*) 0x13000;
    for (uint64_t address = 3; address < 0x400000; address += 0x1000){
        *pt++ = address;
    }
    stop_kernel();
    //set_PML4((void*) 0x10000);
};