#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <ctype.h>

extern void processador(uint8_t *memoria, int quantidade_instrucoes);

int main() {
    FILE *arquivo;
    char byte_hexadecimal[3] = {0};
    uint8_t memoria[1024];
    int quantidade_instrucoes = 0;
    int index = 0;

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

        byte_hexadecimal[index++] = c;

        if (index == 2) {
            unsigned int valor;
            sscanf(byte_hexadecimal, "%02x", &valor);
            memoria[quantidade_instrucoes++] = (uint8_t)valor;
            index = 0;
        }
    }

    fclose(arquivo);

    processador(memoria, quantidade_instrucoes);

    return 0;
}
