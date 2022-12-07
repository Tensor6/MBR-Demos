#include "../kstdint.h"

#define CHARACTER_HEIGHT 16
#define CHARACTER_WIDTH 8

void init_video();
void set_pixel(uint16_t x, uint16_t y, uint32_t color);
void draw_char(uint8_t c, uint16_t x, uint16_t y, uint8_t fgcolor, uint8_t bgcolor);
void draw_char_default(uint8_t c, uint16_t x, uint16_t y);
void clear_screen();
uint16_t getWidth();
uint16_t getHeight();
uint16_t getPitch();