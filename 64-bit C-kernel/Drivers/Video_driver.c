#include "../kstdint.h"
#include "../Memory.h"
#include "Video_driver.h"

uint16_t x = 0, y = 0;

void draw_char_default(uint8_t c, uint16_t x, uint16_t y) {
	draw_char(c, x, y, 0x18, 0x00);
}

void print_string(void* string_ptr){
	char* sptr = (char*) string_ptr;
	while(*sptr){
		char t = *sptr;
		if (t == '\n'){
			y += CHARACTER_HEIGHT;
			continue;
		}
		draw_char(t,x,y,0x07,0);
		x += 8;
	}
};

void clear_screen() {
	memory_set((void*) VIDEO_MEMORY, 0x00, 0xFA00);
}