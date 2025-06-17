section .text
global processador

; Layout dos registradores na memória:
; 0x00-0x03: R80-R83 (8-bit)
; 0x04-0x07: R160-R163 (16-bit)
; 0x08-0x0B: R320-R323 (32-bit)
; 0x0C-0x0D: R1280-R1281 (128-bit)
; 0x0E: Registrador DESV (32-bit)

processador:
    ; Obter parâmetros
    mov esi, [ebp+8]    ; ponteiro para memoria
    mov edi, [ebp+12]   ; ponteiro para registradores
    mov ecx, [ebp+16]   ; tamanho_memoria
    
    ; Inicializar contador de programa
    xor eax, eax
    mov [edi + 0x0F], eax  ; DESV começa em 0 (será usado como PC)
    
    ; Loop principal de execução
.execute_inst:
    ; Verificar se chegamos ao final da memória
    mov eax, [edi + 0x0F]  ; Obter PC atual (DESV)
    cmp eax, ecx
    jge .end_exe
    
    ; Buscar instrução
    movzx ebx, byte [esi + eax] ;lê o proximo byte
    inc eax ;incrementa PC
    mov [edi + 0x0F], eax  ; Atualizar PC
    
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

; Implementações das instruções
.load:
    ; Implementar instrução LOAD
    ; Variantes: reg-reg; reg-imm; reg-[imm]; reg-[reg]
    jmp .execute_inst

.store:
    ; Implementar instrução STORE
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