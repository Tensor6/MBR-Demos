#include "kstdint.h"
#define UNUSED(x) (void)(x)


extern void stop_kernel();
__attribute__((noreturn)) extern void reset_cpu();
extern uint64_t read_tsc();