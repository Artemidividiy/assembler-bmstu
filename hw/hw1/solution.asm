%include '../lib64.asm'

section .data
  input_len equ (n_words * (word_len + 1) - 1)
  prompt db 'Submit a string: '
  prompt_len equ $ - prompt
  output_prompt db 'Results:', 0x0a
  output_prompt_len equ $ - output_prompt
  vowels db 'aeiouy'
  vowels_len equ $ - vowels
  n_words equ 8
  word_len equ 5
  buffer_len equ 32

section .bss
  input resb input_len
  results resd n_words
  buffer resb buffer_len

section .text

global _start

_start:
  ; write prompt
  mov rax, 1
  mov rdi, 1
  mov rsi, prompt
  mov rdx, prompt_len
  syscall

  ; read string
  mov rax, 0
  mov rdi, 0
  mov rsi, input
  mov rdx, input_len
  syscall

  ; set direction forward
  cld

  ; initialize results array
  mov rcx, n_words
  mov eax, 0
  mov rdi, results
  rep stosd

  ; iterate over words
  mov rcx, n_words
  mov rsi, input
  mov rdi, results
  string_loop:
    push rcx

    ; iterate over characters
    mov rcx, word_len
    word_loop:
      lodsb
      call check_vowel
      cmp rax, 1
      jne skip
      inc dword [rdi]
    skip:
    loop word_loop

    pop rcx
    inc rsi
    add rdi, 4
  loop string_loop

  ; write output message
  mov rax, 1
  mov rdi, 1
  mov rsi, output_prompt
  mov rdx, output_prompt_len
  syscall

  ; iterate over results
  mov rcx, n_words
  mov rsi, results
  results_loop:
    push rcx
    ; convert result into a string
    lodsd

    push rsi

    mov rsi, buffer
    call IntToStr64
    
    ; write result
    cdq
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall
    
    pop rsi
    pop rcx
  loop results_loop

  exit:
    mov rax, 0x3c
    mov rdi, 0
    syscall

; check if character in al is a vowel
check_vowel:
  push rcx
  push rdi

  ; scan vowels
  mov rcx, vowels_len
  mov rdi, vowels
  repne scasb ; find byte = al in (e)cx bytes by es:(e)di adress
  je is_vowel

  ; set false (not a vowel)
  not_vowel:
    mov rax, 0
    jmp return

  ; set true (is a vowel)
  is_vowel:
    mov rax, 1
    jmp return

  ; return
  return:
    pop rdi
    pop rcx
    ret