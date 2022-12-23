#!/bin/sh
cd "$(dirname "$0")"
nasm Bootloader.asm -f bin -o ./Objects/Bootloader.bin
nasm Entry.asm -f elf64 -o ./Objects/Entry.o
nasm Kernel_assembly.asm -f elf64 -o ./Objects/Kernel_assembly.o
nasm ./CPU/Ports.asm -f elf64 -o ./Objects/Ports.o
nasm ./CPU/Interrupts.asm -f elf64 -o ./Objects/Interrupts-asm.o

for i in *.c 
do
    gcc $i -o ./Objects/${i%.c}.o -O0 -g -c -nostdinc -ffreestanding -nostdlib -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -Werror -Wall -Wextra -fno-exceptions -m64 -std=c11
done

for i in $(ls ./Drivers/ -1 -q -I *.h | grep .c)
do
    gcc ./Drivers/$i -o ./Objects/${i%.c}.o -O0 -g -c -nostdinc -ffreestanding -nostdlib -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -Werror -Wall -Wextra -fno-exceptions -m64 -std=c11
done

for i in $(ls ./CPU/ -1 -q -I *.h | grep .c)
do
    gcc ./CPU/$i -o ./Objects/${i%.c}.o -O0 -g -c -nostdinc -ffreestanding -nostdlib -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -Werror -Wall -Wextra -fno-exceptions -m64 -std=c11
done

ld -o ./Objects/Kernel_final.bin -Ttext 0x1000 -T linker.ld ./Objects/*.o
cat ./Objects/Bootloader.bin ./Objects/Kernel_final.bin Zeros.bin > Final.bin