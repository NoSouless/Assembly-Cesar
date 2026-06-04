.data
palavrapossivel:
    .string "cifra"
criptografado:
    .string "mspbk no mockb\n"
msg_sucesso: 
    .string "Encontrado!\n"
msg_falha:   
    .string "Não encontrado!\n"
msg_saltos:
    .string "Saltos "
msg_dois_pontos:
    .string ": "
msg_quebra:
    .string "\n"
    
.text
.globl main
main:

    la a1, criptografado                    # a1 = ponteiro para mensagem
    mv s5, a1                               # s5 = inicio da mensagem criptografada
    la a2, palavrapossivel                  # a2 = mensagem após a criptografia
    la a3, palavrapossivel                  # a3 = uma das palavras possiveis
    li t0, 0                                # t0 = Quantos saltos foram feitos para criptografar a palavra possivel
    li t1, 0                                # t1 = flag de encontrado (1) ou não encontrado (0)
    li t2, 26                               # t2 = maximo de possibilidades da cifra
    li t4, 0                                # t4 = tamanho de a1
    li t5, 0                                # t5 = tamanho de a2         
    li t6, 0                                # t6 = tamanho de a3
    
    j proxima_comparacao                    # começa a comparação da mensagem criptografada com a palavra possivel atual

proxima_comparacao: 
    sub a1, a1, t4                          # volta o ponteiro de a1 (mensagem criptografada) para o inicio da mensagem
    sub a2, a2, t5                          # volta o ponteiro de a2 (mensagem após criptografia) para o inicio da mensagem
    sub a3, a3, t6                          # volta o ponteiro de a3 (palavra possivel) para o inicio da palavra possivel
    li t4, 0                                # reseta o tamanho de a1
    li t5, 0                                # reseta o tamanho de a2
    li t6, 0                                # reseta o tamanho de a3
    j compara_msg                           # compara a mensagem criptografada com a palavra possivel atual

compara_msg:
    
    lb s0, 0(a1)                            # caractere atual de mensagem
    beq s0, zero, proximacriptografia       # se fim da mensagem, acabou

    # salvar ponteiros para comparar
    mv s1, a1                               # s1 percorre mensagem
    mv s2, a2                               # s2 percorre mensagem
    j compara_caractere                     # compara caractere a caractere a mensagem criptografada com a palavra possivel atual
    
compara_caractere:
    lb s0, 0(s1)                            # caractere da mensagem
    lb s3, 0(s2)                            # caractere da mensagem2

    beq s3, zero, achou                     # se mensagem2 acabou, substring encontrada
    beq s0, zero, proximo                   # se mensagem acabou antes de mensagem2, próximo
    bne s0, s3, proximo                     # se caracteres diferentes, próximo

    addi s1, s1, 1                          # próximo caractere da mensagem
    addi s2, s2, 1                          # próximo caractere da mensagem2
    j compara_caractere
    
proximo:
    addi a1, a1, 1                          # avançar mensagem
    addi t4, t4, 1                          # conta quantos caracteres foram lidos da mensagem
    j compara_msg

proximacriptografia:
    addi t0, t0, 1                          # adiciona 1 salto
    beq t0, t2, fim                         # se o maximo de possibilidades estourar, acaba o script

    sub a1, a1, t4                          # volta o ponteiro de a1 (mensagem criptografada) para o inicio da mensagem
    sub a2, a2, t5                          # volta o ponteiro de a2 (mensagem após criptografia) para o inicio da mensagem
    sub a3, a3, t6                          # volta o ponteiro de a3 (palavra possivel) para o inicio da palavra possivel
    li t4, 0                                # reseta o tamanho de a1
    li t5, 0                                # reseta o tamanho de a2
    li t6, 0                                # reseta o tamanho de a3

    j criptografar_msg                      # começa a criptografia
    
criptografar_msg:
    #j nao_encontrado
    lb s4, 0(a3)                            # s4 = proximo caractere da palavra possivel
    beq s4, x0, fim_criptografia            # acabar a cryptografia se a ultima letra for \0

    addi s4, s4, 1                          # soma 1 no valor ASCII da letra atual
    li t3, 123                              # 'z' + 1, se passar disso, volta para 'a'
    blt s4, t3, escreve_char                # se ainda estiver no alfabeto, escreve
    addi s4, s4, -26                        # se passou de 'z', volta para 'a'

escreve_char:
    sb s4, 0(a2)                            # armazena a letra atual à criptografiaatual
    addi a3, a3, 1                          # avança na palavra original
    addi a2, a2, 1                          # avança no buffer criptografado
    addi t5, t5, 1                          # conta quantos caracteres foram criptografados
    addi t6, t6, 1                          # conta quantos caracteres foram lidos da palavra original
    j criptografar_msg

fim_criptografia:
    sb x0, 0(a2)                            # encerra a string criptografada
    la a0, msg_saltos                       # prepara para imprimir quantos saltos foram feitos
    li a7, 4                                # syscall imprimir string
    ecall                                   # imprime "Saltos "

    mv a0, t0                               # prepara para imprimir o numero de saltos
    li a7, 1                                # syscall imprimir inteiro
    ecall                                   # imprime o numero de saltos

    la a0, msg_dois_pontos                  # prepara para imprimir ": "
    li a7, 4                                # syscall imprimir string
    ecall                                   # imprime ": "

    mv a0, a2                               # prepara para voltar ao inicio do texto criptografado
    sub a0, a0, t5                          # volta o ponteiro de a0 para o inicio do texto criptografado
    li a7, 4                                # syscall imprimir string
    ecall                                   # imprime o texto criptografado
    la a0, msg_quebra                       # prepara para imprimir quebra de linha
    li a7, 4                                # syscall imprimir string
    ecall                                   # imprime quebra de linha
    j proxima_comparacao                    # compara o texto criptografado com a frase
    
achou:
    li t1, 1                                # substring encontrada
    j fim                                   # vai para o fim para imprimir mensagem de sucesso e descriptografar a mensagem
    
fim:
    # imprimir mensagem de sucesso ou falha
    beq t1, zero, nao_encontrado            # se não encontrou, imprime mensagem de falha
    mv a0, t0                               # prepara para imprimir o numero de saltos
    li a7, 1                                # syscall imprimir inteiro
    ecall                                   # imprime o numero de saltos
    la a0, msg_quebra                       # prepara para imprimir quebra de linha
    li a7, 4                                # syscall imprimir string
    ecall                                   # imprime quebra de linha

    mv t3, s5                               # t3 percorre a mensagem criptografada para descriptografar

descriptografar_msg:
    lb s4, 0(t3)                            # caractere atual
    beq s4, zero, imprimir_descriptografada # se fim da mensagem, imprime a mensagem descriptografada

    li t4, 97                               # 'a'
    blt s4, t4, prox_char_descriptografada  # se não for letra, mantém o mesmo caractere

    li t5, 123                              # 'z' + 1
    bge s4, t5, prox_char_descriptografada  # se não for letra, mantém o mesmo caractere

    sub s4, s4, t0                          # desfaz o deslocamento da cifra
    blt s4, t4, ajusta_descriptografia      # se passou de 'a', volta para 'z'

salva_descriptografada:
    sb s4, 0(t3)                            # armazena o caractere descriptografado

prox_char_descriptografada:
    addi t3, t3, 1                          # próximo caractere
    j descriptografar_msg                   # volta para descriptografar o próximo caractere

ajusta_descriptografia:
    addi s4, s4, 26                         # se passou de 'a', volta para 'z'  
    j salva_descriptografada                # salva o caractere descriptografado

imprimir_descriptografada:
    mv a0, s5                               # prepara para imprimir o inicio da mensagem descriptografada
    li a7, 4                                # syscall imprimir string
    ecall                                   # imprime a mensagem descriptografada
    la a0, msg_sucesso                      # prepara para imprimir mensagem de sucesso
    li a7, 4                                # syscall imprimir string
    ecall                                   # imprime mensagem de sucesso
    j sair                                  # sai do programa
    
nao_encontrado:
    la a0, msg_falha                        # prepara para imprimir mensagem de falha
    li a7, 4                                # syscall imprimir string
    ecall                                   # imprime mensagem de falha
    j sair                                  # sai do programa
    
sair:
    li a7, 93                               # syscall exit
    ecall                                   # sai do programa
    
    
    
