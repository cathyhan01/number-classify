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
#   this function terminates the program with error code 112.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 113.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 114.
# ==============================================================================
write_matrix:
    # Prologue
	addi sp, sp, -24 # move stack pointer down
    sw ra, 0(sp) # save return address to stack
    sw s0, 4(sp) # save s-registers
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    
    # Save arguments into s-registers
    addi s0, a0, 0 # save pointer to filename into s0
    addi s1, a1, 0 # save pointer to start of matrix in memory into s1
    addi s2, a2, 0 # save num rows in matrix
    addi s3, a3, 0 # save num cols in matrix
    
    # Open the file with the given filename
    addi a1, s0, 0 # (load args) put pointer to filename string into a1 register
    addi a2, x0, 1 # (load args) file permissions: write = 1
    jal fopen
    addi s4, a0, 0 # (save return val) save file descriptor into s4
    
    # Check file open failure
    li t0, -1 # temporary -1
    beq s4, t0, fopen_err
    j write_rowcol_num # no file open failure
   	
    fopen_err:
    addi a1, x0, 112 # error code 112
    j exit2 # terminate program wih appropriate error code
    
    # Write row and col num to file
    write_rowcol_num:
    addi sp, sp -8 # move stack pointer down 8 bytes
    sw s2, 0(sp) # write to stack the num of rows (sp is going to be buffer pointer)
    sw s3, 4(sp) # write to stack the num of cols (sp is going to be buffer pointer)
    addi a1, s4, 0 # (load args) put file descriptor string pointer into a1 register
    addi a2, sp, 0 # (load args) put stack pointer(our buffer) into a2 register
    addi a3, x0, 2 # (load args) we writing 2 elements
    addi a4, x0, 4 # (load args) each element is 4 bytes
    jal fwrite # call fwrite
    addi sp, sp, 8 # move stack pointer back up
    
    # Check fwrite error or EOF
    li t0, 2 # temporary 2
    bne a0, t0, fwrite_err # num elements written to file != num elements we want to write
    j write_file # no fwrite error or EOF occurred
    
    fwrite_err:
    addi a1, x0, 113 # error code 113
    j exit2 # terminate program with appropriate error code
	
    # Write to our file
	write_file:
    addi a1, s4, 0 # (load args) put file descriptor into a1 register
    addi a2, s1, 0 # (load args) put buffer pointer into a2 register
    mul a3, s2, s3 # (load args) calculate total number of elements, put into a3 register
    addi a4, x0, 4 # (load args) each element in buffer is 4 bytes, put into a4 register
    jal fwrite # call fwrite
    
    # Check fwrite error or EOF
    mul t0, s2, s3 # temp = total num elements
    bne a0, t0, fwrite_err # num elements written to file != num elements we want to write
    # no fwrite error or EOF occurred
    
    # Close the file to save our writes
    close_file:
    addi a1, s4, 0 # (load args) put file descriptor into a1 register
    jal fclose # call fclose
    
    # Check fclose error
    li t0, -1 # temporary -1
    beq a0, t0, fclose_err # 0 == success, -1 == error
    j done # no fclose error
    
    fclose_err:
    addi a1, x0, 114 # error code 114
    j exit2 # terminate program with appropriate error code
	
    # At this point, saved writes successfully, no return args
    done:
    # Epilogue
    lw ra, 0(sp) # load saved return address to stack
    lw s0, 4(sp) # load saved s-registers
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24 # move stack pointer down
    
    ret
