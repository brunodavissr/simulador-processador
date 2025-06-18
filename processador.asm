section .text
global processador

; Layout dos registradores na memória:
; 0x00-0x03: R80-R83 (8-bit)
; 0x04-0x07: R160-R163 (16-bit)
; 0x08-0x0B: R320-R323 (32-bit)
; 0x0C-0x0D: R1280-R1281 (128-bit)
; 0x0E: Registrador DESV (32-bit)

; Esta implementação usa a seguinte estratégia para registradores temporários:
; ebp: Offset do registrador destino
; esp: Offset do registrador fonte
; edx: Tamanho dos dados
; eax, ebx, ecx: Uso geral temporário

; Após cada operação de cópia (rep movsb), restauramos:
; esi: Ponteiro para memória de instruções
; edi: Ponteiro para área de registradores

processador:
    ; Obter parâmetros
    mov esi, [ebp+4]    ; ponteiro para memoria
    mov edi, [ebp+8]   ; ponteiro para registradores
    mov ecx, [ebp+12]   ; tamanho_memoria
    
    ; Inicializar contador de programa
    xor eax, eax
    mov [edi + 0x0F], eax  ; DESV começa em 0 (será usado como PC)
    
    ; Loop principal de execução
.execute_inst:
    ; Verificar se chegou ao final da memória
    mov eax, [edi + 0x0E]  ; Obter PC atual (DESV)
    cmp eax, ecx
    jge .end_exe
    
    ; Buscar instrução
    movzx ebx, byte [esi + eax] ;lê o proximo byte
    inc eax ;incrementa PC
    mov [edi + 0x0E], eax  ; Atualiza PC
    
    ; Decodificar e executar instrução
    cmp ebx, 0x00
    je .load
    cmp ebx, 0x01
    je .store
    cmp ebx, 0x02
    je .add
    cmp ebx, 0x03
    je .sub
    cmp ebx, 0x04
    je .and
    cmp ebx, 0x05
    je .or
    cmp ebx, 0x06
    je .xor
    cmp ebx, 0x07
    je .not
    cmp ebx, 0x08
    je .jmp
    cmp ebx, 0x09
    je .jz
    cmp ebx, 0x0A
    je .jnz
    cmp ebx, 0x0B
    je .jl
    cmp ebx, 0x0C
    je .jg
    cmp ebx, 0x0D
    je .jc
    cmp ebx, 0x0E
    je .jnc
    cmp ebx, 0x0F
    je .halt
    
    ; Instrução desconhecida - pular
    jmp .execute_inst


; Função auxiliar para obter o offset e tamanho do registrador
; Entrada: reg_idx em AL
; Saída: EBX = offset, ECX = tamanho (em bytes)
get_reg_size:
    movzx ebx, al
    cmp al, 0x04
    jb .is_8bit
    cmp al, 0x08
    jb .is_16bit
    cmp al, 0x0C
    jb .is_32bit
    cmp al, 0x0E
    jb .is_128bit
    ; inválido
    xor ebx, ebx
    xor ecx, ecx
    ret
.is_8bit:
    mov ecx, 1
    ret
.is_16bit:
    sub ebx, 0x04
    shl ebx, 1      ; 2 bytes por registrador
    add ebx, 0x04
    mov ecx, 2
    ret
.is_32bit:
    sub ebx, 0x08
    shl ebx, 2      ; 4 bytes por registrador
    add ebx, 0x08
    mov ecx, 4
    ret
.is_128bit:
    sub ebx, 0x0C
    shl ebx, 4      ; 16 bytes por registrador
    add ebx, 0x0C
    mov ecx, 16
    ret

; Implementações das instruções
.load:; Variantes: reg-reg; reg-imm; reg-[imm]; reg-[reg]
    ; LOAD dst, src
    ; Próximo byte: bits 7-4 = dst, bits 3-0 = src
    mov eax, [edi + 0x0E]      ; PC atual
    movzx ebx, byte [esi + eax]
    inc eax
    mov [edi + 0x0E], eax      ; Atualiza PC

    mov edx, ebx
    shr ebx, 4                 ; dst = bits 7-4
    and edx, 0x0F              ; src = bits 3-0

    ; Próximo byte: modo de endereçamento
    mov eax, [edi + 0x0E]
    movzx eax, byte [esi + eax]
    inc dword [edi + 0x0E] ; Incrementa PC

    ; Modo 0: src = reg
    cmp al, 0x00
    je .load_reg
    ; Modo 1: src = constante
    cmp al, 0x01
    je .load_const
    ; Modo 2: src = memoria direta ([constante])
    cmp al, 0x02
    je .load_memdir
    ; Modo 3: src = memoria indereta ([reg])
    cmp al, 0x03 
    je .load_memind

    jmp .execute_inst
    
.load_reg:
    ; dst <- src_reg
    ; Usamos ebp para offset_dst, esp para offset_src, edx para tamanhos
    mov al, bl
    call get_reg_size
    mov ebp, ebx        ; ebp = offset_dst
    mov eax, ecx        ; eax = size_dst

    mov al, dl
    call get_reg_size
    mov esp, ebx        ; esp = offset_src
    mov edx, ecx        ; edx = size_src

    ; Determina menor tamanho
    cmp eax, edx
    cmovb edx, eax      ; edx = min(size_dst, size_src)

    ; Configura cópia
    lea esi, [edi + esp]  ; fonte
    lea edi, [edi + ebp]  ; destino
    mov ecx, edx          ; contador
    rep movsb

    ; Restaura edi (importante!)
    mov edi, [ebp+8]     ; recupera ponteiro de registradores
    jmp .execute_inst

.load_const:
    ; dst <- constante
    mov al, bl
    call get_reg_size
    mov ebp, ebx        ; ebp = offset_dst
    mov edx, ecx        ; edx = size

    ; Copia da memória para o registrador
    mov eax, [edi + 0x0E]
    lea esi, [esi + eax]  ; fonte
    lea edi, [edi + ebp]  ; destino
    mov ecx, edx
    rep movsb

    ; Atualiza PC e restaura edi
    add [edi + 0x0E], edx
    mov edi, [ebp+8]
    jmp .execute_inst

.load_memdir:
    mov al, bl
    call get_reg_size
    mov ebp, ebx        ; ebp = offset_dst
    mov edx, ecx        ; edx = size

    ; Lê endereço da memória
    mov eax, [edi + 0x0E]
    mov ebx, [esi + eax]
    add eax, 4
    mov [edi + 0x0E], eax

    ; Copia da memória para o registrador
    lea esi, [esi + ebx]  ; fonte
    lea edi, [edi + ebp]  ; destino
    mov ecx, edx
    rep movsb

    mov esi, [ebp+4]      ; restaura ponteiro de memória
    mov edi, [ebp+8]      ; restaura ponteiro de registradores

    jmp .execute_inst

.load_memind:
    ; dst <- [src_reg]
    ; Usando:
    ; ebx = código do registrador src (já está em bl)
    ; edx = código do registrador dst (já está em bh)
    
    ; Endereço do registrador fonte
    mov al, bl
    call get_reg_size      ; ebx = offset_src, ecx = size_src
    mov esp, ebx          ; esp = offset do registrador fonte
    
    ; Lê o endereço contido no registrador fonte
    mov eax, [edi + esp]  ; eax = endereço de memória
    
    ; Agora obtemos informações do registrador destino
    mov al, bh
    call get_reg_size      ; ebx = offset_dst, ecx = size_dst
    mov ebp, ebx          ; ebp = offset do registrador destino
    mov edx, ecx          ; edx = tamanho do destino
    
    ; Configura a cópia da memória para o registrador
    lea esi, [esi + eax]  ; fonte na memória
    lea edi, [edi + ebp]  ; destino no registrador
    mov ecx, edx          ; ecx = bytes a copiar
    rep movsb             ; executa a cópia
    
    ; Restaura registradores essenciais
    mov esi, [ebp+4]      ; restaura ponteiro de memória
    mov edi, [ebp+8]      ; restaura ponteiro de registradores

    jmp .execute_inst

.store:
    ; STORE dst, src
    ; Próximo byte: bits 7-4 = dst (memória), bits 3-0 = src (registrador)
    mov eax, [edi + 0x0E]      ; PC atual
    movzx ebx, byte [esi + eax] ; Byte 1: dst_mode (4 bits) | src_reg (4 bits)
    inc eax
    mov [edi + 0x0E], eax      ; Atualiza PC

    mov edx, ebx               ; Salva byte completo
    shr ebx, 4                 ; dst_mode = bits 7-4
    and edx, 0x0F              ; src_reg = bits 3-0

    ; Lê modo de endereçamento
    mov eax, [edi + 0x0E]
    movzx eax, byte [esi + eax]
    inc dword [edi + 0x0E]
    
    cmp al, 0x00
    je .store_memdir
    cmp al, 0x01
    je .store_memind

    jmp .execute_inst

.store_memdir:
    ; [imediato] <- src_reg
    ; Obtém informações do registrador fonte
    mov al, dl
    call get_reg_size      ; ebx = offset_src, ecx = size_src
    mov esp, ebx          ; esp = offset do registrador fonte
    mov edx, ecx          ; edx = tamanho dos dados

    ; Lê endereço de destino da memória
    mov eax, [edi + 0x0E]
    mov ebx, [esi + eax]   ; ebx = endereço de destino
    add eax, 4
    mov [edi + 0x0E], eax  ; Atualiza PC

    ; Configura a cópia do registrador para a memória
    lea esi, [edi + esp]  ; esi = dados fonte (do registrador)
    lea edi, [esi + ebx]  ; edi = destino na memória
    mov ecx, edx          ; ecx = bytes a copiar
    rep movsb             ; executa a cópia

    ; Restaura registradores essenciais
    mov esi, [ebp+4]      ; restaura ponteiro de memória
    mov edi, [ebp+8]      ; restaura ponteiro de registradores

    jmp .execute_inst

.store_memind:
    ; [dst_reg] <- src_reg
    ; Obtém informações do registrador destino (que contém o endereço)
    mov al, bl
    call get_reg_size      ; ebx = offset_dst, ecx = size_dst
    mov ebp, ebx          ; ebp = offset do registrador destino
    
    ; Lê o endereço de destino do registrador
    mov eax, [edi + ebp]  ; eax = endereço de memória
    
    ; Obtém informações do registrador fonte
    mov al, dl
    call get_reg_size      ; ebx = offset_src, ecx = size_src
    mov esp, ebx          ; esp = offset do registrador fonte
    mov edx, ecx          ; edx = tamanho dos dados

    ; Configura a cópia do registrador para a memória
    lea esi, [edi + esp]  ; esi = dados fonte (do registrador)
    lea edi, [esi + eax]  ; edi = destino na memória
    mov ecx, edx          ; ecx = bytes a copiar
    rep movsb             ; executa a cópia

    ; Restaura registradores essenciais
    mov esi, [ebp+4]      ; restaura ponteiro de memória
    mov edi, [ebp+8]      ; restaura ponteiro de registradores

    jmp .execute_inst

.add:
    ; Obter operandos (próximo byte: registradores fonte e destino)
    movzx ebx, byte [esi + eax]
    inc eax
    mov [edi + 0x0F], eax  ; Atualizar PC
    
    ; Extrair registradores fonte e destino (4 bits cada)
    mov edx, ebx
    shr edx, 4          ; registrador fonte
    and ebx, 0x0F       ; registrador destino
    
    ; Determinar tamanhos dos registradores e realizar adição
    ; Implementar baseado nos tamanhos dos registradores
    ; Configurar flags 
    jmp .execute_inst

.sub:
    ; Similar a ADD mas com subtração
    jmp .execute_inst

.and:
    ; Operação lógica AND
    jmp .execute_inst

.or:
    ; Operação lógica OR
    jmp .execute_inst

.xor:
    ; Operação lógica XOR
    jmp .execute_inst

.not:
    ; Operação de inversão de bits (NOT)
    jmp .execute_inst

.jmp:
    ; Salto incondicional
    mov eax, [esi + eax]
    mov [edi + 0x0F], eax
    jmp .execute_inst

.jz:
    ; Saltar se flag Z = 1
    add dword [edi + 0x0F], 4  ; Pular endereço 
    jmp .execute_inst

.jnz:
    ; Saltar se flag Z = 0
    add dword [edi + 0x0F], 4  ; Pular endereço 
    jmp .execute_inst

.jl:
    ; Saltar se N ≠ O
    add dword [edi + 0x0F], 4  ; Pular endereço 
    jmp .execute_inst

.jg:
    ; Saltar se Z=0 e N=O
    add dword [edi + 0x0F], 4
    jmp .execute_inst

.jc:
    ; Saltar se flag C = 1
    add dword [edi + 0x0F], 4
    jmp .execute_inst

.jnc:
    ; Saltar se flag C = 0
    add dword [edi + 0x0F], 4
    jmp .execute_inst

.do_jump:
    ; Manipulação comum de saltos
    mov eax, [edi + 0x0F]
    mov eax, [esi + eax]
    mov [edi + 0x0F], eax
    jmp .execute_inst

.halt:
    ; Finalizar execução
    jmp .end_exe

.end_exe:
    ; Imprimir valores dos registradores
    call print_registers
    ret

print_registers:
    ; Implementar impressão de registradores
    ret