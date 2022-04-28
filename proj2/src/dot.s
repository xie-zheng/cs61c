.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Prologue
    addi sp, sp, -4
    sw s0, 0(sp)

    # check error
    li t6, 1
    blt a2, t6, length_error
    blt a3, t6, stride_error
    blt a4, t6, stride_error

    mv t0, a0
    mv t1, a1
    slli t2, a3, 2 # stride in bytes
    slli t3, a4, 2
    li t4, 0 # counter
    li a0, 0


loop_start:
    bge t4, a2, loop_end
    # get element from 2 array
    lw t5, 0(t0)
    lw t6, 0(t1)
    # multiplicate
    mul s0, t5, t6
    # add to result
    add a0, a0, s0
    # update counter and address
    addi t4, t4, 1
    add t0, t0, t2
    add t1, t1, t3
    
    j loop_start

loop_end:
    lw s0, 0(sp)
    addi sp, sp, 4
    # Epilogue
    ret


length_error:
    li a0, 75
    # epilogue
    lw s0, 0(sp)
    addi sp, sp, 4
    ret


stride_error:
    li a0, 76
    # epilogue
    lw s0, 0(sp)
    addi sp, sp, 4
    ret