[org 0x7C00]
[bits 16]

; Configura pilha
mov ax, 0
mov ss, ax
mov sp, 0x7C00

; Mensagem inicial
mov si, msg_start
call print_string

; Carrega kernel
mov bx, 0x1000
mov dh, 1
mov dl, 0x00    ; Disquete
call disk_load

; Verifica erro
jc .error

; Mensagem de sucesso
mov si, msg_loaded
call print_string

; Salto para kernel
jmp 0x1000

.error:
    mov si, msg_error
    call print_string
    jmp $

; Função print_string
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

; Função disk_load
disk_load:
    pusha
    mov ah, 0x02      ; Função de leitura do disco
    mov al, dh        ; Número de setores
    mov ch, 0x00      ; Cilindro 0
    mov dh, 0x00      ; Cabeçote 0
    mov cl, 0x02      ; Setor inicial (após o bootloader)
    
    int 0x13          ; Interrupção de disco
    jc .error         ; Se houver erro (carry flag setada)
    
    popa
    ret

.error:
    jmp $             ; Loop infinito em caso de erro

; Dados
msg_start db "Iniciando bootloader...", 13, 10, 0
msg_loaded db "Kernel carregado!", 13, 10, 0
msg_error db "Erro ao carregar kernel!", 13, 10, 0

; Preenchimento e assinatura
times 510-($-$$) db 0
dw 0xAA55
