cat > tests/clock/test_kernel.asm << 'EOF'
[bits 16]
[org 0x1000]

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x1000

mov ax, 0x0003
int 0x10

mov si, msg_title
call print_string

.clock_loop:
    mov ah, 0x02
    int 0x1A ; Get system time

    mov si, msg_time
    call print_string
    mov ax, cx
    call print_word
    mov al, ':'
    mov ah, 0x0E
    int 0x10
    mov ax, dx
    call print_word

    mov ah, 0x86
    mov cx, 0x0000
    mov dx, 0xFFFF
    int 0x15 ; delay

    jmp .clock_loop

print_string:
    pusha
.loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp .loop
.done:
    popa
    ret

print_word:
    pusha
    mov cx, 4
.hex_loop:
    rol ax, 4
    mov bx, ax
    and bx, 0x000F
    mov bl, [hex_digits + bx]
    mov al, bl
    mov ah, 0x0E
    int 0x10
    loop .hex_loop
    popa
    ret

hex_digits db '0123456789ABCDEF'
msg_title  db '=== RELOGIO ===', 13, 10, 0
msg_time   db 'Hora: ', 0
EOF
