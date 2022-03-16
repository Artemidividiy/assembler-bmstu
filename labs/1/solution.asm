   section .data              
ExitMsg db "Press Enter to Exit",10  
lenExit equ $-ExitMsg
   section .bss              
InBuf   resb    10            
lenIn   equ     $-InBuf 
        section .text        
        global  _start
_start:
        ; write
        mov     rax, 1        
        mov     rdi, 1       
        mov     rsi, ExitMsg  
        mov     rdx, lenExit    
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