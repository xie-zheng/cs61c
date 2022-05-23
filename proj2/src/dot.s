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
    blt a2, t1, length_error # vec.len() < 1
    blt a3, t1, stride_error # v0.stride < 1
    blt a4, t1, stride_error # v1.stride < 1
    
    slli a3, a3, 2  # a3: v0.stride in bytes
    slli a4, a4, 2  # a4: v1.stride in bytes

    li t0, 0        # t0: result(set to zero first)
    li t1, 0        # t1: loop index


loop_start:
    # i < len?
    bge t1, a2, loop_end
    
    # t0 = v0[i] * v1[i]
    lw t2, 0(a0)
    lw t3, 0(a1)
    mul t2, t2, t3

    add t0, t0, t2  # dot += t0
    
    addi t1, t1, 1  # i += 1
    add a0, a0, a3  # addr0 += stride0
    add a1, a1, a4  # addr1 += stride1
    j loop_start


loop_end:
    mv a0, t0
    ret


length_error:
    li a1, 75
    j exit2


stride_error:
    li a1, 76
    j exit2