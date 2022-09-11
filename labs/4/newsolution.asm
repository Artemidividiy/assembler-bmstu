section .data
  array dd 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
  array_len equ 10

section .bss
  OutBuf resb 4
  lenOut equ $-OutBuf

section .text

global _start

_start:
  mov rcx, array_len
  dec rcx
  mov rsi, array
  mov r8, 1

  outer_loop:
    push rcx
    mov rcx, array_len
    
    sub rcx, r8

    inc r8

    mov rbx, array

    inner_loop:
      mov eax, [rbx]
      cmp eax, [rbx + 4]
      jle skip_swap

      ; swap
      mov r9d, [rbx]
      mov r10d, [rbx + 4]
      mov [rbx], r10d
      mov [rbx + 4], r9d

      add rbx, 4
    skip_swap:
    loop inner_loop

    pop rcx
  loop outer_loop

;output: 
;  mov rcx, array_len
 ; dec rcx
  ;loop_output:
   ; mov esi,4
    ;mov ax, [rbx]
    ;cwde 
    ;call IntToStr64
    ;mov rax, 1
    ;mov rdi, 1
    ;mov rsi, [rbx]
    ;mov rdx, 4
    ;syscall
  ;loop loop_output 	

exit:
  mov rax, 0x3c
  mov rdi, 0
  syscall

%include "../lib64.asm"