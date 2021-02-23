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
#   this function terminates the program with error code 115.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -12 # move stack pointer down
    sw ra, 0(sp) # save return address
    sw s0, 4(sp) # save s-registers
    sw s1, 8(sp)

    add s0, a0, x0 # copy start pointer to array into s0
    add s1, a1, x0 # copy length of array into s1

    # check exception
    li t0, 0 # loop counter: int i = 0
    bgt s1, t0, loop_start # arr_length > 0: jump to loop_start

    # otherwise, arr_length <= 0: terminate program
    addi a1, x0, 115 # error code 115
    # Epilogue
	lw ra, 0(sp) # load saved return address
    lw s0, 4(sp) # load saved values back into s-registers
    lw s1, 8(sp)
    addi sp, sp, 12
    j exit2 # terminate, exit2 is in utils.s

loop_start:
	beq t0, s1, loop_end # Loop condition
    
    slli t1, t0, 2 # Calculate byte offset
    add a0, s0, t1 # Move array pointer to correct element based on offset

    lw t2, 0(a0) # load value of array element into t2
    bge t2, x0, loop_continue # val < 0: rectify
    addi t2, x0, 0 # change val to 0 to rectify (set negative to 0)
    sw t2, 0(a0) # put mutated val back into array element index

loop_continue:
	addi t0, t0, 1 # increment loop counter: i = i + 1
    j loop_start

loop_end:
	# Epilogue
	lw ra, 0(sp) # load saved return address
    lw s0, 4(sp) # load saved values back into s-registers
    lw s1, 8(sp)
    addi sp, sp, 12 # move stack pointer back up

	ret
