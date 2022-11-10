#ifndef MEMORY_H
#define MEMORY_H

extern void memory_copy(void* dest, void* src, uint64_t length);
extern void memory_set(void* buffer, uint8_t value, uint64_t length);

#endif