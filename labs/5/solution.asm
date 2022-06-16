section .bss
  buffer resb 256

section .text

global _Z7processPcPii

extern _Z12log_reversedii

; rdi: str[]
; rsi: to_reverse[]
; edx: n_to_reverse
_Z7processPcPii:
  push rbp
  mov rbp, rsp
  lea rsp, [rsp - 256]
  push rdi
  push rsi
  push rdx

  push rax
  push rbx
  push rcx
  push r8
  push r10
  push r11

; find length of string
  mov rcx, 256
  mov al, 0
  push rdi
  repne scasb
  mov r11, rdi
  pop rdi
  sub r11, rdi

; rbx stores beginning of the word
  mov al, ' '
  mov rcx, r11
  mov rbx, rdi
  mov r10, 0
  word_loop:
    repne scasb
    mov r8, rdi
    sub r8, rbx
    dec r8d

    push rdi
    push rsi
    push rdx
    push r10
    push r8
    mov rdi, rbx
    call check_and_reverse
    pop r8
    pop r10
    pop rdx
    pop rsi
    pop rdi

    mov rbx, rdi
    inc r10
    cmp rcx, 0
  jne word_loop

  pop r11
  pop r10
  pop r8
  pop rcx
  pop rbx
  pop rax

  mov rsp, rbp
  pop rbp
  ret

; rdi: word[]
; rsi: to_reverse[]
; edx: n_to_reverse
; r10d: word_num
; r8d: word_len
check_and_reverse:
  push rax
  push rcx
  push rsi

; iterate over to_reverse[]
  mov ecx, edx
  mov eax, r10d

  cld
  push rdi
  mov rdi, rsi
  repne scasd
  je call_reverse
  
  pop rdi
  jmp check_and_reverse_return

  call_reverse:
  mov edi, r10d
  mov esi, r8d
  call _Z12log_reversedii
  pop rdi
  call reverse

  check_and_reverse_return:
  pop rsi
  pop rcx
  pop rax
  ret

; rdi: word[]
; r8d: word_len
reverse:
  push rax
  push rcx
  push rsi

; convert size to qword
  mov eax, r8d
  cdq
  mov r8, rax

; reverse into buffer
  push rdi

  ; set rsi to end of word
  mov rsi, rdi
  add rsi, r8
  dec rsi
  std

  ; set rdi to buffer
  mov rdi, buffer

  ; iterate
  mov rcx, r8
  reverse_buffer_loop:
    lodsb
    mov [rdi], al
    inc rdi
  loop reverse_buffer_loop

  pop rdi
; copy from buffer
  cld
  mov rsi, buffer
  mov rcx, r8
  rep movsb

  pop rsi
  pop rcx
  pop rax
  ret