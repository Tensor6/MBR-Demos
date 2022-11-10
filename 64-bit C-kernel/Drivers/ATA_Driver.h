#include "../kstdint.h"

void ATA_wait_BSY();
void ATA_wait_DRQ();
void ATA_Reset();
void ATA_Read_LBA_28B(void* buffer, uint32_t lba_address, uint8_t sectors);
uint8_t ATA_identify();