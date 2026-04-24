; line.asm - Draw a horizontal line of symbols
section .data
    star     db '-'
    newline  db 10
    
    ; Adjust this number to change the length. 
    ; 40 characters is roughly 10cm on many screens.
    length   equ 40          

section .text
    global _start

_start:
    mov r12, 0              ; Loop counter

line_loop:
    cmp r12, length         ; Check if we have printed 'length' stars
    jge done

    ; Print the star symbol
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout (terminal)
    mov rsi, star
    mov rdx, 1
    syscall

    inc r12
    jmp line_loop

done:
    ; Print a newline at the end
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit the program
    mov rax, 60             ; sys_exit
    xor rdi, rdi
    syscall
