.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 125.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 126.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 127.
# =======================================================
matmul:
    # Error checks
    li t0, 1 # temporary 1
    blt a1, t0, m0_bad_dimensions # m0_rows < 1: 125 err
    blt a2, t0, m0_bad_dimensions # m0_cols < 1: 125 err
    blt a4, t0, m1_bad_dimensions # m1_rows < 1: 126 err
    blt a5, t0, m1_bad_dimensions # m1_cols < 1: 126 err
    bne a2, a4, incompatible # m0_cols != m1_rows: 127 err
    j pro # pass error checks
    
    m0_bad_dimensions:
    addi a1, x0, 125 # error code 126
    j done
    
    m1_bad_dimensions:
    addi a1, x0, 126 # error code 126
    j done
    
    incompatible:
    addi a1, x0, 127 # error code 127
    
    done:
    j exit2 # terminate program with appropriate error code

    # Prologue
    pro:
    addi sp, sp, -56 # move stack pointer down
    sw ra, 0(sp) # save return address
    sw s0, 4(sp) # save s-registers
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    
    add s0, a0, x0 # copy start pointer to m0 into s0 <-- this is an address
    add s1, a1, x0 # copy m0 # rows into s1
    add s2, a2, x0 # copy m0 # cols into s2
    add s7, a0, x0 # another copy of pointer ot m0 (this one won't change around)
    
    add s3, a3, x0 # copy start pointer to m1 into s3 <-- this is an address
    add s4, a4, x0 # copy m1 # rows into s4
    add s5, a5, x0 # copy m1 # cols into s5
    add s8, a3, x0 # another copy of pointer to m1 (this one won't change around)
    
    add s6, a6, x0 # copy start pointer to output matrix into s6
    add s9, a6, x0 # another copy of pointer to d (this one won't change around)
    
    li t0, 0 # initialize outer loop counter: int i = 0
    li t2, 0 # initialize matrix d element counter(row-major order): int k = 0

outer_loop_start:
	mul t3, s1, s2 # temporary: total num of elements in m0
	beq t0, t3, outer_loop_end
    li t1, 0 # initialize inner loop counter: int j = 0

inner_loop_start:
	beq t1, s5, inner_loop_end
    
    # Prepare to call dot.s
    
    # find and set start of v0 pointer, set its args
    slli t3, t0, 2 # Calculate byte offset to get appropriate row
    add s0, s7, t3 # move m0 pointer to start of v0
    add a0, s0, x0 # load address of v0 into a0
    add a2, s2, x0 # put length of v0 (m0_cols) into a2
    addi a3, x0, 1 # put stride of v0 into a3
    
    # find and set start of v1 pointer, set its args
    slli t3, t1, 2 # Calculate byte offset to get col's first element
    add s3, s8, t3 # move m1 pointer to start of v1
    add a1, s3, x0 # load address of v1 into a1
    addi a4, s5, 0 # put stride of v1 (m1_cols) into a4

	# before calling function, save registers(t0, t1, t2) -- dont care about t3
    sw t0, 44(sp)
    sw t1, 48(sp)
    sw t2, 52(sp)

	# arg registers all loaded up, time to calc dot product of v0 and v1
    jal dot # puts dot product scalar result into a0 register
    
    # after calling function, load back register values (t0, t1)
    lw t0, 44(sp)
    lw t1, 48(sp)
    lw t2, 52(sp)

	# put scalar result into appropriate location for d matrix
    slli t3, t2, 2 # Calculate byte offset
    add s6, s9, t3 # move d matrix pointer to right element based on offset
	sw a0, 0(s6) # save dot product result in a0 into d[k]

	# increment inner loop counter
    addi t1, t1, 1 # j = j + 1
    
    # increment matrix d element counter
    addi t2, t2, 1 # k = k + 1
    
    # continue inner loop iteration
    j inner_loop_start

inner_loop_end:
	# increment outer loop counter
    add t0, t0, s2 # i = i + m0_cols
    
    # continue outer loop iteration
    j outer_loop_start

outer_loop_end:
    # Epilogue
    lw ra, 0(sp) # load saved return address
    lw s0, 4(sp) # load saved values back into s-registers
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    addi sp, sp, 56 # move stack pointer back up
    
    ret
