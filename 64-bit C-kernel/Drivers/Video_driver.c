#include "../kstdint.h"
#include "../Memory.h"
#include "Video_driver.h"

static const uint64_t vga_bios_font = (uint64_t) 0x9E000;
static const uint8_t CHAR_MASK[8]={

	//1,2,4,8,16,32,64,128

	0b00000001,
	0b00000010,
	0b00000100,
	0b00001000,
	0b00010000,
	0b00100000,
	0b01000000,
	0b10000000,
	
};

void drawchar(uint8_t c, uint16_t x, uint16_t y, uint8_t fgcolor, uint8_t bgcolor) {
	if (x > WIDTH - 1 || y > HEIGHT - 1) return;
	uint8_t* font_char = (uint8_t*) (vga_bios_font + (uint32_t) c * 16);
	for (uint32_t cy = 0; cy < CHARACTER_HEIGHT; cy++){
		for (uint32_t cx = 0; cy < 8; cx++){
			set_pixel(x+cx,y+cy-12,font_char[cy] & CHAR_MASK[cx] ? fgcolor : bgcolor);
		}
	}
}

void drawchar_default(uint8_t c, uint16_t x, uint16_t y) {
	drawchar(c, x, y, 0x18, 0x00);
}

void set_pixel(uint16_t x, uint16_t y, uint8_t color) {
	if (x > WIDTH - 1 || y > HEIGHT - 1) return;
	uint8_t* location = (uint8_t*)0xA0000 + WIDTH * y + x;
	*location = color;
}

void clear_screen() {
	memory_set((void*) 0xA0000, 0x00, 0xFA00);
}