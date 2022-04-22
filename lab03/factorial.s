.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # n in a0
    # result in a0?
    addi a2, x0, 1     
loop:
    beq a0, x0, finish
    mul a2, a2, a0
    addi a0, a0, -1
    j loop
finish:
    addi a0, a2, 0
    jr ra