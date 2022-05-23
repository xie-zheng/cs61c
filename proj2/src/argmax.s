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
    # err handling
    bge x0, a1, error
    
    #==============
    # brefore loop
    #==============
    # t1: loop index	
    # t2: value of the largest element
    # t3: index of the largest element
	mv t1, x0
    lw t2, 0(a0)
    mv t3, t1

loop_start:
    # t1 > vec.len()?
	bge t1, a1, loop_end
    
    slli t0, t1, 2       # byte shift
    add t0, t0, a0       # address of the next element
    lw t0, 0(t0)         # get the next element
    
    # vec.get(i) > max?
    ble t0, t2, loop_continue
    
    # set the new value and index of 'argmax'
    mv t2, t0
    mv t3, t1
    
loop_continue:
	addi t1, t1, 1
	j loop_start
    
loop_end:
    mv a0, t3  
    ret


error:
	li a1, 77
    j exit2
