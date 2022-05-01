.globl matmul
#.import dot.s
#.import utils.s
.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================

# ======================================
# MISTAKES
#
# 1. rely on t register!
#   dot function use t register too, make all results wrong! 
#   MAKE SURE that t register only store disposable value
#
# 2. write 0(s0) in prologue
#   typo matters
# ======================================
matmul:
    # Error checks(check the matrix size)
    li t1, 1
    blt a1, t1, m0_error
    blt a2, t1, m0_error
    blt a4, t1, m1_error
    blt a5, t1, m1_error
    bne a2, a4, match_error
    # Prologue
    addi sp, sp, -52
    sw ra, 48(sp)
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    # a0-a4 will be use to call the `dot` function
    mv s0, a0 # use s0 for m0 row start
    mv s1, a1
    mv s2, a2
    mv s3, a3 # use s3 for m1 start
    mv s11, a3 # origin copy for inner_loop
    mv s4, a4
    mv s5, a5
    mv s6, a6
    # pre-loop
    li s7, 0 # i
    li s8, 0 # j
    slli s9, s2, 2  # byte move for matrix0
    slli s10, t1, 2 # 4

outer_loop_start:
    bge s7, s1, outer_loop_end
    # get the start of row to a0
    jal inner_loop_start
    # move to next row 
    addi s7, s7, 1 # index
    add s0, s0, s9
    j outer_loop_start


inner_loop_start:
    bge s8, s5, inner_loop_end
    # prepare args for dot
    mv a0, s0
    mv a1, s3
    mv a2, s2
    li a3, 1
    mv a4, s5
    # call dot and store the result to destination
    addi sp, sp, -4
    sw ra, 0(sp)
    jal dot
    lw ra, 0(sp)
    addi sp, sp, 4
    sw a0, 0(s6)
    # move to next col
    addi s8, s8, 1
    addi s3, s3, 4
    addi s6, s6, 4

    j inner_loop_start


inner_loop_end:
    # jump back to first col
    # set address to origin and j to 0
    mv s3, s11 # addr
    li s8, 0  # j
    # return to outer_loop
    ret

outer_loop_end:
    # Epilogue
    lw ra, 48(sp)
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)   
    lw s11, 44(sp)
    addi sp, sp, 52
    ret


m0_error:
    li a1, 72
    j exit2

m1_error:
    li a1, 73
    j exit2

match_error:
    li a1, 74
    j exit2

