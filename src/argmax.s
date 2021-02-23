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
#   this function terminates the program with error code 120.
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -12 # move stack pointer down
    sw ra, 0(sp) # save return address
    sw s0, 4(sp) # save s-registers
    sw s1, 8(sp)

    add s0, a0, x0 # copy start pointer to array into s0
    add s1, a1, x0 # copy length of array into s1
	
    # tracking stuff
	li t0, 0 # loop counter: int i = 0
    li t1, 0 # keep track of largest element's index
    li t2, -9999 # keep track of largest element value

    # check exception
    bgt s1, t0, loop_start # arr_length > 0: jump to loop_start

    # otherwise, arr_length <= 0: terminate program
    addi a1, x0, 120 # error code 120
    
    # Epilogue
    lw ra, 0(sp) # load saved return address
    lw s0, 4(sp) # load saved values back into s-registers
    lw s1, 8(sp)
    addi sp, sp, 12
    j exit2 # terminate, exit2 is in utils.s

loop_start:
	beq t0, s1, loop_end # Loop condition
    
    slli t3, t0, 2 # Calculate byte offset
    add a0, s0, t3 # move array pointer to correct element based on offset

    lw t4, 0(a0) # load value of current array element into t4
    blt t4, t2, loop_continue # current_val < max_val: continue loop

    # Otherwise, check if equals since we want smallest index
    beq t4, t2, loop_continue

    # Otherwise, update max index and update max val
    addi t1, t0, 0 # t0 is current index, t1 is max element's index
    addi t2, t4, 0 # t2 is max element val, t4 is current val

loop_continue:
	addi t0, t0, 1 # increment loop counter: i = i + 1
    j loop_start

loop_end:
	# Done looping, put max index back into a0 return arg
    addi a0, t1, 0

    # Epilogue
    lw ra, 0(sp) # load saved return address
    lw s0, 4(sp) # load saved values back into s-registers
    lw s1, 8(sp)
    addi sp, sp, 12 # move stack pointer back up

    ret
