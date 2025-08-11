cat > tests/animation/test_kernel.asm << 'EOF'
[bits 16]
[org 0x1000]

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x1000

mov ax, 0x0013
int 0x10

mov ax, 0xA000
mov es, ax

mov si, 0
.animation_loop:
    mov cx, 1000
.fill_loop:
    mov al, [pattern + si]
    stosb
    inc si
    and si, 3
    loop .fill_loop

    mov ah, 0x86
    mov cx, 0x0000
    mov dx, 0x3FFF
    int 0x15

    jmp .animation_loop

pattern db 0x1F, 0x2F, 0x3F, 0x4F
EOF
