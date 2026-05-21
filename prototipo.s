.data
palavrapossivel:
    .string "fzaqhdkz"
criptografado:
    .string "fzaqhdkz drsz drstczmcn\n"
msg_sucesso: 
    .string "Encontrado!\n"
msg_falha:   
    .string "Não encontrado!\n"
senha:
    .text
    .globl main
main:

    la a0, criptografado       # a0 = ponteiro para mensagem
    la a1, palavrapossivel     # a1 = mensagem após a criptografia
    la a2, palavrapossivel     # a2 = uma das palavras possiveis
    li t1, 0                   # t1 = Quantos saltos foram feitos para criptografar a palavra possivel
    li t2, 0                   # t2 = flag de encontrado (1) ou não encontrado (0)
    li t5, 25                  # t5 = maximo de possibilidades da cifra
    j compara_msg              # chamar a primeira função
    
compara_msg:
    lb t0, 0(a0)          # caractere atual de mensagem
    beq t0, zero, criptografar_msg     # se fim da mensagem, acabou

    # salvar ponteiros para comparar
    mv t3, a0             # t3 percorre mensagem
    mv t4, a1             # t4 percorre mensagem
    j compara_caractere
    
compara_caractere:
    lb t0, 0(t3)          # caractere da mensagem
    lb t1, 0(t4)          # caractere da mensagem2

    beq t1, zero, achou   # se mensagem2 acabou, substring encontrada
    beq t0, zero, proximo # se mensagem acabou antes de mensagem2, próximo
    bne t0, t1, proximo   # se caracteres diferentes, próximo

    addi t3, t3, 1        # próximo caractere da mensagem
    addi t4, t4, 1        # próximo caractere da mensagem2
    j compara_caractere

achou:
    li t2, 1              # substring encontrada
    j fim
    
fim:
    # imprimir mensagem de sucesso ou falha
    beq t2, zero, nao_encontrado
    la a0, msg_sucesso
    li a7, 4              # syscall imprimir string
    ecall
    j sair
    
nao_encontrado:
    la a0, msg_falha
    li a7, 4              # syscall imprimir string
    ecall
    
sair:
    li a7, 10             # syscall exit
    ecall
    
proximo:
    addi a0, a0, 1        # avançar mensagem
    j compara_msg

criptografar_msg:
    lb t6, 0(a2)             # t3 = proximo caractere da palavra possivel
    beq t6, x0, compara_msg  # acabar a cryptografia se a ultima letra for \0

    addi t6, t6, 1           # soma a quantidade de saltos a ao valor ASCII da letra atual da palavra possivel
    sb t6, 0(a1)             # armazena a letra atual à criptografiaatual

    addi a2, a2, 1           # avança na palavra original
    addi a1, a1, 1           # avança no buffer criptografado
    j criptografar_msg

proximacriptografia:
    addi t1, t1, 1               # adiciona 1 salto
    beq t1, t5, nao_encontrado   # se o maximo de possibilidades estourar, acaba o script
    j criptografar_msg           # começa a criptografia
    
    
    

