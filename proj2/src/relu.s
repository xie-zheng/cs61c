.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # If the length of the vector is less than 1,
    # this function terminates the program with error code 78.
    ble a1, x0, length_error     
    
    # t0: loop index
    mv t0, x0

loop_start:
    # i <= len?
	ble a1, t0, loop_end
    
    # load #th element
    slli t1, t0, 2 # get the byte shift
    add t1, t1, a0 # addr = head + shift
    lw t2, 0(t1)   # num  = 0(addr)
    
    # 0(addr) = num if num > 0 else 0
    bge s1, x0, loop_continue
	sw x0, 0(t1)

loop_continue:
	addi s0, s0, 1
    j loop_start

loop_end:
	ret


length_error:
    li a1, 78
    j exit2
    
