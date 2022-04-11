   section .data        ; секция проинициализированных данных      
ExitMsg db "Press Enter to Exit",10  ; создаем переменную, хранящую в себе сообщение
lenExit equ $-ExitMsg    ; создаем переменную, хранящую длину сообщения выше
   section .bss              
InBuf   resb    10              ; буфер для вводимой строки    
lenIn   equ     $-InBuf 
        section .text            ; сегмент кода       
        global  _start
_start:
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
        xor     rdi, rdi            ; код возврата 0
        syscall                     