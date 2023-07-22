# Name: Sean Shekhtman
# Utorid: 1008305371

.data
n:	.asciiz		"Enter a number: "
res:	.asciiz		"The result is: "

.text
.globl main

main:	# Implement recSq(n) by storing PC links to the stack! #
	li $v0, 4		# Prepare to print str      
	la $a0, n 		# $a0 = &(n)
	syscall    		# Print prompt n

	li $v0, 5		# Prepare to read int
	syscall 		# Read int
	move $t0, $v0		# $t0 = n
	
	addi $sp, $sp, -4	# Make room for n in stack
	sw $t0, 0($sp)		# Push n
	
	jal mystery		# Call mystery(n)
	move $t0, $v0		# Store the result in $t0 (originally n)
	
	li $v0, 4		# Prepare to read str
	la $a0, res		# $a0 = &(res)
	syscall			# printf("The result is: ");
	
	li $v0, 1		# Prepare to print int
	move $a0, $t0		# $a0 = n^2
	syscall			# printf("%d", $a0);
	
	li $v0, 10		# Exit Prog #
	syscall			# # # # # # #
	
mystery:# if n == 0, ret 0. o/w, ret mystery(n - 1) + (2n - 1) #
	# Note: According to this prog specification, n >= 0. #
	# The Plan: Load n AND cur $ra into stack. #
	
	lw $s0, 0($sp)		# Pop n
	addi $sp, $sp, 4	# Reclaim space
	
	bnez $s0, rec		# If n != 0, go to recursive case

base:	li $s0, 0		# n = 0
	addi $sp, $sp, -4	# Make space for n = 0 in stack
	sw $s0, 0($sp)		# Push n = 0
	
	jr $ra			# Return to main
	
rec:	li $s2, 2		# $s2 = 2 (This will be our factor of two for the remainder of the program)
	multu $s2, $s0		# Get 2n
	mflo $s1		# $s1 = 2n
	subi $s1, $s1, 1	# $s1 = 2n - 1
	
	subiu $s3, $s0, 1	# $s3 = (n - 1)
	
	addi $sp, $sp, -4	# Make space for (2n - 1) in stack
	sw $s1, 0($sp)		# Push (2n - 1) 
	
	addi $sp, $sp, -4	# Make room for $ra in stack
	sw $ra, 0($sp)		# Push $ra
	
	addi $sp, $sp, -4	# Make room for (n - 1) in stack
	sw $s3, 0($sp)		# Push (n - 1)
	
	jal mystery		# Call mystery(n-1)
	
	# Returning from recursive call here #
	lw $s4, 0($sp)		# $s4 = mystery(n-1); ($s4 accumulates)
	addi $sp, $sp, 4	# Reclaim space
	
	lw $ra, 0($sp)		# $ra = ($ra of prev function call)
	addi $sp, $sp, 4	# Reclaim space
	
	lw $v0, 0($sp)		# $v0 = 2n - 1 (from prev function call)
	addi $sp, $sp, 4	# Reclaim space
	
	addu $v0, $s4, $v0 	# $v0 = mystery(n-1) + (2n - 1)
	
	addi $sp, $sp, -4	# Make room for `res` in stack
	sw $v0, 0($sp)		# Push `res`
	
	jr $ra			# Return to caller
