#include "../kstdint.h"
#include "../Memory.h"
#include "Video_driver.h"

void draw_char_default(uint8_t c, uint16_t x, uint16_t y) {
	draw_char(c, x, y, 0x18, 0x00);
}

/*void set_pixel(uint16_t x, uint16_t y, uint8_t color) { // Removed because too buggy
	
	if (x > DISPLAY_WIDTH || y > DISPLAY_HEIGHT) return;

	uint8_t* location = (uint8_t*) VIDEO_MEMORY + (y * DISPLAY_WIDTH + x) + 4;
	*location = color;
}*/

void clear_screen() {
	memory_set((void*) VIDEO_MEMORY, 0x00, 0xFA00);
}