section .data
    global regs_8
    regs_8: times 4 db 0

    global regs_16
    regs_16: times 4 dw 0

    global regs_32
    regs_32: times 5 dd 0

    flags: dd 0

    fmt_rsi: db "OP: %d", 10, 0
    fmt_flag: db "Flags: %d", 10, 0

    status_sucesso: db "Sucesso!", 0
    status_erro   : db "Erro: formatacao incorreta!"

section .bss
    global status
    status: resq 1

section .text
    global processador
    extern memoria, printf

processador:
    push rbp
    mov rbp, rsp

    mov rsi, memoria

; ------------------------------------------------------------
;                        LOOP PRINCIPAL
; ------------------------------------------------------------

executar_instrucoes:
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx
    xor rdi, rdi

    mov al, byte [rsi]

    cmp al, 0x0F ; HALT
    je halt_

    cmp al, 0x00 ; LOAD
    je load_

    cmp al, 0x01 ; STORE
    je store_

    cmp al, 0x02 ; ADD
    je add_sub_and_or_xor

    cmp al, 0x03 ; SUB
    je add_sub_and_or_xor

    cmp al, 0x04 ; AND
    je add_sub_and_or_xor

    cmp al, 0x05 ; OR
    je add_sub_and_or_xor

    cmp al, 0x06 ; XOR
    je add_sub_and_or_xor

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

; ------------------------------------------------------------
;                           LOAD
; ------------------------------------------------------------

load_:
    mov al, byte [rsi + 2]

    cmp al, 0x00
    je load_registrador

    cmp al, 0x01
    je load_constante

    cmp al, 0x02
    je load_memoria

    jmp erro

load_registrador:
    mov al, byte [rsi + 1]
    mov bl, byte [rsi + 3]

    cmp al, 0x04
    jl load_registrador_8

    cmp al, 0x08
    jl load_registrador_16

    cmp al, 0x0D
    jl load_registrador_32

    jmp erro

load_registrador_8:
    cmp bl, 0x03
    jg erro

    ; Endereço Destino
    mov rcx, regs_8
    add rcx, rax

    ; Valor origem
    mov rdx, regs_8
    add rdx, rbx
    mov dl, byte [rdx]

    mov byte [rcx], dl

    jmp fim_load

load_registrador_16:
    cmp bl, 0x07
    jg erro
    cmp bl, 0x04
    jl erro

    ; Endereço Destino
    mov rcx, regs_16
    sub rax, 0x04
    shl rax, 1
    add rcx, rax

    ; Valor origem
    mov rdx, regs_16
    sub rbx, 0x04
    shl rbx, 1
    add rdx, rbx
    mov dx, word [rdx]

    mov word [rcx], dx

    jmp fim_load

load_registrador_32:
    cmp bl, 0x0C
    jg erro
    cmp bl, 0x08
    jl erro

    ; Endereço Destino
    mov rcx, regs_32
    sub rax, 0x08
    shl rax, 2
    add rcx, rax

    ; Valor origem
    mov rdx, regs_32
    sub rbx, 0x08
    shl rbx, 2
    add rdx, rbx
    mov edx, dword [rdx]

    mov dword [rcx], edx

    jmp fim_load

load_constante:
    mov al, byte [rsi + 1]
    mov bl, byte [rsi + 3]

    cmp al, 0x04
    jl load_constante_8

    cmp al, 0x08
    jl load_constante_16

    cmp al, 0x0D
    jl load_constante_32

    jmp erro

load_constante_8:
    mov rcx, regs_8
    add rcx, rax
    mov byte [rcx], bl
    jmp fim_load

load_constante_16:
    mov rcx, regs_16
    sub rax, 0x04
    shl rax, 1
    add rcx, rax
    mov word [rcx], bx
    jmp fim_load

load_constante_32:
    mov rcx, regs_32
    sub rax, 0x08
    shl rax, 2
    add rcx, rax
    mov dword [rcx], ebx
    jmp fim_load

load_memoria:
    ; Lógica aqui
    jmp fim_load

fim_load:
    add rsi, 4
    jmp executar_instrucoes

; ------------------------------------------------------------
;                           STORE
; ------------------------------------------------------------

store_:
    ; Verifica erros
    ; Se não houver erros, executa lógica da instrução
    ; Atualiza registradores
    ; Atualiza rsi de acordo com o tamanho da instrução:
    add rsi, 3
    jmp executar_instrucoes

; ------------------------------------------------------------
;                      ADD/SUB/AND/OR/XOR
; ------------------------------------------------------------

add_sub_and_or_xor:
    push rax
    mov al, byte [rsi + 1]
    mov bl, byte [rsi + 2]

    cmp al, 0x04
    jl add_sub_and_or_xor_8

    cmp al, 0x08
    jl add_sub_and_or_xor_16

    cmp al, 0x0D
    jl add_sub_and_or_xor_32

    jmp erro

add_sub_and_or_xor_8:
    cmp bl, 0x03
    jg erro

    ; Endereço Destino
    mov rcx, regs_8
    add rcx, rax

    ; Valor destino
    mov dil, byte [rcx]

    ; Valor origem
    mov rdx, regs_8
    add rdx, rbx
    mov dl, byte [rdx]

    pop rax
    cmp al, 0x02
    je add_8

    cmp al, 0x03
    je sub_8

    cmp al, 0x04
    je and_8

    cmp al, 0x05
    je or_8

    jmp xor_8

add_8:
    add dil, dl
    pushf
    pop rax
    mov dword [flags], eax
    jmp finalizar_op_8

sub_8:
    sub dil, dl
    pushf
    pop rax
    mov dword [flags], eax
    jmp finalizar_op_8

and_8:
    and dil, dl
    jmp finalizar_op_8

or_8:
    or dil, dl
    jmp finalizar_op_8

xor_8:
    xor dil, dl
    jmp finalizar_op_8

finalizar_op_8:
    mov byte [rcx], dil
    jmp fim_add_sub_and_or_xor

add_sub_and_or_xor_16:
    cmp bl, 0x07
    jg erro
    cmp bl, 0x04
    jl erro

    ; Endereço Destino
    mov rcx, regs_16
    sub rax, 0x04
    shl rax, 1
    add rcx, rax

    ; Valor destino
    mov di, word [rcx]

    ; Valor origem
    mov rdx, regs_16
    sub rbx, 0x04
    shl rbx, 1
    add rdx, rbx
    mov dx, word [rdx]

    pop rax
    cmp al, 0x02
    je add_16

    cmp al, 0x03
    je sub_16

    cmp al, 0x04
    je and_16

    cmp al, 0x05
    je or_16

    jmp xor_16

add_16:
    add di, dx
    pushf
    pop rax
    mov dword [flags], eax
    jmp finalizar_op_16

sub_16:
    sub di, dx
    pushf
    pop rax
    mov dword [flags], eax
    jmp finalizar_op_16

and_16:
    and di, dx
    jmp finalizar_op_16

or_16:
    or di, dx
    jmp finalizar_op_16

xor_16:
    xor di, dx
    jmp finalizar_op_16

finalizar_op_16:
    mov word [rcx], di
    jmp fim_add_sub_and_or_xor

add_sub_and_or_xor_32:
    cmp bl, 0x0C
    jg erro
    cmp bl, 0x08
    jl erro

    ; Endereço Destino
    mov rcx, regs_32
    sub rax, 0x08
    shl rax, 2
    add rcx, rax

    ; Valor destino
    mov edi, dword [rcx]

    ; Valor origem
    mov rdx, regs_32
    sub rbx, 0x08
    shl rbx, 2
    add rdx, rbx
    mov edx, dword [rdx]

    pop rax
    cmp al, 0x02
    je add_32

    cmp al, 0x03
    je sub_32

    cmp al, 0x04
    je and_32

    cmp al, 0x05
    je or_32

    jmp xor_32

add_32:
    add edi, edx
    pushf
    pop rax
    mov dword [flags], eax
    jmp finalizar_op_32

sub_32:
    sub edi, edx
    pushf
    pop rax
    mov dword [flags], eax
    jmp finalizar_op_32

and_32:
    and edi, edx
    jmp finalizar_op_32

or_32:
    or edi, edx
    jmp finalizar_op_32

xor_32:
    xor edi, edx
    jmp finalizar_op_32

finalizar_op_32:
    mov dword [rcx], edi
    jmp fim_add_sub_and_or_xor

fim_add_sub_and_or_xor:
    add rsi, 3
    jmp executar_instrucoes

; ------------------------------------------------------------
;                            NOT
; ------------------------------------------------------------

not_:
    mov al, byte [rsi + 1]

    cmp al, 0x04
    jl not_regs_8

    cmp al, 0x08
    jl not_regs_16

    cmp al, 0x0D
    jl not_regs_32

    jmp erro

not_regs_8:
    mov rbx, regs_8
    add rbx, rax
    mov ah, byte [rbx]
    not ah
    mov byte [rbx], ah

    jmp fim_not

not_regs_16:
    mov rbx, regs_16
    sub al, 0x04
    shl al, 1

    add rbx, rax
    mov ax, word [rbx]
    not ax
    mov word [rbx], ax

    jmp fim_not

not_regs_32:
    mov rbx, regs_32
    sub al, 0x08
    shl al, 2

    add rbx, rax
    mov eax, dword [rbx]
    not eax
    mov dword [rbx], eax

    jmp fim_not

fim_not:
    add rsi, 2
    jmp executar_instrucoes

; ------------------------------------------------------------
;                            JMP
; ------------------------------------------------------------

jmp_:
    mov rsi, memoria
    mov eax, dword [regs_32 + 16]
    add rsi, rax
    jmp executar_instrucoes

; ------------------------------------------------------------
;                             JZ
; ------------------------------------------------------------

jz_:
    ; Salta se ZF = 1
    mov eax, dword [flags]
    and eax, 0x40
    jnz jmp_

    add rsi, 1
    jmp executar_instrucoes

; ------------------------------------------------------------
;                            JNZ
; ------------------------------------------------------------

jnz_:
    ; Salta se ZF = 0
    mov eax, dword [flags]
    and eax, 0x40
    jz jmp_

    add rsi, 1
    jmp executar_instrucoes

; ------------------------------------------------------------
;                            JL
; ------------------------------------------------------------

jl_:
    ; Salta se SF ≠ OF
    xor rax, rax
    xor rbx, rbx
    mov eax, dword [flags]
    mov ebx, eax

    and eax, 0x80
    and ebx, 0x800

    shr eax, 7
    shr ebx, 11

    xor eax, ebx

    jnz jmp_

    add rsi, 1
    jmp executar_instrucoes

; ------------------------------------------------------------
;                            JG
; ------------------------------------------------------------

jg_:
    ; Salta se ZF = 0 e SF = OF
    mov eax, dword [flags]
    mov ebx, eax
    mov ecx, ebx

    and eax, 0x40
    shr eax, 6
    not eax

    and ebx, 0x80
    shr ebx, 7

    and ecx, 0x800
    shr ecx, 11

    xor ebx, ecx
    xor ebx, 1

    and eax, ebx

    jnz jmp_

    add rsi, 1
    jmp executar_instrucoes

; ------------------------------------------------------------
;                            JC
; ------------------------------------------------------------

jc_:
    ; Salta se CF = 1
    mov eax, dword [flags]
    and eax, 0x01
    jnz jmp_

    add rsi, 1
    jmp executar_instrucoes

; ------------------------------------------------------------
;                            JNC
; ------------------------------------------------------------

jnc_:
    ; Salta se CF = 0
    mov eax, dword [flags]
    and eax, 0x01
    jz jmp_

    add rsi, 1
    jmp executar_instrucoes

; ------------------------------------------------------------
;                            HALT
; ------------------------------------------------------------

halt_:
    mov qword [status], status_sucesso
    jmp fim

; ------------------------------------------------------------
;                            ERRO
; ------------------------------------------------------------

erro:
    mov qword [status], status_erro
    jmp fim

; ------------------------------------------------------------
;                            FIM
; ------------------------------------------------------------

fim:
    pop rbp
    ret
