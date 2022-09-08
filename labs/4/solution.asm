section .data ;Секция инициализированных данных
    EnterMsg db 0xa
    RowElement db '  ['
    Num db 31h
    DoubleDot db '] - '
    LenRowElement equ $-RowElement
    InitialMatrix db 10, 'Initial Matrix:', 10
    LenInitialMatrix equ $-InitialMatrix
    ResultMatrix db 10, 'Result Matrix: ', 10
    LenResultMatrix equ $-ResultMatrix
    DelNum db "Input number for delete: "
    lenDel equ $-DelNum
    RowInput db 'Enter '
    RowNum db 31h
    RowMsg db ' row of your Matrix', 10
    LenRowInput equ $-RowInput
    TabMsg db '  '
    rows dw 5
    indx dw 0                   

section .bss ;Секция неинициализированных данных
    Matrix times 30 resw 1
    NewMatrix times 24 resw 1
    i resb 1
    N resw 1
    InBuf resb 10
    LenBuf equ $-InBuf
    OutBuf resb 4
    LenOut equ $-OutBuf

section .text ;Секция кода 

    global  _start
_start: 

    ; Ввод матрицы
    mov rcx, 6
    mov rbx, 0
    input_row:
        push rcx
        mov rax, 1
        mov rdi, 1
        mov rsi, RowInput
        mov rdx, LenRowInput
        syscall
        jmp ChngNum

        continue:
            mov rcx, 5
            input_column:
                push rcx
                push rbx        
                mov rax, 1
                mov rdi, 1
                mov rsi, RowElement
                mov rdx, LenRowElement
                syscall
                mov rax, 0
                mov rdi, 0
                mov rsi, InBuf
                mov rdx, LenBuf
                syscall
                call StrToInt64
                pop rbx
                mov [ebx*2 + Matrix], ax
                inc ebx
                pop rcx
                inc byte[Num]
                loop input_column
            pop rcx
            loop input_row
            jmp metka_N      

    ChngNum:
        inc byte[RowNum]
        mov byte[Num], 31h
        jmp continue

    metka_N:
            ; Вывод сообщения об вводе номера столбца для удаления
            mov     rax, 1    
            mov     rdi, 1          
            mov     rsi, DelNum   
            mov     rdx, lenDel
            syscall             
            ;ввод номера столбца для удаления
            mov     rax, 0         
            mov     rdi, 0         
            mov     esi, InBuf      
            mov     rdx, LenBuf     
            syscall
            call StrToInt64
            cmp EBX, 0
            jne StrToInt64.Error
            sub ax, 1
            mov [N], ax ; Записали N

    ; Вывод матрицы
    print:
        mov rax, 1
        mov rdi, 1
        mov rsi, InitialMatrix
        mov rdx, LenInitialMatrix
        syscall
        mov rbx, 0
        mov rcx, 6

        row_cycle:
            push rcx
            mov rax, 1
            mov rdi, 1
            mov rsi, TabMsg
            mov rdx, 2
            syscall
            mov rcx, 5

            column_cycle:
                push rcx
                push rbx
                mov ax, [ebx*2 + Matrix]                
                cwde
                mov rsi, OutBuf
                call IntToStr64
                mov rdi, 1
                mov rdx, rax
                mov rax, 1
                syscall
                pop rbx
                inc ebx
                pop rcx
                loop column_cycle        
            mov rax, 1
            mov rdi, 1
            mov rsi, EnterMsg
            mov rdx, 1
            syscall
            pop rcx 
            loop row_cycle   

        ; Блок вычислений
        edit:  
            mov rbx, 0
            mov rsi, 0
            mov rdx, 0
            mov rdi, 0 
            mov rcx, 5

            edit_cycle1:
                push rcx              
                mov ax, [N]
                cmp bx, ax
                je skip
                mov rcx, 6

                edit_cycle2:                
                    push rcx
                    mov ax, [esi + ebx*2 + Matrix]
                    mov [edx + edi*2 + NewMatrix], ax
                    add rsi, 10
                    add rdx, 8
                    pop rcx
                    loop edit_cycle2
                mov rsi, 0
                mov rdx, 0
                add rdi, 1
                add rbx, 1
                pop rcx 
                loop edit_cycle1
                jmp print_result  
                skip: 
                    mov rsi, 0
                    mov rdx, 0
                    add rbx, 1
                    pop rcx 
                    loop edit_cycle1

    ;вывод результирующей матрицы
    print_result:        
            mov rax, 1
            mov rdi, 1
            mov rsi, ResultMatrix
            mov rdx, LenResultMatrix
            syscall   
            mov rbx, 0
            mov rcx, 6
            res_row_cycle:
                push rcx
                mov rax, 1
                mov rdi, 1
                mov rsi, TabMsg
                mov rdx, 2
                syscall
                mov rcx, 4
                res_column_cycle:                
                    push rcx
                    push rbx
                    mov ax, [ebx*2 + NewMatrix]
                    cwde
                    mov rsi, OutBuf
                    call IntToStr64
                    mov rdi, 1
                    mov rdx, rax
                    mov rax, 1
                    syscall
                    pop rbx
                    inc ebx
                    pop rcx
                    loop res_column_cycle
                mov rax, 1
                mov rdi, 1
                mov rsi, EnterMsg
                mov rdx, 1
                syscall
                pop rcx 
                loop res_row_cycle

        ; Завершение работы программы
            mov     rax, 60        
            xor     rdi, rdi          
            syscall
%include "../lib64.asm"

