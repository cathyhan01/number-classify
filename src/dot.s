.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 123.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 124.
# =======================================================
dot:
    # Prologue
    addi sp, sp, -44 # move stack pointer down
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

    add s0, a0, x0 # copy start pointer to v0 into s0
    add s1, a1, x0 # copy start pointer to v1 into s1
    add s2, a2, x0 # copy length of vectors into s2
    add s3, a3, x0 # copy v0's stride into s3
    add s4, a4, x0 # copy v1's stride into s4

    # Tracking stuff
    li t0, 0 # index counter for v0: int i = 0
    li t1, 0 # index counter for v1: int j = 0
    li t2, 0 # dot product
    li t3, 1 # temporary 1

    # Check exceptions
    blt s2, t3, length_exception # vector length < 1: throw length exception
    blt s3, t3, stride_exception # v0_stride < 1: throw stride exception
    blt s4, t3, stride_exception # v1_stride < 1: throw stride exception

    # Pass all exceptions, then do looping work
    j loop_start

    length_exception:
    addi a1, x0, 123 # error code 123
    j epi

    stride_exception:
    addi a1, x0, 124 # error code 124

    epi: # Epilogue
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
    addi sp, sp, 44 # move stack pointer back up
    j exit2 # terminate program with appropriate error code

loop_start:
	beq a2, x0, loop_end # len = 0, stop looping

	slli t3, t0, 2 # Calculate byte offset for v0: logical shift left by 2
    mul t3, t3, s3 # multiple offset by v0 stride, t3 = v0 offset
    add a0, s0, t3 # move v0 pointer to correct element based on offset
    lw t3, 0(a0) # load value of current v0 element into t4

    slli t4, t1, 2 # Calculate byte offset for v1: logical shift left by 2
    mul t4, t4, s4 # multiple offset by v1 stride, t3 = v1 offset now
    add a1, s1, t4 # move v1 pointer to correct element based on offset
    lw t4, 0(a1) # load value of current v1 element into t4

	mul t5, t3, t4 # temp_mul = v0_element * v1_element
    add t2, t2, t5 # dot_prod += temp_mul

    addi t0, t0, 1 # increment index for v0 by its stride
    addi t1, t1, 1 # increment index for v1 by its stride
	addi a2, a2, -1 # decrement length variable
    j loop_start # continue looping

loop_end:
	# Put dot product result back into a0 return arg
    addi a0, t2, 0

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
    addi sp, sp, 44 # move stack pointer back up

    ret
