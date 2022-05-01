.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    bge x0, a1, error
    # Prologue
	addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
	sw s3, 12(sp)
    sw s4, 16(sp)
    #	
	add s0, x0, x0
    lw s3, 0(a0)
    add s4, s0, x0

loop_start:
	bge s0, a1, loop_end
	
    slli s1, s0, 2
    add s2, s1, a0
    lw s1, 0(s2)
	
    ble s1, s3, loop_continue
    add s3, s1, x0
    add s4, s0, x0
    
loop_continue:
	addi s0, s0, 1
	j loop_start

error:
	li a1, 77
    j exit2
    
loop_end:
    
    mv a0, s4
    # Epilogue
   	lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
	lw s3, 12(sp)
    lw s4, 16(sp)
	addi, sp, sp, 20   
    ret
