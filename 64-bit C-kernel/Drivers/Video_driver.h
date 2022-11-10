#include "../kstdint.h"

#define WIDTH 320
#define HEIGHT 200
#define CHARACTER_HEIGHT 16

void set_pixel(uint16_t x, uint16_t y, uint8_t color);
void drawchar(uint8_t c, uint16_t x, uint16_t y, uint8_t fgcolor, uint8_t bgcolor);
void drawchar_default(uint8_t c, uint16_t x, uint16_t y);
void clear_screen();