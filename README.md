# Simulador de Processador (Assembly Didático em C)

## 🧠 Objetivo

Este projeto tem como objetivo simular uma arquitetura de processador simples

| Instrução  | Descrição                      | Exemplo           |
|------------|--------------------------------|-------------------|
| LOAD       | Carrega valor em registrador   | `LOAD R1, 5`      |
| STORE      | Armazena valor no endereço     | `STORE [R1], 5`   |
| ADD        | Soma dois registradores        | `ADD R1, R2`      |
| SUB        | Subtrai registradores          | `SUB R1, R2`      |
| AND/OR/XOR | Operações lógicas              | `AND R1, R2`      |
| NOT        | Inverte bits do registrador    | `NOT R1`          |
| JZ         | Salta se Zero flag ativa       | `JZ FIM`          |
| JMP        | Salta incondicionalmente       | `JMP INICIO`      |
| HALT       | Encerra execução               | `HALT`            |

## ⚙️ Funcionalidades

- Interpretação de instruções em assembly didático
- Registradores simulados (ex: R0 até R15)
- Memória RAM simulada
- Instruções aritméticas, lógicas e de controle de fluxo
- Flags de condição: Zero (Z), Negativo (N), Carry (C), Overflow (O)
- Suporte a saltos condicionais e incondicionais (JMP, JZ, etc.)