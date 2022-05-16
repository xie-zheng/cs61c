.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:
    
    # Prologue
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)


    mv s1, a1
    mv s2, a2
    mv s3, a3
    # open the matrix file
    mv a1, a0
    li a2, 1  # 1 for 'w' mode
    jal fopen
    li t0, -1
    beq a0, t0, fopen_err1
    mv s0, a0 # s0: file descriptor


    # write rows
    addi sp, sp, -4
    sw s2, 0(sp)
    mv a1, s0
    mv a2, sp
    li a3, 1
    li a4, 4
    jal fwrite
    li t0, 1
    blt a0, t0, fwrite_err1
    # write cols
    sw s3, 0(sp)
    mv a1, s0
    mv a2, sp
    li a3, 1
    li a4, 4
    jal fwrite
    li t0, 1
    blt a0, t0, fwrite_err1
    addi sp, sp, 4


    # write matrix
    mv a1, s0
    mv a2, s1
    mul a3, s2, s3
    li a4, 4
    jal fwrite
    mul t0, s2, s3
    blt a0, t0, fwrite_err1


    # close file
    mv a1, s0
    jal fclose
    # err handling
    li t0, -1
    beq a0, t0, fclose_err1


    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    ret

fopen_err1:
    li a1, 93
    j exit2

fwrite_err1:
    mv a1, s0
    jal fflush
    li a1, 94
    j exit2

fclose_err1:
    li a1, 95
    j exit2