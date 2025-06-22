# Simulador de Processador

## 🎯 Objetivo

Este projeto tem como objetivo simular o funcionamento de um processador hipotético, definido com base em um conjunto de registradores e um conjunto de instruções

---

## ⚙️ Funcionalidades

- Entrada com arquivo de texto contendo as instruções em formato hexadecimal
- Simular registradores (8, 16 e 32 bits)
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
| DESV        | 32 bits   | 0x0C   | Armazena endereço de desvio             |

---

## 🧾 Instruções

| Instrução  | Descrição                           | Opcode | Exemplo                                                 |
|------------|-------------------------------------|--------|---------------------------------------------------------|
| LOAD       | Carrega valor no registrador        | 0x00   | `LOAD R160, R161`, `LOAD R160, 10`, `LOAD R160, [R320]` |
| STORE      | Armazena valor na memória principal | 0x01   | `STORE [R320], R161`                                    |
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

---

## 🔟 Código de máquina

- RegDes (Registrador de destino): Opcode do registrador que armazenará o resultado da instrução
- RegOrg (Registrador de origem): Opcode do registrador que será utilizado como operando da instrução
- RegEnd (Registrador de endereço): Opcode do registrador que será utilizado para referenciar uma posição na memória
- ValOrg (Valor de origem): Pode ser tanto um valor constante como o opcode de um registrador (podendo ser usado como valor direto ou para referênciar a memória)
- TipoOp (Tipo de operação): Parâmetro usado na instrução LOAD. Utilizar 0x00 caso ValOrg seja o opcode de um registrador, 0x01 caso ValOrg seja uma constante ou 0x02 caso ValOrg seja o opcode de um registrador que referência a memória

| Instrução | Tamanho | Estrutura da instrução                         |
|-----------|---------|------------------------------------------------|
| LOAD      | 4 bytes | [00] [RegDes] [TipoOp] [ValOrg]                |
| STORE     | 3 bytes | [01] [RegEnd] [RegOrg]                         |
| ADD       | 3 bytes | [02] [RegDes] [RegOrg]                         |
| SUB       | 3 bytes | [03] [RegDes] [RegOrg]                         |
| AND       | 3 bytes | [04] [RegDes] [RegOrg]                         |
| OR        | 3 bytes | [05] [RegDes] [RegOrg]                         |
| XOR       | 3 bytes | [06] [RegDes] [RegOrg]                         |
| NOT       | 2 bytes | [07] [RegDes]                                  |
| JMP       | 1 byte  | [08]                                           |
| JZ        | 1 byte  | [09]                                           |
| JNZ       | 1 byte  | [0A]                                           |
| JL        | 1 byte  | [0B]                                           |
| JG        | 1 byte  | [0C]                                           |
| JC        | 1 byte  | [0D]                                           |
| JNC       | 1 byte  | [0E]                                           |
| HALT      | 1 byte  | [0F]                                           |

---

## 🔍 Observações

- Essa é uma máquina de 32 bits, ou seja, só aceita registradores de 32 bits como referência a posições na memória
- Será utilizada a ordem de bytes big-endian para o código de máquina
- Será simulada uma memória de 65536 bytes

---

## 🔀 Fluxograma

![Fluxograma do simulador](fluxograma.png)
