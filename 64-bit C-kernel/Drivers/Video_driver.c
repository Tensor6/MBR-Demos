#include "../kstdint.h"
#include "../Memory.h"
#include "Video_driver.h"

/*void draw_char(uint8_t c, uint16_t x, uint16_t y, uint8_t fgcolor, uint8_t bgcolor) {
	if (x > DISPLAY_WIDTH - 1 || y > DISPLAY_HEIGHT - 1) return;
	uint8_t* font_char = (uint8_t*) (vga_bios_font + (uint32_t) c * 16);
	for (uint32_t cy = 0; cy < CHARACTER_HEIGHT; cy++){
		for (uint32_t cx = 0; cy < 8; cx++){
			set_pixel(x+cx,y+cy-12,font_char[cy] & CHAR_MASK[cx] ? fgcolor : bgcolor);
		}
	}
}*/

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