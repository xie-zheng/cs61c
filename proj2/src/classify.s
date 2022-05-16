.globl classify

.data
new_line: .string "\n"

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)
    # a0 <= 4 ？ 
    li t0, 5
    bne t0, a0, args_err
    # s0: argc
    # s1: argv
    # s2: a2
    mv s0, a0
    mv s1, a1
    mv s2, a2


	# =====================================
    # LOAD MATRICES
    # =====================================
    # Load pretrained m0
    # malloc place for rows and cols
    # s3: m0.rows
    # s4: m0.cols
    li a0, 4
    jal malloc
    # err handling
    li t0, -1
    beq a0, t0, malloc_err
    mv s3, a0

    li a0, 4
    jal malloc
    # err handling
    li t0, -1
    beq a0, t0, malloc_err
    mv s4, a0

    lw a0, 4(s1)
    mv a1, s3
    mv a2, s4
    jal read_matrix
    mv s0, a0     # s0: addr(m0)
    lw s3, 0(s3)
    lw s4, 0(s4)


    # Load pretrained m1
    # s5: m1.rows
    # s6: m1.cols
    li a0, 4
    jal malloc
    # err handling
    li t0, -1
    beq a0, t0, malloc_err
    mv s5, a0

    li a0, 4
    jal malloc
    # err handling
    li t0, -1
    beq a0, t0, malloc_err
    mv s6, a0


    lw a0, 8(s1)
    mv a1, s5
    mv a2, s6
    jal read_matrix
    mv s7, a0     # s7: addr(m1)
    lw s5, 0(s5)
    lw s6, 0(s6)

    # Load input matrix
    li a0, 4
    jal malloc
    # err handling
    li t0, -1
    beq a0, t0, malloc_err

    mv s8, a0
    li a0, 4
    jal malloc
    # err handling
    li t0, -1
    beq a0, t0, malloc_err
    mv s9, a0

    lw a0, 12(s1)
    mv a1, s8
    mv a2, s9
    jal read_matrix
    mv s10, a0     # s10: addr(input)
    lw s8, 0(s8)
    lw s9, 0(s9)



    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # create new matrix
    mul t0, s3, s9
    slli a0, t0, 2
    jal malloc
    # err handling
    li t0, -1
    beq a0, t0, malloc_err

    # s11: start of d
    mv s11, a0
    
    # hidden_layer = matmul(m0, input)
    mv a0, s0
    mv a1, s3
    mv a2, s4
    mv a3, s10
    mv a4, s8
    mv a5, s9
    mv a6, s11
    jal matmul



    # relu(hidden_layer)
    mv a0, s11
    mul a1, s3, s9
    jal relu

    # overwrite the m0 that no use now
    mv a0, s0
    jal free
    mul t0, s5, s9
    slli a0, t0, 2
    # err handling
    jal malloc
    li t0, -1
    beq a0, t0, malloc_err
    # save infos
    mv s0, a0

    # scores = matmul(m1, hidden_layer)
    mv a0, s7
    mv a1, s5
    mv a2, s6
    mv a3, s11
    mv a4, s3
    mv a5, s9
    mv a6, s0
    jal matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    mv a1, s0
    mv a2, s5
    mv a3, s9
    jal write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s0
    mul a1, s5, s9
    jal argmax

    # Print classificatio
    mv a1, a0
    jal print_int

    # Print newline afterwards for clarity
    la a1, new_line
    jal print_str


end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52
    ret

args_err:
    li a1, 89
    j exit2


malloc_err:
    li a1, 88
    j exit2