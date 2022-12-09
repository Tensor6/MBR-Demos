#ifndef MEMORY_H
#define MEMORY_H

#include "kstdint.h"

extern void memcpy8(void* dest, void* src, uint64_t length);
extern void memset8(void* buffer, uint8_t value, uint64_t length);
extern void memcpy16(void* dest, void* src, uint64_t length);
extern void memset16(void* buffer, uint16_t value, uint64_t length);
extern void memcpy32(void* dest, void* src, uint64_t length);
extern void memset32(void* buffer, uint32_t value, uint64_t length);
extern void memcpy64(void* dest, void* src, uint64_t length);
extern void memset64(void* buffer, uint64_t value, uint64_t length);

void* readSegAddr32(uint32_t address);
void* readSegAddr16(uint16_t segment, uint16_t address);

#endif