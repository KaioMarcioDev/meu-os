; Carrega setores do disco para memória
disk_load:
    pusha
    mov ah, 0x02  ; Função de leitura do disco
    mov al, dh    ; Número de setores
    mov ch, 0x00  ; Cilindro 0
    mov dh, 0x00  ; Cabeçote 0
    mov cl, 0x02  ; Setor inicial (após o bootloader)

    int 0x13      ; Interrupção de disco
    jc .error     ; Se houver erro (carry flag setada)

    popa
    ret

.error:
    jmp $         ; Loop infinito em caso de erro