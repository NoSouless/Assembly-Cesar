.data
palavrapossivel:
    .string "gabriela\n"
criptografiaatual:
    .string ""
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
    la a1, criptografiaatual
    la a2, palavrapossivel
    li t1, 0              # índice para criptografiaatual
    li t2, 0              # flag = 0 (não encontrado)

encrypt_loop:
    lb t3, 0(a2)             # t2 = próximo caractere
    beq t3, x0, done_encrypt # se for '\0', fim

    # se for letra minúscula
    addi t3, t3, 1           # soma 1 ao ASCII
    sb t3, 0(a1)             # armazena no buffer de saída

    addi a2, a2, 1           # avança na palavra original
    addi a1, a1, 1           # avança no buffer criptografado
    j encrypt_loop

done_encrypt:
    sb x0, 0(a1)             # termina string com '\0'

    # escrever no stdout (syscall 64)
    addi a0, x0, 1           # file descriptor 1 (stdout)
    la a1, criptografiaatual # endereço da string criptografada
    li a2, 9                 # comprimento (8 letras + '\n' se quiser)
    li a7, 64                # syscall write
    ecall
    
    j terminarscript
    
    
terminarscript:
    # sair do programa (syscall 93)
    addi a0, x0, 0           # código de saída 0
    li a7, 93                # syscall exit
    ecall
    





loop_msg:
    lb t0, 0(a0)          # caractere atual de mensagem
    beq t0, zero, fim     # se fim da mensagem, acabou

    # salvar ponteiros para comparar
    mv t3, a0             # t3 percorre mensagem
    mv t4, a1             # t4 percorre mensagem2

loop_cmp:
    lb t0, 0(t3)          # caractere da mensagem
    lb a0, 0(t4)          # caractere da mensagem2

    beq a0, zero, achou   # se mensagem2 acabou, substring encontrada
    beq t0, zero, proximo # se mensagem acabou antes de mensagem2, próximo
    bne t0, a0, proximo   # se caracteres diferentes, próximo

    addi t3, t3, 1        # próximo caractere da mensagem
    addi t4, t4, 1        # próximo caractere da mensagem2
    j loop_cmp

proximo:
    addi a0, a0, 1        # avançar mensagem
    j loop_msg

achou:
    li t2, 1              # substring encontrada

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
