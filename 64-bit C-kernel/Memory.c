#include "Memory.h"

void* readSegAddr32(uint32_t address) {
    uint16_t seg = (address >> 16) & 0xFFFF;
    uint16_t addr = address & 0xFFFF;
    return (void*) ((uint64_t) (seg * 16 + addr));
};

void* readSegAddr16(uint16_t seg, uint16_t addr) {
    return (void*) ((uint64_t) (seg * 16 + addr));
};