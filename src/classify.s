.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 121.
    # - If malloc fails, this function terminats the program with exit code 122.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Check if there are an incorrect num of command line args
    li t0, 5 # temporary 5
    blt a0, t0, argc_err # num args < 5: error
    j pro

    argc_err:
    addi a1, x0, 121 # error code 121
    j exit2 # terminate program with appropriate error code

    # Prologue
    pro:
    addi sp, sp, -52 # move stack pointer down
    sw ra, 0(sp) # save return address
    sw s0, 4(sp) # save s-register values
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

    # Save arguments passed into classify
    addi s0, a1, 0 # save argv
    addi s1, a2, 0 # save print_classification(if 0, print, else, do nothing)

	# =====================================
    # LOAD MATRICES
    # =====================================

    ############ Load pretrained m0

    # Call malloc twice to alloc space for pointer to num rows and pointer to num cols
    li a0, 4 # we want to alloc 4 bytes for num rows
    jal malloc # call malloc
    addi s2, a0, 0 # save pointer to the alloc'd heap memory

    # Check malloc failure
    beq s2, x0, malloc_err # pointer == 0(NULL)
    j m0_numcol_malloc # no row malloc failure

    malloc_err:
    addi a1, x0, 122 # error code 122
    j exit2 # terminate program with appropriate error code

    m0_numcol_malloc:
    li a0, 4 # we want to alloc 4 bytes for num cols
    jal malloc # call malloc
    addi s3, a0, 0 # save pointer to the alloc'd heap memory

    # Check malloc failure
    beq s3, x0, malloc_err # pointer == 0(NULL)
    # no malloc failures at all

    # Prepare to call read_matrix
	lw a0, 4(s0) # (load args) get M0_PATH string at index 1 of argv<<<<<<<<<<<
	addi a1, s2, 0 # (load args) put pointer to num rows into a1 register
    addi a2, s3, 0 # (load args) put pointer to num cols into a2 register
    jal read_matrix

    addi s4, a0, 0 # save pointer to matrix in memory

    lw s5, 0(s2) # temporarily load num rows into s5
    addi a0, s2, 0 # need to free memory in s2
    jal free
    addi s2, s5, 0 # put actual num rows into s2

    lw s5, 0(s3) # temporarily load num cols into s5
    addi a0, s3, 0 # need to free memory in s3
    jal free
    addi s3, s5, 0 # put actual num cols into s3
    
    ############ Load pretrained m1

    # Call malloc twice to alloc space for pointer to num rows and pointer to num cols
    li a0, 4 # we want to alloc 4 bytes for num rows
    jal malloc # call malloc
    addi s5, a0, 0 # save pointer to the alloc'd heap memory

    # Check malloc failure
    beq s5, x0, malloc_err # pointer == 0(NULL)
    j m1_numcol_malloc

    m1_numcol_malloc:
    li a0, 4 # we want to alloc 4 bytes for num cols
    jal malloc # call malloc
    addi s6, a0, 0 # save pointer to the alloc'd heap memory

    # Check malloc failure
    beq s6, x0, malloc_err # pointer == 0(NULL)
    # no malloc failures at all

    # Prepare to call read_matrix
	lw a0, 8(s0) # (load args) get M1_PATH string at index 2 of argv
	addi a1, s5, 0 # (load args) put pointer to num rows into a1 register
    addi a2, s6, 0 # (load args) put pointer to num cols into a2 register
    jal read_matrix

    addi s7, a0, 0 # save pointer to matrix in memory
    
    lw s8, 0(s5) # temporarily load num rows into s8
    addi a0, s5, 0 # need to free memory in s5
    jal free
    addi s5, s8, 0 # put actual num rows into s5
    
    lw s8, 0(s6) # temporarily load num cols into s8
    addi a0, s6, 0 # need to free memory in s6
    jal free
    addi s6, s8, 0 # put actual num cols into s6
    
    ############ Load input matrix

	# Call malloc twice to alloc space for pointer to num rows and pointer to num cols
    li a0, 4 # we want to alloc 4 bytes for num rows
    jal malloc # call malloc
    addi s8, a0, 0 # save pointer to the alloc'd heap memory

    # Check malloc failure
    beq s8, x0, malloc_err # pointer == 0(NULL)
    j input_numcol_malloc

    input_numcol_malloc:
    li a0, 4 # we want to alloc 4 bytes for num cols
    jal malloc # call malloc
    addi s9, a0, 0 # save pointer to the alloc'd heap memory

    # Check malloc failure
    beq s9, x0, malloc_err # pointer == 0(NULL)
    # no malloc failures at all

    # Prepare to call read_matrix
	lw a0, 12(s0) # (load args) get INPUT_PATH string at index 3 of argv
	addi a1, s8, 0 # (load args) put pointer to num rows into a1 register
    addi a2, s9, 0 # (load args) put pointer to num cols into a2 register
    jal read_matrix

    addi s10, a0, 0 # save pointer to matrix in memory

    lw s11, 0(s8) # temporarily load num rows into s11
    addi a0, s8, 0 # need to free memory in s8
    jal free
    addi s8, s11, 0 # put actual num rows into s8

    lw s11, 0(s9) # temporarily load num cols into s11
    addi a0, s9, 0 # need to free memory in s9
    jal free
    addi s9, s11, 0 # put actual num cols into s9
    
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # Call malloc to alloc space for output matrix
    mul t0, s2, s9 # calculate total num elements in output matrix(hidden_layer)
    slli t0, t0, 2 # multiply by 4 bytes each
    addi a0, t0, 0 # put # bytes into a0 register
    jal malloc # call malloc
    addi s11, a0, 0 # save pointer to output matrix into s11 register

    # Check malloc failure
    beq s11, x0, malloc_err # pointer == 0(NULL)

    # Prepare to call matmul on m0, input
    addi a0, s4, 0 # (load args) put pointer to m0 in a0
    addi a1, s2, 0 # (load args) put num rows of m0 in a1
    addi a2, s3, 0 # (load args) put num cols of m0 in a2
    addi a3, s10, 0 # (load args) put pointer to input in a3
    addi a4, s8, 0 # (load args) put num rows of input in a4
    addi a5, s9, 0 # (load args) put num cols of input in a5
    addi a6, s11, 0 # (load args) put pointer to output matrix(hidden_layer) in a6
    jal matmul # call matmul (inplace, result is in a6, s11)

    # Free m0 memory, input memory
    addi a0, s4, 0 # (load args) put m0 pointer in a0
    jal free # free memory alloc'd for m0
    addi a0, s10, 0 # (load args) put input pointer in a0
    jal free # free memory alloc'd for input

    # Prepare to call relu on resulting matrix (does this in-place)
    addi a0, s11, 0 # (load args) put hidden_layer pointer in a0
    mul a1, s2, s9 # put total num elements in hidden_layer in a1
    jal relu # call relu (inplace, result is in a0, s11)

    # Call malloc to alloc space for output matrix
    # need m1 num rows, hidden_layer num cols
    mul t0, s5, s9 # calculate total num elements in output matrix(scores)
    slli t0, t0, 2 # multiply by 4 bytes each
    addi a0, t0, 0 # put # bytes into a0 register
    jal malloc # call malloc
    addi s10, a0, 0 # save pointer to output matrix into s10 register

    # Check malloc failure
    beq s10, x0, malloc_err # pointer == 0(NULL)

    # Prepare to call matmul on m1, hidden_layer
    addi a0, s7, 0 # (load args) put pointer to m1 in a0
    addi a1, s5, 0 # (load args) put num rows of m1 in a1
    addi a2, s6, 0 # (load args) put num cols of m1 in a2
    addi a3, s11, 0 # (load args) put pointer to hidden_layer in a3
    addi a4, s2, 0 # (load args) put num rows of hidden_layer in a4
    addi a5, s9, 0 # (load args) put num cols of hidden_layer in a5
    addi a6, s10, 0 # (load args) put pointer to output matrix(scores) in a6
    jal matmul # call matmul (inplace, result is in a6, s10)

    # Free m1 memory, hidden_layer memory
    addi a0, s7, 0 # (load args) put m1 pointer in a0
    jal free # free memory alloc'd for m1
    addi a0, s11, 0 # (load args) put hidden_layer pointer in a0
    jal free # free memory alloc'd for hidden_layer

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

	# Prepare to call write_matrix
    lw a0, 16(s0) # (load args) get OUTPUT_PATH string at index 4 of argv
	addi a1, s10, 0 # (load args) put output vector(scores) pointer into a1 register
    addi a2, s5, 0 # (load args) put num rows of scores(=num rows of m1) into a2
    addi a3, s9, 0 # (load args) put num cols of scores(=num cols of input) into a3
	jal write_matrix # call write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================

    # Call argmax
	addi a0, s10, 0 # (load args) put pointer to scores into a0 register
    mul a1, s5, s9 # (load args) put total num elements of scores matrix into a1
	jal argmax # call argmax on scores
    addi s4, a0, 0 # save result of argmax(first index of largest element) into s10

    # Print classification (only print if s1 == 0)
    bne s1, x0, done
	addi a1, s4, 0 # (load args) put argmax result into a1 register
    jal print_int # print out argmax result

    # Print newline afterwards for clarity
	li a1 '\n' # (load args) put newline char into a1 register
    jal print_char # print out a newline

	done:
    # Free everything remaining (should just be the last copy of scores)
    addi a0, s10, 0 # (load args) put pointer to scores in a0
    jal free # free memory malloc'd in s4 for scores

    addi a0, s4, 0 # put classification back into return arg a0
    
    # Epilogue
    lw ra, 0(sp) # load saved return address
    lw s0, 4(sp) # load saved s-register values
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52 # move stack pointer back up

    ret
