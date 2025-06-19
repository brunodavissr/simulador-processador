# Simulador de Processador

## 🎯 Objetivo

Este projeto tem como objetivo simular o funcionamento de um processador hipotético, definido com base em um conjunto de registradores e um conjunto de instruções

---

## ⚙️ Funcionalidades

- Entrada com arquivo de texto contendo as instruções em formato hexadecimal
- Simular registradores (8, 16, 32 e 128 bits)
- Simular memória principal (dados e instruções)
- Suportar instruções aritméticas, lógicas, de controle de fluxo e de movimentação de dados
- Utilizar flags para controlar saltos: Carry (C), Overflow (O), Negativo (N), Zero (Z)
- Saída deverá conter o valor de cada um dos registradores após a execução das instruções

---

## 🧠 Registradores

| Registrador | Tamanho   | Opcode | Descrição                               |
|-------------|-----------|--------|-----------------------------------------|
| R80         | 8 bits    | 0x00   | Uso genérico                            |
| R81         | 8 bits    | 0x01   | Uso genérico                            |
| R82         | 8 bits    | 0x02   | Uso genérico                            |
| R83         | 8 bits    | 0x03   | Uso genérico                            |
| R160        | 16 bits   | 0x04   | Uso genérico                            |
| R161        | 16 bits   | 0x05   | Uso genérico                            |
| R162        | 16 bits   | 0x06   | Uso genérico                            |
| R163        | 16 bits   | 0x07   | Uso genérico                            |
| R320        | 32 bits   | 0x08   | Uso genérico                            |
| R321        | 32 bits   | 0x09   | Uso genérico                            |
| R322        | 32 bits   | 0x0A   | Uso genérico                            |
| R323        | 32 bits   | 0x0B   | Uso genérico                            |
| R1280       | 128 bits  | 0x0C   | Uso genérico                            |
| R1281       | 128 bits  | 0x0D   | Uso genérico                            |
| DESV        | 32 bits   | 0x0E   | Guarda endereço para desvio             |

---

## 🧾 Instruções

| Instrução  | Descrição                           | Opcode | Exemplo                                                 |
|------------|-------------------------------------|--------|---------------------------------------------------------|
| LOAD       | Carrega valor no registrador        | 0x00   | `LOAD R160, R161`, `LOAD R160, 10`, `LOAD R160, [R161]` |
| STORE      | Armazena valor na memória principal | 0x01   | `STORE [R160], R161`                                    |
| ADD        | Soma dois registradores             | 0x02   | `ADD R160, R161`                                        |
| SUB        | Subtrai dois registradores          | 0x03   | `SUB R160, R161`                                        |
| AND        | Realiza operação lógica AND         | 0x04   | `AND R160, R161`                                        |
| OR         | Realiza operação lógica OR          | 0x05   | `OR R160, R161`                                         |
| XOR        | Realiza operação lógica XOR         | 0x06   | `XOR R160, R161`                                        |
| NOT        | Inverte bits do registrador         | 0x07   | `NOT R160`                                              |
| JMP        | Salta incondicionalmente            | 0x08   | `JMP`                                                   |
| JZ         | Salta se Z = 1                      | 0x09   | `JZ`                                                    |
| JNZ        | Salta se Z = 0                      | 0x0A   | `JNZ`                                                   |
| JL         | Salta se N ≠ O                      | 0x0B   | `JL`                                                    |
| JG         | Salta se Z = 0 e N = O              | 0x0C   | `JG`                                                    |
| JC         | Salta se C = 1                      | 0x0D   | `JC`                                                    |
| JNC        | Salta se C = 0                      | 0x0E   | `JNC`                                                   |
| HALT       | Encerra execução                    | 0x0F   | `HALT`                                                  |
