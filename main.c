#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <ctype.h>

extern void processador();

extern char *status;
extern int8_t regs_8[4];
extern int16_t regs_16[4];
extern int32_t regs_32[5];

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

    printf("Status: %s\n\n", status);

    printf("Valor dos registradores:\n");
    printf("R80.: %i\n", regs_8[0]);
    printf("R81.: %i\n", regs_8[1]);
    printf("R82.: %i\n", regs_8[2]);
    printf("R83.: %i\n", regs_8[3]);
    printf("R160: %i\n", regs_16[0]);
    printf("R161: %i\n", regs_16[1]);
    printf("R162: %i\n", regs_16[2]);
    printf("R163: %i\n", regs_16[3]);
    printf("R320: %i\n", regs_32[0]);
    printf("R321: %i\n", regs_32[1]);
    printf("R322: %i\n", regs_32[2]);
    printf("R323: %i\n", regs_32[3]);
    printf("DESV: %i\n", regs_32[4]);

    return 0;
}
