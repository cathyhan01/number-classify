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
#   this function terminates the program with error code 116.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 117.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 118.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 119.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -32 # move stack pointer down
    sw ra, 0(sp) # save return address to stack
    sw s0, 4(sp) # save s-registers
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    
    # Save arguments into s-registers
    addi s0, a0, 0 # save filename string into s0
    addi s1, a1, 0 # save pointer to an int, num rows
    addi s2, a2, 0 # save pointer to an int, num cols
    
    # Open the file with the given filename
    addi a1, s0, 0 # (load args) put pointer to filename string into a1 register
	addi a2, x0, 0 # (load args) file permissions: read = 0
	jal fopen
    addi s3, a0, 0 # (save return val) save file descriptor into s3
    
    # Check file open failure
    li t0, -1 # temporary -1
    beq s3, t0, fopen_err # file descriptor == -1
    j malloc_mem
    
    # file open error
    fopen_err:
    addi a1, x0, 117 # error code 117
    j exit2 # terminate program with appropriate error code
    
    # Call malloc to alloc space to create a buffer which is going into a2 to read file
    malloc_mem:
    addi a0, x0, 8 # (load args) we need 8 bytes to read row and col #s
	jal malloc # call malloc
    addi s4, a0, 0 # save pointer to the alloc'd heap memory into s4
    
    # Check malloc failure
    beq s4, x0, malloc_err # pointer == 0 (NULL)
    j read_file
    
    # malloc error
    malloc_err:
    addi a1, x0, 116 # error code 116
    j exit2 # terminate program with appropriate error code
	
    # Read the first 8 bytes of the file (to get dimensions)
    read_file:
	addi a1, s3, 0 # (load args) put file descriptor into a1 register
    addi a2, s4, 0 # (load args) put pointer to read buffer into a2 register
    addi a3, x0, 8 # (load args) we're going to read 8 bytes from the file
	jal fread # call fread to read file, return a0=#bytes actually read
    
    # check fread error or EOF
	li t0, 8 # we should have read 8 bytes from the file
    bne a0, t0, fread_err # num bytes read != 8 bytes: error occurred
    j process_dimensions
    
    # fread error(EOF reached or other error)
    fread_err:
    addi a1, x0, 118 # error code 118
    j exit2 # terminate program with appropriate error code
    
    # Process the 8 bytes we just read: save num rows, cols, and calc total num elements
    process_dimensions:
    lw s1, 0(s4) # load the first 4 bytes of the buffer into s1 (m = num rows)
    lw s2, 4(s4) # load the next 4 bytes of the buffer into s2 (n = num cols)
    mul s5, s1, s2 # calculate total number of elements in matrix (r = m*n elements)
    slli s5, s5, 2 # logical left shift r to multiply by 4 bytes (total num bytes for matrix)
    
    # Call malloc to alloc enough space for whole matrix containing r=m*n elements
    addi a0, s5, 0 # (load args) we want r*4 bytes, put into a0 register
    jal malloc # call malloc
    addi s6, a0, 0 # save pointer to memory space for matrix
    
    # Check malloc failure
    beq s6, x0, malloc_err # pointer == 0 (NULL)
    # no malloc failure here
    
    # Read the rest of the file to get matrix values
    addi a1, s3, 0 # (load args) put file descriptor into a1 register
    addi a2, s6, 0 # (load args) put pointer to read buffer into a2 register
    addi a3, s5, 0 # (load args) we're going to read r*4 bytes from the file
    jal fread # call fread to read file, return a0=#bytes actually read
    
    # check fread error or EOF
    bne a0, s5, fread_err # we should have read r*4 bytes from the file
    # no fread error or EOF here
    
    # Done reading, call fclose to close the file we've read from
    addi a1, s3, 0 # (load args) put file descriptor into a1 register
    jal fclose # call fclose
    
    # Check fclose error
    li t0, -1 # temporary -1
    beq a0, t0, fclose_err # 0 == success, -1 == error
    j done # no fclose error
    
    fclose_err:
    addi a1, x0, 119 # error code 119
    j exit2 # terminate program with appropriate error code
    
    # So at this point, all r-elements of the matrix should be in the buffer we malloc'd
    done:
    add a0, s6, x0 # put pointer to matrix into return arg register
    add a1, s1, x0 # put num rows back into a1 register
    add a2, s2, x0 # put num cols back into a2 register
    
    # Epilogue
    lw ra, 0(sp) # load saved return address from stack
    lw s0, 4(sp) # load saved s-registers
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32 # move stack pointer back up
    
    ret
