section .data ;Секция инициализированных данных
 
    InputRMsg db "Enter R number: "
    lenInputR equ $-InputRMsg
    InputAMsg db "Enter A number: "
    lenInputA equ $-InputAMsg
    InputQMsg db "Enter Q number: "
    lenInputQ equ $-InputQMsg
    razd db 0xa
    
    ResMsg db "Calculation result: "
    lenRes equ $-ResMsg
    
section .bss ;Секция неинициализированных данных
    A resw 1
    R resw 1
    Q resw 1
    F resw 1
    InBuf resb 6
    lenIn equ $-InBuf
    OutBuf resb 4
    lenOut equ $-OutBuf
    
section .text ;Секция кода 
 
    global  _start
_start:
        ; Вывод сообщения об вводе числа R
        mov     rax, 1    
        mov     rdi, 1          
        mov     rsi, InputRMsg    
        mov     rdx, lenInputR   
        syscall             
        
         ; Считываем введенную переменную R
         
        mov     rax, 0         
        mov     rdi, 0         
        mov     esi, InBuf      
        mov     rdx, lenIn      
        syscall
        call StrToInt64
        cmp EBX, 0
        jne StrToInt64.Error
        mov [R], ax ; Записали R
        
        ; Вывод сообщения об вводе числа A
        mov     rax, 1    
        mov     rdi, 1          
        mov     rsi, InputAMsg    
        mov     rdx, lenInputA   
        syscall 
        
        ; Считываем введенную переменную A
        
        mov     rax, 0         
        mov     rdi, 0         
        mov     esi, InBuf      
        mov     rdx, lenIn      
        syscall
        call StrToInt64
        cmp EBX, 0
        jne StrToInt64.Error
        mov [A], ax ; Записали A
        
        ; Вывод сообщения об вводе числа Q
        mov     rax, 1    
        mov     rdi, 1          
        mov     rsi, InputQMsg    
        mov     rdx, lenInputQ   
        syscall
        
        ; Считываем введенную переменную Q
        
        mov     rax, 0         
        mov     rdi, 0         
        mov     esi, InBuf      
        mov     rdx, lenIn      
        syscall
        call StrToInt64
        cmp EBX, 0
        jne StrToInt64.Error
        mov [Q], ax ; Записали Q
        
        ; Ставим Enter после ввода всех переменных (для красоты)
        
        mov     rax, 1         
        mov     rdi, 1         
        mov     rsi, razd      
        mov     rdx, 1      
        syscall
        
        ; Блок вычислений
 
        mov ax, [R] ;
        mov dx, [A] ;
        mov cx, [Q] ;
      
        imul ax, ax ;
        mov [F], ax ;
        imul cx, dx ;
        imul cx, -2 ;
        add [F], cx
        mov ax, [A]
        mov dx, [A]
        mov cx, [Q]
        imul ax, ax
        imul ax, dx
        cwd
        idiv cx
        add [F], ax
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
        ; Ставим Enter после вывода результата (для красоты
        mov     rax, 1         
        mov     rdi, 1         
        mov     rsi, razd      
        mov     rdx, 1      
        syscall
        ; Завершение работы программы
        mov     rax, 60        
        xor     rdi, rdi          
        syscall
        
%include "../lib64.asm" ;Библиотека Ивановой Г.С. 
