cat > tests/graphic/test_kernel.asm << 'EOF'
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
xor di, di
mov cx, 320*200
xor al, al

.draw_loop:
    stosb
    inc al
    loop .draw_loop

jmp $
EOF