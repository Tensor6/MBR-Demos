#include "../kstdint.h"
#include "../Memory.h"
#include "Video_driver.h"

uint16_t x = 0, y = 0;



void draw_char_default(uint8_t c, uint16_t x, uint16_t y) {
	draw_char(c, x, y, 0x18, 0x00);
}

void clear_screen() {
	memset64((void*) VIDEO_MEMORY, 0x00, 8000);
}

