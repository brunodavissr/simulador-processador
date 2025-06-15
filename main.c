#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <ctype.h>

extern void processador(uint8_t *memoria, uint8_t *registradores, int tamanho_memoria);

int main() {
    FILE *arquivo;
    char hex_byte[3] = {0};
    uint8_t memoria[1024];
    uint8_t registradores[256] = {0};
    int memoria_index = 0;
    int pos = 0;

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

        hex_byte[pos++] = c;

        if (pos == 2) {
            unsigned int valor;
            sscanf(hex_byte, "%02x", &valor);
            memoria[memoria_index++] = (uint8_t)valor;
            pos = 0;
        }
    }

    fclose(arquivo);

    processador(memoria, registradores, memoria_index);

    return 0;
}
