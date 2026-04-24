section .data
    star    db "-"
    space   db " "
    newline db 10
    radius  dq 10        ; The radius
    r_sq    dq 100       ; radius squared (10*10)

section .text
    global _start

_start:
    ; We loop y from -radius to +radius
    mov r12, -10         ; r12 = y

y_loop:
    ; We loop x from -20 to +20 (doubled for aspect ratio)
    mov r13, -20         ; r13 = x

x_loop:
    ; --- Math: (x/2)^2 + y^2 ---
    ; 1. Calculate x^2
    mov rax, r13
    imul rax, rax        ; rax = x^2
    
    ; 2. Calculate y^2
    mov rbx, r12
    imul rbx, rbx        ; rbx = y^2

    ; 3. Combine and compare
    ; Formula for terminal: (x^2 / 4) + y^2 = radius^2
    ; To avoid floats, we use: x^2 + 4*(y^2) = 4*(radius^2)
    lea rbx, [rbx * 4]   ; rbx = 4 * y^2
    add rax, rbx         ; rax = x^2 + 4y^2

    mov rdx, 400         ; 4 * radius^2 (4 * 100)

    ; Check distance for the "ring" thickness
    sub rax, rdx
    jns positive
    neg rax              ; Get absolute value

positive:
    cmp rax, 30          ; Thickness of the line (30 is a good "sweet spot")
    jle print_s
    call print_sp
    jmp next_x

print_s:
    call print_st

next_x:
    inc r13
    cmp r13, 20
    jle x_loop

    call print_nl
    inc r12
    cmp r12, 10
    jle y_loop

exit:
    mov rax, 60          ; sys_exit
    xor rdi, rdi
    syscall

; -------- Functions (Safe Registers) --------

print_st:
    push r11             ; syscall destroys r11
    mov rax, 1           ; sys_write
    mov rdi, 1           ; stdout
    mov rsi, star
    mov rdx, 1
    syscall
    pop r11
    ret

print_sp:
    push r11
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall
    pop r11
    ret

print_nl:
    push r11
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    pop r11
    ret
