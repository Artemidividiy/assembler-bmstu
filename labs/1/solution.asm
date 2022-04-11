  section .data        ; секция проинициализированных данных      
ExitMsg db "Press Enter to Exit",10  ; создаем переменную, хранящую в себе сообщение
A dw -30 ; создадим переменную a и дадим ей значение -30
B dw 20 ; создадим переменную b и дадим ей значение 21
lenExit equ $-ExitMsg    ; создаем переменную, хранящую длину сообщения выше

val1 db 255
chart dw 256
lue3 dw -128
v5 db 10h
      db 100101B
beta db 23, 23h, 0ch
sdk db "Hello",10
min dw -32767
ar dd 12345678h
valar times 5 db 8

  section .bss
X resd 1 ; создадим переменную x и зарезервируем для нее 1 байт              
InBuf   resb    10              ; буфер для вводимой строки    
lenIn   equ     $-InBuf 
alu resw 10
fl resb 5
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