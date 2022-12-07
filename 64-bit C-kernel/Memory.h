#ifndef MEMORY_H
#define MEMORY_H

extern void memcpy8(void* dest, void* src, uint64_t length);
extern void memset8(void* buffer, uint8_t value, uint64_t length);

extern void memcpy16(void* dest, void* src, uint64_t length);
extern void memset16(void* buffer, uint16_t value, uint64_t length);

extern void memcpy32(void* dest, void* src, uint64_t length);
extern void memset32(void* buffer, uint32_t value, uint64_t length);

extern void memcpy64(void* dest, void* src, uint64_t length);
extern void memset64(void* buffer, uint64_t value, uint64_t length);

#endif