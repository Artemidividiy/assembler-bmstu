   section .data              
ExitMsg db "Press Enter to Exit",10  
A dw -30 
B dw 21 
lenExit equ $-ExitMsg
   section .bss              
   X resd 1
InBuf   resb    10            
lenIn   equ     $-InBuf 
        
section .text        
   global  _start
_start:
      mov EAX, [A]
      add EAX, 5
      sub EAX, [B]
      mov [X], EAX
        ; write
        mov     rax, 1        
        mov     rdi, 1       
        mov     rsi, [X]
        mov     rdx, lenExit    
         jne IntToStr64  
        syscall                  
        ; read
        mov     rax, 0        
        mov     rdi, 0        
        mov     rsi, InBuf       
        mov     rdx, lenIn      
        syscall                  
        ; exit
        mov     rax, 60       
        xor     rdi, rdi          
        syscall

%include "../lib64.asm"