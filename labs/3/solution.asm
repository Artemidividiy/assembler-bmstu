section .data ;Секция инициализированных данных
 
    InputAMsg db "Enter A number: "
    lenInputA equ $-InputAMsg
    InputBMsg db "Enter B number: "
    lenInputB equ $-InputBMsg
    InputCMsg db "Enter C number: "
    lenInputC equ $-InputCMsg
    razd db 0xa
    
    ResMsg db "Calculation result: "
    lenRes equ $-ResMsg
    
section .bss ;Секция неинициализированных данных
    A resw 1
    B resw 1
    C resw 1
    F resw 1
    InBuf resb 6
    lenIn equ $-InBuf
    OutBuf resb 4
    lenOut equ $-OutBuf
    
section .text ;Секция кода 
 
    global  _start
_start:
    ; Вывод сообщения об вводе числа A
    mov     rax, 1    
    mov     rdi, 1          
    mov     rsi, InputAMsg    
    mov     rdx, lenInputA   
    syscall             
        
    ; Считываем введенную переменную А
         
    mov     rax, 0         
    mov     rdi, 0         
    mov     esi, InBuf      
    mov     rdx, lenIn      
    syscall
    call StrToInt64
    cmp EBX, 0
    jne StrToInt64.Error
    mov [A], ax 	;Записали A
        
    ; Вывод сообщения об вводе числа B
    mov     rax, 1    
    mov     rdi, 1          
    mov     rsi, InputBMsg    
    mov     rdx, lenInputB   
    syscall 
        
    ; Считываем введенную переменную B
        
    mov     rax, 0         
    mov     rdi, 0         
    mov     esi, InBuf      
    mov     rdx, lenIn      
    syscall
    call StrToInt64
    cmp EBX, 0
    jne StrToInt64.Error
    mov [B], ax 	;Записали B
        
    ; Вывод сообщения об вводе числа C
    mov     rax, 1    
    mov     rdi, 1          
    mov     rdx, lenInputC   
    mov     rsi, InputCMsg    
    syscall
        
    ; Считываем введенную переменную C
        
    mov     rax, 0         
    mov     rdi, 0         
    mov     rsi, InBuf      
    mov     rdx, lenIn      
    syscall
    mov rsi, InBuf
    call StrToInt64
    cmp EBX, 0
    jne StrToInt64.Error
    mov [C], ax 	;Записали C
        
    ; Ставим Enter после ввода всех переменных
        
    mov     rax, 1         
    mov     rdi, 1         
    mov     rsi, razd      
    mov     rdx, 1      
    syscall
        
    ; Блок вычислений
    mov ax, [A] 		
    mov cx, [B] 	    
    cmp cx, ax
    jl more
    mov cx, [C]
    cmp cx, ax
    jl more
    imul cx,cx 
    imul ax, cx
    mov cx, [B] 	
    imul cx, 2 
    sub ax, cx 
    mov [F], ax	
    jmp correct

more:
    mov cx, [C]
	idiv cx
    push ax
    mov ax, [A]
    mov cx, [B]
    idiv cx
    mov dx, ax
    pop ax
    add dx, ax
	mov [F], dx 	

	jmp correct

correct:
    ; Блок вывода сообщения о результате
        
    mov     rax, 1    
    mov     rdi, 1          
    mov     rsi, ResMsg    
    mov     rdx, lenRes   
    syscall
 
    ; Блок вывода самого результата
        
    mov esi, OutBuf
    mov ax, [F]
    cwde
    call IntToStr64
    mov rax, 1
        mov rdi, 1
        mov rsi, OutBuf
        mov rdx, lenOut
    syscall
        
    ; Ставим Enter после вывода результата (для красоты)
        
    mov     rax, 1         
    mov     rdi, 1         
    mov     rsi, razd      
    mov     rdx, 1      
    syscall
    jmp exit
        
exit:
    ; Завершение работы программы
        
    mov     rax, 60        
    xor     rdi, rdi          
    syscall
        
%include "../lib64.asm" 
