int main() {

    char palavraOriginal[] = "ai";
    char mensagem[] = "dkwy ks";
    char buffer[100];

    int saltos = 0;

    while (saltos < 26) {

        // copia string
        int i = 0;
        while (palavraOriginal[i] != '\0') {
            buffer[i] = palavraOriginal[i];
            i++;
        }
        buffer[i] = '\0';

        // aplica shift César
        i = 0;
        while (buffer[i] != '\0') {
            buffer[i] = buffer[i] + saltos;

            if (buffer[i] > 'z') {
                buffer[i] = buffer[i] - 26;
            }
            i++;
        }

        // busca substring (corrigida)
        int j = 0;
        int encontrou = 0;

        while (mensagem[j] != '\0') {

            int k = 0;

            while (mensagem[j + k] != '\0' &&
                   buffer[k] != '\0' &&
                   mensagem[j + k] == buffer[k]) {
                k++;
            }

            if (buffer[k] == '\0') {
                encontrou = 1;
                break;
            }

            j++;
        }

        if (encontrou) {
            break;
        }

        saltos++;
    }

    return saltos;
}