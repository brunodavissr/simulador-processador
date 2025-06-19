section .data
    global regs_8
    regs_8: times 4 db 0

    global regs_16
    regs_16: times 4 dw 0

    global regs_32
    regs_32: times 5 dd 0

    global regs_128
    regs_128: times 4 dq 0

    ; Adicionar mensagem para retorno (Sucesso, operação inexistente, instrução invalida, registradores de tamanhos diferentes)

    fmt: db "%d", 10, 0

section .text
    global processador
    extern memoria, printf

processador:
    push rbp
    mov rbp, rsp

    mov rsi, memoria

executar_instrucoes:
    mov al, byte [rsi]

    ; Imprimindo apenas para debug
    push rsi
    push rax
    mov rsi, rax
    mov rdi, fmt
    xor rax, rax
    call printf

    pop rax
    pop rsi

    cmp al, 0x0F ; HALT
    je fim

    cmp al, 0x00 ; LOAD
    je load_

    cmp al, 0x01 ; STORE
    je store_

    cmp al, 0x02 ; ADD
    je add_

    cmp al, 0x03 ; SUB
    je sub_

    cmp al, 0x04 ; AND
    je and_

    cmp al, 0x05 ; OR
    je or_

    cmp al, 0x06 ; XOR
    je xor_

    cmp al, 0x07 ; NOT
    je not_

    cmp al, 0x08 ; JMP
    je jmp_

    cmp al, 0x09 ; JZ
    je jz_

    cmp al, 0x0A ; JNZ
    je jnz_

    cmp al, 0x0B ; JL
    je jl_

    cmp al, 0x0C ; JG
    je jg_

    cmp al, 0x0D ; JC
    je jc_

    cmp al, 0x0E ; JNC
    je jnc_

    jmp erro

load_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 4
    jmp executar_instrucoes

store_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 3
    jmp executar_instrucoes

add_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 3
    jmp executar_instrucoes

sub_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 3
    jmp executar_instrucoes

and_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 3
    jmp executar_instrucoes

or_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 3
    jmp executar_instrucoes

xor_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 3
    jmp executar_instrucoes

; ---------------------------------------------------------------

not_:
    mov al, byte [rsi + 1]

    cmp al, 0x04
    jl not_regs_8

    cmp al, 0x08
    jl not_regs_16

    cmp al, 0x0D
    jl not_regs_32

    cmp al, 0x0F
    jl not_regs_128

    jmp erro

not_regs_8:
    mov rbx, regs_8
    add rbx, rax
    mov ah, byte [rbx]
    not ah
    mov byte [rbx], ah

    add rsi, 2
    jmp executar_instrucoes

not_regs_16:
    mov rbx, regs_16
    sub al, 0x04
    shl al, 1

    add rbx, rax
    mov ax, word [rbx]
    not ax
    mov word [rbx], ax

    add rsi, 2
    jmp executar_instrucoes

not_regs_32:
    mov rbx, regs_32
    sub al, 0x08
    shl al, 2

    add rbx, rax
    mov eax, dword [rbx]
    not eax
    mov dword [rbx], eax

    add rsi, 2
    jmp executar_instrucoes

not_regs_128:
    ; Lógica aqui
    add rsi, 2
    jmp executar_instrucoes

; -------------------------------------------------------------

jmp_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 1
    jmp executar_instrucoes

jz_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 1
    jmp executar_instrucoes

jnz_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 1
    jmp executar_instrucoes

jl_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 1
    jmp executar_instrucoes

jg_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 1
    jmp executar_instrucoes

jc_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 1
    jmp executar_instrucoes

jnc_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 1
    jmp executar_instrucoes

erro:
    ; armazena mensagem correspondente de erro para retorná-la ao código C
    jmp fim

fim:
    pop rbp
    ret