#include "../kstdint.h"
#include "../Memory.h"
#include "../Kernel.h"
#include "../CPU/Ports.h"
#include "Video_driver.h"

#define VESA_INFO_STRUCT 0xFC00
#define VESA_MODE_INFO_STRUCT 0xFE00

struct vbe_mode_info_structure* vbe_info;
struct vbe_info_structure* vesa_info;

void init_video(){
	vbe_info = (struct vbe_mode_info_structure*) VESA_MODE_INFO_STRUCT;
    vesa_info = (struct vbe_info_structure*) VESA_INFO_STRUCT;
    if ((vbe_info->attributes & 0x80) == 0 && (vbe_info->bpp != 24 && vbe_info->bpp != 32)){
       reset_cpu();
    }
}

uint16_t getWidth(){
    return vbe_info->width;
};

uint16_t getHeight(){
    return vbe_info->height;
};

uint16_t getPitch(){
    return vbe_info->pitch;
};


void set_pixel(uint16_t x, uint16_t y, uint32_t color){
    if (vbe_info->bpp == 32){
        
    } else {
        
    }
};
void draw_char(uint8_t c, uint16_t x, uint16_t y, uint8_t fgcolor, uint8_t bgcolor);
void draw_char_default(uint8_t c, uint16_t x, uint16_t y);

void clear_screen(){

};
