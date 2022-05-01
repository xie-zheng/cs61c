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
    # check error
    li t1, 1
    blt a2, t1, length_error
    blt a3, t1, stride_error
    blt a4, t1, stride_error

    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    # preloop
    mv s0, a0
    mv s1, a1
    slli s2, a3, 2 # stride in bytes
    slli s3, a4, 2 
    li s4, 0       # loop counter
    li a0, 0


loop_start:
    bge s4, a2, loop_end
    # get element from 2 array and multiplicate
    lw t0, 0(s0)
    lw t1, 0(s1)
    mul t0, t0, t1
    # add to result
    add a0, a0, t0
    # update counter and address
    addi s4, s4, 1
    add s0, s0, s2
    add s1, s1, s3
    
    j loop_start


loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    addi sp, sp, 24
    ret


length_error:
    li a1, 75
    j exit2


stride_error:
    li a1, 76
    j exit2