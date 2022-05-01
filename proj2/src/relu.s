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
	ble a1, x0, loop_error     
    # Prologue
	addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)

    mv s0, x0
    
loop_start:
	ble a1, s0, loop_end
    
    # load #th element
    slli s1, s0, 2 # get the byte shift
    add s2, a0, s1
    lw s1, 0(s2)
    
    bge s1, x0, loop_continue
	sw x0, 0(s2)

loop_continue:
	addi s0, s0, 1
    j loop_start



loop_end:
    # Epilogue
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
    addi sp, sp, 12
        
	ret
    
loop_error:
    li a1, 78
    j exit2
    
