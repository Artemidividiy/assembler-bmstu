all:
	nasm -g -f elf64 solution.asm
	g++ -no-pie -g main.cpp log_reverse.cpp solution.o
