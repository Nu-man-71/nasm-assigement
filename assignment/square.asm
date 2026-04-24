; square.asm - Draw a square in the terminal using '*'
section .data
    star     db '-'
    space    db ' '
    newline  db 10

    ; To make it look like a square in the terminal:
    ; The width should be roughly double the height.
    side_h   equ 10          ; Height of the square
    side_w   equ 20          ; Width (Visual adjustment for terminal)

    ; Position on screen
    pos_x    equ 5
    pos_y    equ 2

section .text
    global _start

_start:
    mov r12, 0              ; Row counter (y)

y_loop:
    cmp r12, side_h
    jge done

    mov r13, 0              ; Column counter (x)

x_loop:
    cmp r13, side_w
    jge next_row

    ; --- Logic for Square Borders ---
    
    ; Check if Top Row or Bottom Row
    cmp r12, 0
    je .print_star
    mov rax, side_h
    dec rax
    cmp r12, rax
    je .print_star

    ; Check if Left Column or Right Column
    cmp r13, 0
    je .print_star
    mov rax, side_w
    dec rax
    cmp r13, rax
    je .print_star

    ; If not a border, print a space
    jmp .print_space

.print_star:
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, star
    mov rdx, 1
    syscall
    jmp .continue

.print_space:
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall

.continue:
    inc r13
    jmp x_loop

next_row:
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    inc r12
    jmp y_loop

done:
    mov rax, 60             ; sys_exit
    xor rdi, rdi
    syscall
