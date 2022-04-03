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

IntToStr64: 
         push   rdi
         push   rbx
         push   rdx
         push   rcx
		 push   rsi
		 mov    byte[rsi],0 
         cmp    eax,0
         jge    .l1
         neg    eax
         mov    byte[rsi],'-'
.l1      mov    byte[rsi+6],10
         mov    rdi,5
         mov    bx,10
.again:  cwd           
         div    bx    
         add    dl,30h 
         mov    [rsi+rdi],dl 
         dec    rdi      
                       
         cmp    ax, 0  
         jne    .again
         mov    rcx, 6
         sub    rcx, rdi
		 mov    rax,rcx
		 inc    rax    
         inc    rsi    
		 push   rsi
         lea    rsi,[rsi+rdi]
		 pop    rdi
         rep movsb
         pop    rsi  
         pop    rcx
         pop    rdx
         pop    rbx
         pop    rdi
         ret                  