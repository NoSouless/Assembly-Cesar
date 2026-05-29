.data
palavrapossivel:
    .string "beg"
criptografado:
    .string "beg\n"
msg_sucesso: 
    .string "Encontrado!\n"
msg_falha:   
    .string "Não encontrado!\n"
senha:
    .text
    .globl main
main:

    la a1, criptografado       # a1 = ponteiro para mensagem
    la a2, palavrapossivel     # a2 = mensagem após a criptografia
    la a3, palavrapossivel     # a3 = uma das palavras possiveis
    li t0, 0                   # t0 = Quantos saltos foram feitos para criptografar a palavra possivel
    li t1, 0                   # t1 = flag de encontrado (1) ou não encontrado (0)
    li t2, 25                  # t2 = maximo de possibilidades da cifra
    li t4, 0                   # t4 = tamanho de a1
    li t5, 0                   # t5 = tamanho de a2         
    li t6, 0                   # t6 = tamanho de a3
    
    j proxima_comparacao       # chamar a primeira função

proxima_comparacao:
    sub a1, a1, t4
    sub a2, a2, t5
    sub a3, a3, t6
    li t4, 0
    li t5, 0
    li t6, 0
    j compara_msg

compara_msg:
    
    lb s0, 0(a1)                          # caractere atual de mensagem
    beq s0, zero, proximacriptografia     # se fim da mensagem, acabou

    # salvar ponteiros para comparar
    mv s1, a1             # s1 percorre mensagem
    mv s2, a2             # s2 percorre mensagem
    j compara_caractere
    
compara_caractere:
    lb s0, 0(s1)          # caractere da mensagem
    lb s3, 0(s2)          # caractere da mensagem2

    beq s3, zero, achou   # se mensagem2 acabou, substring encontrada
    beq s0, zero, proximo # se mensagem acabou antes de mensagem2, próximo
    bne s0, s3, proximo   # se caracteres diferentes, próximo

    addi s1, s1, 1        # próximo caractere da mensagem
    addi s2, s2, 1        # próximo caractere da mensagem2
    j compara_caractere
    
proximo:
    addi a1, a1, 1        # avançar mensagem
    addi t4, t4, 1
    j compara_msg

proximacriptografia:
    addi t0, t0, 1               # adiciona 1 salto
    beq t0, t2, fim               # se o maximo de possibilidades estourar, acaba o script

    sub a1, a1, t4
    sub a2, a2, t5
    sub a3, a3, t6
    li t4, 0
    li t5, 0
    li t6, 0

    j criptografar_msg           # começa a criptografia
    
criptografar_msg:
    #j nao_encontrado
    lb s4, 0(a3)             # s4 = proximo caractere da palavra possivel
    beq s4, x0, proxima_comparacao  # acabar a cryptografia se a ultima letra for \0

    addi s4, s4, 1           # soma a quantidade de saltos a ao valor ASCII da letra atual da palavra possivel
    sb s4, 0(a2)             # armazena a letra atual à criptografiaatual

    addi a3, a3, 1           # avança na palavra original
    addi a1, a1, 1           # avança no buffer criptografado
    j criptografar_msg
    
achou:
    mv a0, t0
    li a7, 1              # syscall imprimir string
    ecall
    li t1, 1              # substring encontrada
    j fim
    
fim:
    # imprimir mensagem de sucesso ou falha
    beq t1, zero, nao_encontrado
    la a0, msg_sucesso
    li a7, 4              # syscall imprimir string
    ecall
    j sair
    
nao_encontrado:
    la a0, msg_falha
    li a7, 4              # syscall imprimir string
    ecall
    j sair
    
sair:
    li a7, 93             # syscall exit
    ecall
    
    
    
