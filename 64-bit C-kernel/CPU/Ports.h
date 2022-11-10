#include "../kstdint.h"

#ifndef PORTS_H
#define PORTS_H
extern void outb(uint16_t port, uint8_t data);
extern uint8_t inb(uint16_t port);
extern void outw(uint16_t port, uint16_t data);
extern uint16_t inw(uint16_t port);
extern void memcpy_portw(void* buffer, uint16_t port, uint64_t length);
#endif