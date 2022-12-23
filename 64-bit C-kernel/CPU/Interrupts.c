#include "Interrupts.h"
#include "Ports.h"
#include "../Memory.h"
#include "../Kernel.h"

#define ICW1_ICW4 0x01
#define ICW1_SINGLE	0x02
#define ICW1_INTERVAL4 0x04
#define ICW1_LEVEL 0x08
#define ICW1_INIT 0x10
#define ICW4_8086 0x01
#define ICW4_AUTO 0x02
#define ICW4_BUF_SLAVE 0x08
#define ICW4_BUF_MASTER 0x0C
#define ICW4_SFNM 0x10

idt_register IDT_REGISTER;

InterruptDescriptor64 GATES[ENTRIES];

extern void set_idt(void* addr);
extern void load_isr_entries();

void init_interrupts(){
    load_isr_entries();
    map_pic_chip();
    load_idt();
};

void ISR_handler(struct interrupt_frame* frame){
    UNUSED(frame); // TODO: print exception message
};

void IRQ_handler(struct interrupt_frame* frame){
    UNUSED(frame);
};

void send_EOI(uint8_t irq){
    if (irq >= 8){
        outb(PIC2_COMMAND, 0x20);
    }
    outb(PIC1_COMMAND, 0x20);
};

void map_pic_chip(){
    uint8_t A1 = inb(PIC1_DATA);
    uint8_t A2 = inb(PIC2_DATA);
    outb(PIC1_COMMAND, ICW1_INIT | ICW1_ICW4);
    outb(PIC2_COMMAND, ICW1_INIT | ICW1_ICW4);
    outb(PIC1_DATA, 0x20);
    outb(PIC2_DATA, 0x28);
    outb(PIC1_DATA, 4);
    outb(PIC2_DATA, 2);
    outb(PIC1_DATA, ICW4_8086);
    outb(PIC2_DATA, ICW4_8086);
    outb(PIC1_DATA, A1);
    outb(PIC2_DATA, A2);
}

void load_idt(){
    IDT_REGISTER.base = (uint64_t) &GATES;
    IDT_REGISTER.limit = ENTRIES * sizeof(InterruptDescriptor64) - 1;
    set_idt(&IDT_REGISTER);
};

void set_idt_entry(uint16_t index, uint64_t handler_addr){
    GATES[index].offset_1 = LOW_16(handler_addr);
    GATES[index].selector = KERNEL_SELECTOR;
    GATES[index].ist = 0;
    GATES[index].type_attributes = 0x8E;
    GATES[index].offset_2 = HIGH_16(handler_addr);
    GATES[index].offset_3 = HIGH_32(handler_addr);
    GATES[index].zero = 0;
};