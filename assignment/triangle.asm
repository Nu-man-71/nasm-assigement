; triangle.asm - Draw a hollow pyramid triangle
section .data
    star     db '-'
    space    db ' '
    newline  db 10
    
    height   equ 10          ; Total rows
    width    equ 19          ; Total columns (height * 2 - 1)

section .text
    global _start

_start:
    mov r12, 0              ; Current row (y) loop

y_loop:
    cmp r12, height
    jge done

    mov r13, 0              ; Current column (x) loop

x_loop:
    cmp r13, width
    jge next_row

    ; --- Logic for Pyramid Outline ---
    
    ; 1. Check if it's the bottom row
    mov rax, height
    dec rax
    cmp r12, rax
    je .check_bottom_range

    ; 2. Check if it's the Left Slant edge
    ; Formula: x == (height - 1) - y
    mov rax, height
    dec rax
    sub rax, r12
    cmp r13, rax
    je .print_star

    ; 3. Check if it's the Right Slant edge
    ; Formula: x == (height - 1) + y
    mov rax, height
    dec rax
    add rax, r12
    cmp r13, rax
    je .print_star

    jmp .print_space

.check_bottom_range:
    ; For the bottom row, only print stars within the triangle's base
    ; Base starts at 0 and ends at width-1
    jmp .print_star

.print_star:
    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, 1
    syscall
    jmp .continue

.print_space:
    ; Only print space if we haven't reached the right edge of the triangle
    mov rax, height
    dec rax
    add rax, r12
    cmp r13, rax
    ja .continue            ; Don't print spaces past the right edge

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
    mov rax, 60
    xor rdi, rdi
    syscall
