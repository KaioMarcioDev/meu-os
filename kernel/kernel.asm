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

; Escreve mensagem inicial diretamente na memória de vídeo
mov ax, 0xB800
mov es, ax
mov di, 0
mov si, msg
mov ah, 0x0F  ; Branco brilhante

.msg_loop:
    lodsb
    or al, al
    jz .msg_done
    stosw
    jmp .msg_loop

.msg_done:

; Posição inicial para as teclas (linha 2)
mov di, 160 * 2  ; Cada linha tem 160 bytes (80 caracteres * 2)

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
    
    ; Escreve a tecla diretamente na memória de vídeo
    mov [es:di], al
    mov byte [es:di+1], 0x0C  ; Vermelho brilhante
    add di, 2
    
    ; Se chegou ao fim da linha, pula para a próxima
    cmp di, 160 * 25
    jb .key_loop
    mov di, 160 * 2  ; Volta para o início da linha 2
    
    jmp .key_loop

.exit:
    ; Limpa a tela
    mov ax, 0x0003
    int 0x10
    jmp $

msg db "Digite algo (ESC=sair): ", 0