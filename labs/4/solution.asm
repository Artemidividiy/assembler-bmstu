section .data
welcome:        db      "Input the size of the array; Input q to quit"
w_len:          equ     $ - welcome
in_msg:         db      0xa, "Enter N: "
im_len:         equ     $ - in_msg
num_msg:        db      "Enter the numbers", 10
nm_len:         equ     $ - num_msg
out_msg:        db      "Sorted array: "
om_len:         equ     $ - out_msg

section .bss
n_str:          resb    4
num_str:        resb    4
num_arr:        resd    64

section .text
        global _start
print:
        PUSH    rbx
        PUSH    rax
        mov     rax,4
        mov     rbx,1
        int     0x80
        POP     rax
        POP     rbx
        ret

scan:
        PUSH    rbx
        PUSH    rax
        mov     rax,3
        mov     rbx,0
        int     0x80
        POP     rax
        POP     rbx
        ret

xTen:
        PUSH    rbx
        mov     rbx,rax
        shl     rax,2
        add     rax,rbx
        shl     rax,1
        POP     rbx
        ret

byTen:
        PUSH    rdx
        PUSH    rcx
        mov     rdx,0
        mov     rcx,10
        div     rcx
        mov     rbx,rdx
        POP     rcx
        POP     rdx
        ret

toInt:
        PUSH    rbx
        mov     rax,0
        mov     rbx,0
    .loopStr:
        call    xTen
        PUSH    rdx
        mov     rdx,0
        mov     dl,byte[rcx+rbx]
        sub     dl,0x30
        add     rax,rdx
        POP     rdx
        inc     rbx
        cmp     byte[rcx+rbx],0xa
        jle     .return
        cmp     rbx,rdx
        jge     .return
        jmp     .loopStr
    .return:
        POP     rbx
        ret

toStr:
        PUSH    rbx
        PUSH    rax
        mov     rbx,0
        PUSH    0
    .loopDiv:
        call    byTen
        add     rbx,0x30
        PUSH    rbx
        cmp     rax,0
        jg      .loopDiv
        mov     rbx,0
    .loopStr:
        POP     rax
        cmp     rax,0
        je      .loopFill
        cmp     rbx,rdx
        je      .loopStr
        mov     byte[rcx+rbx],al
        inc     rbx
        jmp     .loopStr
    .loopFill:
        cmp     rbx,rdx
        je      .return
        mov     byte[rcx+rbx],0
        inc     rbx
        jmp     .loopFill
    .return:
        POP     rax
        POP     rbx
        ret

sortN:  ;ebx=address of the array of numbers, ecx=array size(>0)
        ;Array gets sorted descending order.
        ;Equivalent C program (a = array; n = length):
        ; i=n;
        ; do {
        ;     i--;
        ;     j=i;
        ;     do {
        ;         j--;
        ;         if (a[i]>a[j])
        ;             swap(a[i],s[j]);
        ;     } while(j>0);
        ; } while (i>1);
        PUSH    rax
        PUSH    rsi ;esi and edi are used here like eax, ebx etc.; Nothing special!
        PUSH    rdi
        mov     rdi,rcx
        shl     rdi,2
    .loopN:
        sub     rdi,4
        mov     rax,qword[rbx+rdi]
        mov     rsi,rdi
    .loopIn:
        sub     rsi,4
        cmp     rax,qword[rbx+rsi]
        jg      .swap
        jmp     .continue
    .swap:
        PUSH    qword[rbx+rsi]
        PUSH    qword[rbx+rdi]
        POP     qword[rbx+rsi]
        POP     qword[rbx+rdi]
        mov     rax,qword[rbx+rdi]
    .continue:
        cmp     rsi,0
        jg      .loopIn
        cmp     rdi,4
        jg      .loopN

        POP     rdi
        POP     rsi
        POP     rax
        ret

_start:
        mov     rcx,welcome
        mov     rdx,w_len
        call    print
    .main_loop:
        mov     rcx,in_msg ;Ask the user for N
        mov     rdx,im_len
        call    print

        mov     rcx,n_str ;Input N
        mov     rdx,4
        call    scan

        cmp     byte[n_str],0x71 ;If 'q', quit
        je      .quit

        call    toInt ;get the integer N, PUSH it, and move it to ebx
        PUSH    rax
        mov     rbx,rax

        mov     rcx,num_msg ;Ask the user to input all numbers
        mov     rdx,nm_len
        call    print

    .loopN_1: ;Input the numbers
        dec     rbx
        ;get the number and store it in [num_arr+ebx*4]
        mov     rcx,num_str
        mov     rdx,4
        call    scan
        call    toInt
        mov     rdx,rbx
        shl     rdx,2 ;edx = edx*4
        mov     qword[num_arr+rdx], rax
        cmp     rbx,0
        jne     .loopN_1 ;Note: The numbers will be stored in reverse order of input

        mov     rbx,num_arr
        POP     rcx ;POP N to ecx
        call    sortN
        mov     rbx,rcx

        mov     rcx,out_msg
        mov     rdx,om_len
        call    print

    .loopN_2: ;Output the numbers
        dec     rbx
        mov     rdx,rbx
        shl     rdx,2
        mov     rax, qword[num_arr+rdx]
        mov     rcx,num_str
        mov     rdx,4
        call    toStr
        mov     byte[num_str+3],0x20 ;ascii code for space
        call    print
        cmp     rbx,0
        jne     .loopN_2 ;Note: The numbers will be printed in reverse order too

        jmp     .main_loop

    .quit:
        mov     rbx,0
        mov     rax,1
        int     0x80
