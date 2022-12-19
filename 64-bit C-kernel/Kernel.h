#define UNUSED(x) (void)(x)
#include "kstdint.h"

extern void stop_kernel();
extern void reset_cpu();
extern uint64_t read_tsc();