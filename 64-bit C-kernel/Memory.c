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
    uint64_t* pml4 = (uint64_t*) 0x100000; // Page Map Level 4 table at the 1 megabyte mark
    uint64_t* pdpt = (uint64_t*) 0x101000; // Page directory pointer table at the 1 megabyte mark + 4096 bytes
    uint64_t* pd = (uint64_t*) 0x108000; // Page directory
    uint64_t* pt = (uint64_t*) 0x110000; // Page table
    *pml4 = 0x101003; // Set first pointer in PML4 to point to PDPT
    *pdpt = 0x108003; // Set first pointer in PDPT to point to PD
    uint64_t address = 3;
    for (uint32_t i = 0; i < 512; i++){
        *pd++ = (uint64_t) pt | 0x03;
        for (uint32_t j = 0; j < 512; j++){
            *pt++ = address;
            address += 0x1000;
        }
    }
    set_PML4(pml4);
    stop_kernel();
};