cat > tests/game/test_kernel.asm << 'EOF'
[bits 16]
[org 0x1000]

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x1000

mov ax, 0x0003
int 0x10

mov si, msg_start
call print_string

mov cx, 10
game_loop:
    mov ah, 0x0E
    mov al, '*'
    int 0x10
    loop game_loop

mov si, msg_end
call print_string

jmp $

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

msg_start db '=== MINI GAME ===', 13, 10, 0
msg_end   db 13, 10, 'Fim do jogo.', 0
EOF
