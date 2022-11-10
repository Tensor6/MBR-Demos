#define UNUSED(x) (void)(x)

__attribute__((noreturn)) void halt_kernel(){
    __asm__ __volatile__ ("cli");
    while(1){
        __asm__ __volatile__ ("hlt");
    }
    __builtin_unreachable();
}