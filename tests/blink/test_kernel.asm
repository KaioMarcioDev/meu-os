[bits 16]
[org 0x1000]

; Inicializa segmentos
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x1000

; Loop infinito para piscar a tela
.loop:
    ; Tela azul
    mov ax, 0xB800
    mov es, ax
    xor di, di
    mov cx, 80*25
    mov ax, 0x1F20  ; Azul
    rep stosw
    
    ; Espera
    mov cx, 0xFFFF
.wait1:
    loop .wait1
    
    ; Tela vermelha
    mov ax, 0xB800
    mov es, ax
    xor di, di
    mov cx, 80*25
    mov ax, 0x4F20  ; Vermelho
    rep stosw
    
    ; Espera
    mov cx, 0xFFFF
.wait2:
    loop .wait2
    
    jmp .loop