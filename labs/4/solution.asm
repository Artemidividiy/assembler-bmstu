section .data
    global vec
    vec db 54, 
    	db 51,
    	db 57
    cont equ $-vec
    var1 db 0
section .text
    global _start
_start:
    
    mov r8d, cont
    dec r8d
    
    laco:
    mov ebx, r8d
    mov ecx, vec

    comp_comutar:
    movzx eax, byte [rcx]        
movzx edx, byte [rcx+1]      
cmp eax, edx                  
jl n_comutar
mov [rcx], dl
mov [rcx+1], al

n_comutar:
    inc ecx
    dec ebx
    jnz comp_comutar
    dec r8d
    jnz laco
    
    mov ebx, cont
    mov ebx, vec
loop_print:
    mov eax, 1
    mov edi, 1
    mov esi, ebx
    mov edx, 1
    syscall
    inc ebx
    cmp ebx, vec + cont
    jb  loop_print

    mov eax, 60
    xor edi, edi
    syscall

%include "../lib64.asm"