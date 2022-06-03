section .data        ; секция проинициализированных данных      
ExitMsg db "Press Enter to Exit",10  ; создаем переменную, хранящую в себе сообщение
A dw -30 ; создадим переменную a и дадим ей значение -30
B dw 20 ; создадим переменную b и дадим ей значение 21
lenExit equ $-ExitMsg    ; создаем переменную, хранящую длину сообщения выше
   
  section .bss
X resd 1 ; создадим переменную x и зарезервируем для нее 1 байт              
InBuf   resb    10              ; буфер для вводимой строки    
lenIn   equ     $-InBuf 
        
  section .text            ; сегмент кода       
global  _start
  _start:
        ; добавим код вычисления значения исходного выражения
        mov eax, [A] ; Переносим в регистр eax значение переменной A
        add eax, 5 ; складываем eax и 5, результат заносим в eax
        sub eax, [B] ; вычитаем из значения в eax число B и заносим в eax
        mov [X], eax ; передаем значение из eax в переменную X 
        ; write
        mov     rax, 1             ; системная функция записи     
        mov     rdi, 1              ;  stdout=1
        mov     rsi, ExitMsg  ; адрес выводимой строки
        mov     rdx, lenExit   ; длина выводимой строки
        syscall                  
        ; read
        mov     rax, 0             ; системная функция чтения
        mov     rdi, 0              ; stdin=0
        mov     rsi, InBuf       ; адрес буфера ввода
        mov     rdx, lenIn      ; размер буфера
        syscall                  
        ; exit
        mov     rax, 60          ; системная функция 60 - завершение процесса
        xor     rdi, rdi             ; код возврата 0
        syscall   
