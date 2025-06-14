# Simulador de Processador

## 🎯 Objetivo

Este projeto tem como objetivo simular o funcionamento de um processador hipotético, definido com base em um conjunto de registradores e um conjunto de instruções

---

## ⚙️ Funcionalidades

- Entrada com arquivo de texto contendo as instruções em formato hexadecimal
- Simular registradores (8, 16, 32 e 128 bits)
- Simular memória principal (dados e instruções)
- Suportar instruções aritméticas, lógicas, de controle de fluxo e de movimentação de dados
- Flags de condição: Zero (Z), Negativo (N), Carry (C)
- Saída deverá conter o valor de cada um dos registradores após a execução das instruções

---

## 🧠 Registradores

| Registrador | Tamanho   | Funcionalidade                                                                       |
|-------------|-----------|--------------------------------------------------------------------------------------|
| R80         | 8 bits    | Uso genérico                                                                         |
| R81         | 8 bits    | Uso genérico                                                                         |
| R82         | 8 bits    | Uso genérico                                                                         |
| R83         | 8 bits    | Uso genérico                                                                         |
| R160        | 16 bits   | Uso genérico                                                                         |
| R161        | 16 bits   | Uso genérico                                                                         |
| R162        | 16 bits   | Uso genérico                                                                         |
| R163        | 16 bits   | Uso genérico                                                                         |
| R320        | 32 bits   | Uso genérico                                                                         |
| R321        | 32 bits   | Uso genérico                                                                         |
| R322        | 32 bits   | Uso genérico                                                                         |
| R323        | 32 bits   | Uso genérico                                                                         |
| R1280       | 128 bits  | Uso genérico                                                                         |
| R1281       | 128 bits  | Uso genérico                                                                         |
| FLAG        | 8 bits    | Armazena as flags Z (zero), N (negativo) e C (carry) nos 3 bits menos significativos |
| DESV        | 32 bits   | Guarda endereço para desvio (JMP)                                                    |

---

## 🧾 Instruções

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