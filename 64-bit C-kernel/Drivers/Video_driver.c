#include "../kstdint.h"
#include "../Memory.h"
#include "../Kernel.h"
#include "../CPU/Ports.h"
#include "Video_driver.h"

#define VESA_INFO_STRUCT 0xFC00
#define VESA_MODE_INFO_STRUCT 0xFE00

struct vbe_mode_info_structure* vbe_info;
struct vbe_info_structure* vesa_info;

const char* font = (char*) 0x9E000;

void init_video(){
	vbe_info = (struct vbe_mode_info_structure*) VESA_MODE_INFO_STRUCT;
    vesa_info = (struct vbe_info_structure*) VESA_INFO_STRUCT;
    if ((vbe_info->attributes & 0x80) == 0 && (vbe_info->bpp != 24 && vbe_info->bpp != 32)){
       reset_cpu();
       __builtin_unreachable();
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

void dset(){
    *((uint32_t*) (uint64_t)vbe_info->framebuffer) = 0xFFFFFFFFU;
}

void set_pixel(uint16_t x, uint16_t y, uint32_t color){
    if (vbe_info->bpp == 32){
        uint32_t* loc = (uint32_t*) (uint64_t) (0xA0000 + y * vbe_info->pitch + x * 4);
        *loc = 0x00 | (color << vbe_info->red_mask) | (color << vbe_info->green_position) | (color << vbe_info->blue_position);
    } else {
        uint16_t* loc16 = (uint16_t*) (uint64_t) (0xA0000 + y * vbe_info->pitch + x * 3);
        *loc16 = (color << vbe_info->red_mask) | (color << vbe_info->green_mask);
        uint8_t* loc8 = (uint8_t*) loc16 + 2;
        *loc8 = (color << vbe_info->blue_mask);
    }
};
void draw_char(uint8_t c, uint16_t x, uint16_t y, uint32_t fgcolor){
    int cx,cy;
	int mask[8]={1,2,4,8,16,32,64,128};
	unsigned char *glyph=((uint8_t*)0x9E000)+(int)c*16;
 
	for(cy=0;cy<16;cy++){
		for(cx=0;cx<8;cx++){
			if(glyph[cy]&mask[cx]) set_pixel(fgcolor,x+cx,y+cy-12);
		}
	}
};
void draw_char_default(uint8_t c, uint16_t x, uint16_t y){
    draw_char(c,x,y,~0);
};

void print_string(const char* string, uint16_t x, uint16_t y){
    while(*string){
        draw_char_default(*string++,x,y);
        x += CHARACTER_WIDTH;
    }
};

struct vbe_mode_info_structure* getModeInfo(){
    return vbe_info;
};

void clear_screen(){

};
