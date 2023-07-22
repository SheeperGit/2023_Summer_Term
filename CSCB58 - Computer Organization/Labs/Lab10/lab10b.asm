# Name: Sean Shekhtman
# Utorid: 1008305371

.data
A:	.asciiz		"Enter A: "
B:	.asciiz		"Enter B: "
C:	.asciiz		"Enter C: "
newln:	.asciiz		"\n"

bfFunc:	.asciiz		"Before function"
addABC:	.asciiz		"A + B + C = "
numSol:	.asciiz		"n_solutions(A, B, C) = "

.text
.globl main

main:	# int do_addition(A, B, C) {return A + B + C;}		  ###	USE REGISTER METHOD ($a0-$a3) ###
	# int n_solutions(A, B, C) {return [num_of_solutions];}   ###	  USE STACK METHOD    ($sp)   ###
	
	# $t0 = A      #
	# $t1 = B      #
	# $t2 = C      #
	# $t9 = retval #

	li $v0, 4		# Prepare to print str      
	la $a0, A 		# $a0 = &(A)
	syscall    		# Print prompt A

	li $v0, 5		# Prepare to read int
	syscall 		# Read int
	move $t0, $v0		# $t0 = A
	

	li $v0, 4		# Prepare to print str      
	la $a0, B		# $a0 = &(B)
	syscall    		# Print prompt B

	li $v0, 5		# Prepare to read int
	syscall 		# Read int
	move $t1, $v0		# $t1 = B
	
	
	li $v0, 4		# Prepare to print str      
	la $a0, C		# $a0 = &(C)
	syscall    		# Print prompt C

	li $v0, 5		# Prepare to read int
	syscall 		# Read int
	move $t2, $v0		# $t2 = C
	
	li $v0, 4		# Prepare to print str
	la $a0, newln		# $a0 = &(newln)
	syscall			# printf("\n");
	
	li $v0, 4		# Prepare to print str
	la $a0, bfFunc		# $a0 = &(bfFunc)
	syscall			# printf("Before function");
	
	li $v0, 4		# Prepare to print str
	la $a0, newln		# $a0 = &(newln)
	syscall			# printf("\n");
	
	add $a0, $zero, $t0	# First input arg,  A
	add $a1, $zero, $t1	# Second input arg, B
	add $a2, $zero, $t2	# Third input arg,  C
	
	
	jal do_addition		# Let's hop over to do_addition! (Sets $ra to cur PC + 4)
	
	move $t9, $v0		# $t9 = do_addition(A, B, C);
	
	li $v0, 4		# Prepare to print str      
	la $a0, addABC		# $a0 = &(addABC)
	syscall    		# Print prompt addABC
	
	li $v0, 1
	move $a0, $t9
	syscall
	
	li $v0, 4		# Prepare to print str
	la $a0, newln		# $a0 = &(newln)
	syscall			# printf("\n");
	
	###################################################################################
	
	addi $sp, $sp, -4	# Make room for A in stack
	sw $t0, 0($sp)		# Push A
	
	addi $sp, $sp, -4	# Make room for B in stack
	sw $t1, 0($sp)		# Push B
	
	addi $sp, $sp, -4	# Make room for C in stack
	sw $t2, 0($sp)		# Push C
	
	jal n_solutions		# Let's hop over to n_solutions! (Sets $ra to cur PC + 4)
	
	move $t9, $v0		# $t9 = n_solutions(A, B, C);
	
	li $v0, 4		# Prepare to print str      
	la $a0, numSol		# $a0 = &(numSol)
	syscall    		# Print prompt numSol
	
	li $v0, 1		# Prepare to print int
	move $a0, $t9		# $a0 = num_of_sols
	syscall			# printf("num_of_sols");

	li $v0, 10		# Exit Prog #
	syscall			#	    #
	
	
do_addition:	# Want: $v0 = A + B + C #
	add $t3, $a0, $a1	# $t3 = A + B
	add $v0, $t3, $a2	# $v0 = (A + B) + C
	
	jr $ra
	
n_solutions:	# Want: $v0 = num_of_solutions in Ax^2 + Bx + C #
	lw $s2, 0($sp)		# Pop C
	lw $s1, 4($sp)		# Pop B
	lw $s0, 8($sp)		# Pop A
	addi $sp, $sp, 12	# Reclaim space
	
	mult $s1, $s1		# Get b * b
	mflo $s1		# $s1 = b * b [32 bit]
	
	li $s3, 4		# $s3 = 4 (Stores the coefficient part of -4ac)
	
	mult $s0, $s2		# Get a * c
	mflo $s0		# $s0 = a * c
	
	mult $s0, $s3		# Get 4 * a * c
	mflo $s0		# $s0 =  4 * a * c
	
	sub $s3, $s1, $s0	# $s3 = (b * b) - 4(a * c), as wanted!
	
	beqz $s3, ONESOL	# $s3 == 0 -> One solution!
	bltz $s3, NOSOL		# $s3 < 0 -> No solution!
				# else: $s3 > 0 -> Two solutions!
				
	li $v0, 2		# Load 2 to $v0
	j RET			# Answer Ready!
	
ONESOL: li $v0, 1		# Load 1 to $v0
	j RET			# Answer Ready!
	
NOSOL:  li $v0, 0		# Load 0 to $v0

RET:	jr $ra			# Go back to main! 
