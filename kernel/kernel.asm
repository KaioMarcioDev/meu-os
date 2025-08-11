[bits 16]
[org 0x1000]

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x1000

; Limpa a tela
mov ax, 0x0003
int 0x10

; Escreve mensagem inicial
mov si, msg
call print_string

; Loop principal
.key_loop:
    ; Verifica se há tecla pressionada
    mov ah, 0x01
    int 0x16
    jz .key_loop
    
    ; Lê a tecla
    mov ah, 0x00
    int 0x16
    
    ; Verifica se é ESC
    cmp al, 0x1B
    je .exit
    
    ; Mostra a tecla pressionada
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    
    jmp .key_loop

.exit:
    ; Limpa a tela
    mov ax, 0x0003
    int 0x10
    jmp $

print_string:
    pusha
.loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    jmp print_string
.done:
    popa
    ret

msg db "Digite algo (ESC=sair): ", 0
