; b_sort.asm
; bubble sort
; nasm -f elf64 -o b_sort.o b_sort.asm
; gcc -o b_sort b_sort.o
; ./b_sort
extern printf
 
section .data
	array: dq 5,4,3,2,1 
	fmt: db '%ld',0xa,0
 
section .text
global main
main:
	push rbp
	mov rsi, 0
	mov rdi, 0
L1:
	cmp rsi, 5
	jge L1_END
	mov rdi, rsi
	inc rdi
	L2:
		cmp rdi, 5
		jge L2_END
		mov rax, [array+rsi*8]
		mov rbx, [array+rdi*8]
		cmp rax, rbx
		jg exchange
		inc rdi
		jmp L2
	exchange:
		mov [array+rdi*8], rax
		mov [array+rsi*8], rbx
		inc rdi
		jmp L2
	L2_END:
		inc rsi
		jmp L1
L1_END:
	mov rbx, 0
L3:
	cmp rbx, 5
	jge L3_END
	mov rdi, fmt
	mov rsi, [array+rbx*8]
	mov rax, 0
	call printf
	inc rbx
	jmp L3
L3_END:
	pop rbp
	mov rax, 60
	syscall
	
	ret 


