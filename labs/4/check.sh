rm ./solution.out solution.o solution.lst
nasm -f elf64 newsolution.asm -o solution.o -l solution.lst
ld solution.o -o solution.out
./solution.out
