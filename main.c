#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <ctype.h>

extern void processador();

extern uint8_t registradores_8[4];
extern uint16_t registradores_16[4];
extern uint32_t registradores_32[5];
extern uint64_t registradores_128[4];

uint8_t memoria[65536];

int main() {
    FILE *arquivo;
    char byte_hexadecimal[3] = {0};
    int i = 0;
    int j = 0;

    arquivo = fopen("instrucoes.txt", "r");
    if (arquivo == NULL) {
        printf("Erro ao abrir o arquivo.\n");
        return 1;
    }

    char c;
    while ((c = fgetc(arquivo)) != EOF) {
        if (isspace(c)) {
            continue;
        }

        if (!isxdigit(c)) {
            printf("Caractere inválido: %c\n", c);
            fclose(arquivo);
            return 2;
        }

        byte_hexadecimal[j++] = c;

        if (j == 2) {
            unsigned int valor;
            sscanf(byte_hexadecimal, "%02x", &valor);
            memoria[i++] = (uint8_t)valor;
            j = 0;
        }
    }

    fclose(arquivo);

    processador();

    printf("Valor dos registradores:\n");
    printf("R80.: %i\n", registradores_8[0]);
    printf("R81.: %i\n", registradores_8[1]);
    printf("R82.: %i\n", registradores_8[2]);
    printf("R83.: %i\n", registradores_8[3]);
    printf("R160: %i\n", registradores_16[0]);
    printf("R161: %i\n", registradores_16[1]);
    printf("R162: %i\n", registradores_16[2]);
    printf("R163: %i\n", registradores_16[3]);
    printf("R320: %i\n", registradores_32[0]);
    printf("R321: %i\n", registradores_32[1]);
    printf("R322: %i\n", registradores_32[2]);
    printf("R323: %i\n", registradores_32[3]);
    //Impressão do primeiro registrador de 128 bits
    //Impressão do segundo registrador de 128 bits
    printf("DESV: %i\n", registradores_32[4]);

    return 0;
}