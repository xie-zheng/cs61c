.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    beq a0, zero, fopen_err
    # save parameters
    mv s1, a1
    mv s2, a2

    # open matrix file
    # a1: filename
    # a2: open_mode
    mv a1, a0
    li a2, 0     # 'r' for read
    jal fopen
    mv s0, a0    # s0: file descriptor
    # err handling
    li t0, -1
    beq a0, t0, fopen_err


    # read rows
    mv a1, s0
    mv a2, s1
    li a3, 4
    jal fread
    # err handling
    li t0, 4
    bne a0, t0, fread_err
    # read cols
    mv a1, s0
    mv a2, s2
    li a3, 4
    jal fread
    # err handling
    li t0, 4
    bne a0, t0, fread_err


    # allocating memory for matrix
    lw t0, 0(s1)    # read cols and rows from memory
    lw t1, 0(s2)
    # rows and columns validity check
    bge zero, t0, fread_err			# 0 >= t1 (invalid # of rows)
    bge zero, t1, fread_err			# 0 >= t2 (invalid # of cols)
    mul t0, t0, t1
    slli a0, t0, 2  # mul by 4 bytes
    mv s1, a0       # s1: size of matrix(bytes)
    jal malloc
    # err handling
    li t0, -1
    beq a0, t0, malloc_err
    mv s2, a0       # s2: start address of matrix


    # read matrix
    # a1: file descriptor
    # a2: address of matrix
    # a3  size in bytes
    mv a1, s0
    mv a2, s2
    mv a3, s1
    jal fread
    # err handling
    bne a0, s1, fread_err
    

    # close file
    mv a1, s0
    jal fclose
    # err handling
    li t0, -1
    beq a0, t0, fclose_err


    # return the address of matrix
    mv a0, s2
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 16
    ret


malloc_err:
    li a1, 88
    j exit2

fopen_err:
    li a1, 90
    j exit2

fread_err:
    li a1, 91
    j exit2
    
fclose_err:
    li a1, 92
    j exit2