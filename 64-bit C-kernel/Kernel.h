#define UNUSED(x) (void)(x)
#include "kstdint.h"

void halt_kernel();
extern uint64_t read_tsc();