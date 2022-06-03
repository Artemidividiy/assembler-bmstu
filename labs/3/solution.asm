section .data ;Секция инициализированных данных
 
    InputAMsg db "Enter A number: "
    lenInputA equ $-InputAMsg
    InputBMsg db "Enter B number: "
    lenInputB equ $-InputBMsg
    InputQMsg db "Enter Q number: "
    lenInputQ equ $-InputQMsg
    razd db 0xa
    
    ResMsg db "Calculation result: "
    lenRes equ $-ResMsg
    
section .bss ;Секция неинициализированных данных
    A resw 1
    B resw 1
    Q resw 1
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
        
    ; Вывод сообщения об вводе числа Q
    mov     rax, 1    
    mov     rdi, 1          
    mov     rdx, lenInputQ   
    mov     rsi, InputQMsg    
    syscall
        
    ; Считываем введенную переменную Q
        
    mov     rax, 0         
    mov     rdi, 0         
    mov     rsi, InBuf      
    mov     rdx, lenIn      
    syscall
    mov rsi, InBuf
    call StrToInt64
    cmp EBX, 0
    jne StrToInt64.Error
    mov [Q], ax 	;Записали Q
        
    ; Ставим Enter после ввода всех переменных
        
    mov     rax, 1         
    mov     rdi, 1         
    mov     rsi, razd      
    mov     rdx, 1      
    syscall
        
    ; Блок вычислений
    mov ax, [A] 	;ax = a
    sub ax, [B] 	;ax = a - b
    mov cx, ax 	;cx = ax
    imul ax, ax 	;ax = ax*ax
    imul ax, cx 	;ax = ax*cx
        
    mov cx, 0	;cx = 0
    cmp cx, ax
    jl more
        
    mov bx, -2	;bx = -2
    cwd
    idiv bx	;ax = ax/bx
    mov [F], ax	;f = ax
    jmp correct

more:
	mov ax, [A] 	;ax = a
	mov cx, ax 	;cx = ax
	imul ax, ax 	;ax = ax*ax
	imul ax, cx 	;ax = ax*cx
	
	imul cx, [Q] 	;cx = cx*q
	imul cx, 2 	;cx = cx*2
	
	sub ax, cx 	;ax = ax - cx
	mov cx, [B] 	;cx = b
	imul cx, cx 	;cx = b*b
	
	add ax, cx 	;ax = ax + cx
	mov [F], ax 	;f = ax

	jmp correct

correct:
    ; Блок вывода сообщения о результате
        
    mov     rax, 1    
    mov     rdi, 1          
    mov     rsi, ResMsg    
    mov     rdx, lenRes   
    syscall
 
    ; Блок вывода самого результата
        
    mov edi, OutBuf
    mov ax, [F]
    cwde
    call IntToStr64
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, OutBuf
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
