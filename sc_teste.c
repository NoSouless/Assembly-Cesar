#include <stdio.h>
#include <string.h>

int main() {
   
    char criptografado[] = "fzaqhdkz drsz drstczmcn\n";
    char palavrapossivel[] = "estuda"; 
    char criptografiaatual[50];       
    
    char *ptr_orig = palavrapossivel;
    char *ptr_dest = criptografiaatual;

   
    while (*ptr_orig != '\0') {
        *ptr_dest = *ptr_orig + 1; 
        ptr_orig++;
        ptr_dest++;
    }
    *ptr_dest = '\0'; 

  
    int encontrado = 0;
    int tam_frase = strlen(criptografado);
    int tam_palavra = strlen(criptografiaatual);

    for (int i = 0; i <= tam_frase - tam_palavra; i++) {
        int bate = 1;
        for (int j = 0; j < tam_palavra; j++) {
            if (criptografado[i + j] != criptografiaatual[j]) {
                bate = 0;
                break;
            }
        }
        if (bate) {
            encontrado = 1;
            break;
        }
    }

    
    if (encontrado) {
        printf("Encontrado!\n");
    } else {
        printf("Não encontrado!\n");
    }

    return 0;
}