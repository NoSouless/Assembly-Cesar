.data
mensagem:  .string "Byá, zhaqb!\n"
mensagem2: .string "Bye"
msg_sucesso: .string "Encontrado!\n"
msg_falha:   .string "Não encontrado!\n"

.text
.globl main
main:
    # ponteiros iniciais
    la a0, mensagem       # a0 = ponteiro para mensagem
    la a1, mensagem2      # a1 = ponteiro para mensagem2
    li t2, 0              # flag = 0 (não encontrado)

loop_msg:
    lb t0, 0(a0)          # caractere atual de mensagem
    beq t0, zero, fim     # se fim da mensagem, acabou

    # salvar ponteiros para comparar
    mv t3, a0             # t3 percorre mensagem
    mv t4, a1             # t4 percorre mensagem2

loop_cmp:
    lb t0, 0(t3)          # caractere da mensagem
    lb t1, 0(t4)          # caractere da mensagem2

    beq t1, zero, achou   # se mensagem2 acabou, substring encontrada
    beq t0, zero, proximo # se mensagem acabou antes de mensagem2, próximo
    bne t0, t1, proximo   # se caracteres diferentes, próximo

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
