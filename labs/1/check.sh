rm ./solution.out solution.o solution.lst
nasm -f elf64 solution.asm -o solution.o -l solution.lst
ld solution.o -o solution.out
./a.out