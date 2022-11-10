#include "../kstdint.h"
#include "ATA_Driver.h"
#include "../CPU/Ports.h"

#define UNUSED(x) (void)(x)

#define ATA_PRIMARY_DATA 0x1F0
#define ATA_PRIMARY_ERR 0x1F1
#define ATA_PRIMARY_SECCOUNT 0x1F2
#define ATA_PRIMARY_LBA_LO 0x1F3
#define ATA_PRIMARY_LBA_MID 0x1F4
#define ATA_PRIMARY_LBA_HI 0x1F5
#define ATA_PRIMARY_DRIVE_HEAD 0x1F6
#define ATA_PRIMARY_COMM_REGSTAT 0x1F7
#define ATA_PRIMARY_ALTSTAT_DCR 0x3F6


#define STAT_ERR (1 << 0)
#define STAT_DRQ (1 << 3)
#define STAT_SRV (1 << 4)
#define STAT_DF (1 << 5)
#define STAT_RDY (1 << 6)
#define STAT_BSY (1 << 7)

void ATA_wait_BSY() {
    while(inb(ATA_PRIMARY_COMM_REGSTAT) & STAT_BSY);
};

void ATA_wait_DRQ() {
    while(!(inb(ATA_PRIMARY_COMM_REGSTAT) & STAT_DRQ));
};

void ATA_Read_LBA_28B(void* buffer, uint32_t lba_address, uint8_t sectors) {
    ATA_wait_BSY();
    outb(ATA_PRIMARY_DRIVE_HEAD, 0xE0 | ((lba_address >> 24) & 0x0F));
    outb(ATA_PRIMARY_SECCOUNT, sectors);
    outb(ATA_PRIMARY_LBA_LO, lba_address & 0xFF);
    outb(ATA_PRIMARY_LBA_MID, (lba_address >> 8) & 0xFF);
    outb(ATA_PRIMARY_LBA_HI, (lba_address >> 16) & 0xFF);
    outb(ATA_PRIMARY_COMM_REGSTAT, 0x20);
    for (uint16_t i = 0; i < sectors; i++){
        ATA_wait_BSY();
        ATA_wait_DRQ();
        memcpy_portw(buffer, ATA_PRIMARY_DATA, 256);
    }
};

void ATA_Reset() {
};

uint8_t ATA_identify() {
    inb(ATA_PRIMARY_COMM_REGSTAT);
    outb(ATA_PRIMARY_DRIVE_HEAD, 0xA0);
    inb(ATA_PRIMARY_COMM_REGSTAT);
    outb(ATA_PRIMARY_SECCOUNT, 0);
    inb(ATA_PRIMARY_COMM_REGSTAT);
    outb(ATA_PRIMARY_LBA_LO, 0);
    inb(ATA_PRIMARY_COMM_REGSTAT);
    outb(ATA_PRIMARY_LBA_MID, 0);
    inb(ATA_PRIMARY_COMM_REGSTAT);
    outb(ATA_PRIMARY_LBA_HI, 0);
    inb(ATA_PRIMARY_COMM_REGSTAT);
    outb(ATA_PRIMARY_COMM_REGSTAT, 0xEC);
    outb(ATA_PRIMARY_COMM_REGSTAT, 0xE7);
    uint8_t status = inb(ATA_PRIMARY_COMM_REGSTAT);
    ATA_wait_BSY();
    if (status == 0) return 0;
    ATA_wait_BSY();
    uint8_t mid = inb(ATA_PRIMARY_LBA_MID);
    uint8_t high = inb(ATA_PRIMARY_LBA_HI);
    if (mid || high){
        return 0;
    }
    while(!(status & (STAT_ERR | STAT_DRQ))){
        status = inb(ATA_PRIMARY_COMM_REGSTAT);
    }
    if (status & STAT_ERR){
        return 0;
    }
    memcpy_portw((void*)0, ATA_PRIMARY_DATA, 256);
    return 1;
};