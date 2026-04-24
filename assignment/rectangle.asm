; terminal_rect.asm - Draw a rectangle in the terminal using '*'
section .data
    star     db '-'
    space    db ' '
    newline  db 10

    ; Screen dimensions
    width    equ 40
    height   equ 15

    ; Rectangle position and size
    rect_x   equ 5
    rect_y   equ 2
    rect_w   equ 25
    rect_h   equ 8

section .text
    global _start

_start:
    mov r12, 0          ; r12 = current y (row)

y_loop:
    cmp r12, height
    jge done

    mov r13, 0          ; r13 = current x (column)

x_loop:
    cmp r13, width
    jge next_row

    ; --- Logic to decide: Draw Star or Space? ---
    
    ; Check if we are on the Top or Bottom edge
    mov rax, r12
    cmp rax, rect_y
    je .check_x_range   ; If current y == rect_y, check x
    cmp rax, rect_y + rect_h
    je .check_x_range   ; If current y == rect_y + rect_h, check x

    ; Check if we are on the Left or Right edge
    mov rax, r13
    cmp rax, rect_x
    je .check_y_range   ; If current x == rect_x, check y
    cmp rax, rect_x + rect_w
    je .check_y_range   ; If current x == rect_x + rect_w, check y

    jmp .print_space    ; Not an edge? Print a space.

.check_x_range:
    ; Make sure x is between rect_x and rect_x + rect_w
    cmp r13, rect_x
    jb .print_space
    cmp r13, rect_x + rect_w
    ja .print_space
    jmp .print_star

.check_y_range:
    ; Make sure y is between rect_y and rect_y + rect_h
    cmp r12, rect_y
    jb .print_space
    cmp r12, rect_y + rect_h
    ja .print_space
    jmp .print_star

.print_star:
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, star
    mov rdx, 1
    syscall
    jmp .continue

.print_space:
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, space
    mov rdx, 1
    syscall

.continue:
    inc r13
    jmp x_loop

next_row:
    ; Print newline at the end of each row
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    inc r12
    jmp y_loop

done:
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall
