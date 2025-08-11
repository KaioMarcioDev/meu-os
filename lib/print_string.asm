; Imprime uma string em modo real
print_string:
    pusha
    mov ah, 0x0E  ; Função de teletype da BIOS

.loop:
    lodsb         ; Carrega próximo caractere
    cmp al, 0
    je .done

    int 0x10      ; Interrupção de vídeo
    jmp .loop

.done:
    popa
    ret