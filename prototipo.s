.data
palavrapossivel:
    .string "gabriela\n"
criptografiaatual:
    .string ""
criptografado:
    .string "fzaqhdkz drsz drstczmcn\n"
senha:
    db 2

    .text
    .globl main
main:
    la t0, palavrapossivel   # t0 = endereço da palavra original
    la t1, criptografado     # t1 = endereço do buffer criptografado
    la t2, criptografiaatual

encrypt_loop:
    lb t3, 0(t0)             # t2 = próximo caractere
    beq t3, x0, done_encrypt # se for '\0', fim

    # se for letra minúscula
    addi t3, t3, 1           # soma 1 ao ASCII
    sb t3, 0(t2)             # armazena no buffer de saída

    addi t0, t0, 1           # avança na palavra original
    addi t2, t2, 1           # avança no buffer criptografado
    j encrypt_loop

done_encrypt:
    sb x0, 0(t2)             # termina string com '\0'

    # escrever no stdout (syscall 64)
    addi a0, x0, 1           # file descriptor 1 (stdout)
    la a1, criptografiaatual # endereço da string criptografada
    li a2, 9                 # comprimento (8 letras + '\n' se quiser)
    li a7, 64                # syscall write
    ecall
    
    j terminarscript
    
compararstring:
    
    
terminarscript:
    # sair do programa (syscall 93)
    addi a0, x0, 0           # código de saída 0
    li a7, 93                # syscall exit
    ecall
    
