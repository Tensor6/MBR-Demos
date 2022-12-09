#include "../kstdint.h"

#define CHARACTER_HEIGHT 16
#define CHARACTER_WIDTH 8

struct vbe_info_structure {
	uint32_t signature;	        // must be "VESA" to indicate valid VBE support
	uint16_t version;			// VBE version; high byte is major version, low byte is minor version
	uint32_t oem;			    // segment:offset pointer to OEM
	uint32_t capabilities;		// bitfield that describes card capabilities
	uint32_t video_modes;		// segment:offset pointer to list of supported video modes
	uint16_t video_memory;		// amount of video memory in 64KB blocks
	uint16_t software_rev;		// software revision
	uint32_t vendor;			// segment:offset to card vendor string
	uint32_t product_name;		// segment:offset to card model name
	uint32_t product_rev;		// segment:offset pointer to product revision
	char reserved[222];		    // reserved for future expansion
	char oem_data[256];		    // OEM BIOSes store their strings in this area
} __attribute__ ((packed));

struct vbe_mode_info_structure {
    uint16_t attributes;
    uint8_t window_a;
    uint8_t window_b;
    uint16_t granularity;
    uint16_t window_size;
    uint16_t segment_a;
    uint16_t segment_b;
    uint32_t win_func_ptr;
    uint16_t pitch;
    uint16_t width;
    uint16_t height;
    uint8_t w_char;
    uint8_t y_char;
    uint8_t planes;
    uint8_t bpp;
    uint8_t banks;
    uint8_t memory_model;
    uint8_t bank_size;
    uint8_t image_pages;
    uint8_t reserved0;
    uint8_t red_mask;
    uint8_t red_position;
    uint8_t green_mask;
    uint8_t green_position;
    uint8_t blue_mask;
    uint8_t blue_position;
    uint8_t reserved_mask;
    uint8_t reserved_position;
    uint8_t direct_color_attributes;
    uint32_t framebuffer;
    uint32_t off_screen_mem_off;
    uint16_t off_screen_mem_size;
    uint8_t reserved1[206];
} __attribute__ ((packed));

void init_video();
void set_pixel(uint16_t x, uint16_t y, uint32_t color);
void draw_char(uint8_t c, uint16_t x, uint16_t y, uint8_t fgcolor, uint8_t bgcolor);
void draw_char_default(uint8_t c, uint16_t x, uint16_t y);
void clear_screen();
uint16_t getWidth();
uint16_t getHeight();
uint16_t getPitch();