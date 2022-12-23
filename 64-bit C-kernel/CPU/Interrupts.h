#include "../kstdint.h"

#define ENTRIES 256
#define KERNEL_SELECTOR 8

#define PIC1_COMMAND 0x20
#define PIC1_DATA (PIC1_COMMAND+1)
#define PIC2_COMMAND 0xA0
#define PIC2_DATA (PIC2_COMMAND+1)

typedef struct {
    uint16_t limit;
    uint64_t base;
} __attribute__((packed)) idt_register;

typedef struct {
   uint16_t offset_1;        // offset bits 0..15
   uint16_t selector;        // a code segment selector in GDT or LDT
   uint8_t  ist;             // bits 0..2 holds Interrupt Stack Table offset, rest of bits zero.
   uint8_t  type_attributes; // gate type, dpl, and p fields
   uint16_t offset_2;        // offset bits 16..31
   uint32_t offset_3;        // offset bits 32..63
   uint32_t zero;
} __attribute__((packed)) InterruptDescriptor64;

struct interrupt_frame {
    uint16_t interrupt_vector;
    uint64_t error_code;
    uint64_t rip;
    uint64_t cs;
    uint64_t rflags;
    uint64_t rsp;
    uint16_t ss;
} __attribute__((packed));

void init_interrupts();
void load_idt();
void set_idt_entry(uint16_t index, uint64_t handler_addr);
void map_pic_chip();
void send_EOI(uint8_t irq);
void ISR_handler(struct interrupt_frame* frame);
void IRQ_handler(struct interrupt_frame* frame);