#include "../kstdint.h"

#define DISPLAY_WIDTH 320
#define DISPLAY_HEIGHT 200
#define CHARACTER_HEIGHT 16

#define VIDEO_MEMORY 0xA0000

void set_pixel(uint16_t x, uint16_t y, uint8_t color);
void drawchar(uint8_t c, uint16_t x, uint16_t y, uint8_t fgcolor, uint8_t bgcolor);
void drawchar_default(uint8_t c, uint16_t x, uint16_t y);
void clear_screen();