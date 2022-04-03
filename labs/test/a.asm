section .data
    msg db 'something', 0xa, 0xd
    len equ $ - msg
section .text
    global _start

_start:
    mov eax, 4 ; 4 - номер системного вызова sys_write
    mov ebx, 1; 1 - файловый дискриптор stdout
    mov ecx, msg ; закидываем строку 
    mov edx, len; закидываем длину нашей строки
    int 0x80 ; если этого не сделать, ничего не выведется
    mov eax, 1; вызываем системный вызов sys_exit
    mov ebx, 0; код ошибки
    int 0x80 ; 
