section .data
    InputBMsg db "Enter B number: "
    lenInputB equ $-InputBMsg
    InputAMsg db "Enter A number: "
    lenInputA equ $-InputAMsg
    InputKMsg db "Enter K number: "
    lenInputK equ $-InputKMsg
    razd db 0xa
    
    ResMsg db "Calculation result: "
    lenRes equ $-ResMsg

section .bss
    A resw 1
    B resw 1
    K resw 1
    F resw 1
    InBuf resb 6
    lenIn equ $-InBuf
    OutBuf resb 4
    lenOut equ $-OutBuf

section .text
    global _start

_start:
    ; Выводим сообщение о вводе числа
    mov     rax, 1    
    mov     rdi, 1          
    mov     rsi, InputAMsg    
    mov     rdx, lenInputA   
    syscall   

    ; Вводим число
    mov     rax, 0         
    mov     rdi, 0         
    mov     esi, InBuf      
    mov     rdx, lenIn      
    syscall
    call StrToInt64
    cmp EBX, 0
    jne StrToInt64.Error
    mov [A], ax ; Записали А
    
    ; Выводим сообщение о вводе числа
    mov     rax, 1    
    mov     rdi, 1          
    mov     rsi, InputBMsg    
    mov     rdx, lenInputB   
    syscall

    ; Вводим число
    mov     rax, 0         
    mov     rdi, 0         
    mov     esi, InBuf      
    mov     rdx, lenIn      
    syscall
    call StrToInt64
    cmp EBX, 0
    jne StrToInt64.Error
    mov [B], ax ; Записали B

    ; Выводим сообщение о вводе числа
    mov     rax, 1    
    mov     rdi, 1          
    mov     rsi, InputKMsg    
    mov     rdx, lenInputK   
    syscall

    ; Вводим число
    mov     rax, 0         
    mov     rdi, 0         
    mov     esi, InBuf      
    mov     rdx, lenIn      
    syscall
    call StrToInt64
    cmp EBX, 0
    jne StrToInt64.Error
    mov [K], ax ; Записали K

    ;считаем
    mov ax, [A]
    mov cx, [B]
    mov dx, [K]

    imul dx, dx ;k^2
    imul ax, cx ; a*b
    mov [F], ax
    imul cx, cx ; b^2
    imul cx, cx; b^2*b=b^3
    mov ax, cx; переносим b^3 для деления
    add dx, 2; k^2 + 2
    div dx; b^3/(k^2+2)
    sub [F], dx; последнее действие

    ;ввыодим результат
    mov     rax, 1    
    mov     rdi, 1          
    mov     rsi, ResMsg    
    mov     rdx, lenRes   
    syscall

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

    ; Завершение работы программы
    mov     rax, 60        
    xor     rdi, rdi          
    syscall
        
%include "../lib64.asm" ;Библиотека Ивановой Г.С. 

    

