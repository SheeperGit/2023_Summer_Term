# Name: Sean Shekhtman
# Utorid: 1008305371


.globl main
.text

main: 
	# f(x) = ax^2 + bx + c #

	addi $t5, $zero, -1	# t5 = a
	addi $t6, $zero, 6	# t6 = b
	addi $t7, $zero, -5	# t7 = c
	
	mult $t6, $t6		# Get b * b
	mflo $t6		# $t6 = b * b [32 bit]
	
	li $t0, 4	# t0 = 4 (Stores the coefficient part of -4ac)
	
	mult $t5, $t7		# Get a * c
	mflo $t5		# $t5 = a * c
	
	mult $t5, $t0		# Get 4 * a * c
	mflo $t5		# $t5 =  4 * a * c
	
	sub $t0, $t6, $t5	# $t0 = (b * b) - 4(a * c), as wanted!
	
	beqz $t0, ONESOL	# $t6 == 0 -> One solution!
	bltz $t0, NOSOL		# $t6 < 0 -> No solution!
				# else: $t6 > 0 -> Two solutions!
				
	li $t0, 2		# Load 2 to $t0
	j END			# Answer Ready!
	
ONESOL: li $t0, 1		# Load 1 to $t0
	j END			# Answer Ready!
	
NOSOL:  li $t0, 0		# Load 0 to $t0
	
	
END:	li $v0, 10		# Get ready! We're exiting!
	syscall			# Exiting now #
