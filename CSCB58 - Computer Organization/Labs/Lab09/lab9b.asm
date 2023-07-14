# Name: Sean Shekhtman
# Utorid: 1008305371


.globl main
.text

main:
	# Note: Since a,b >= 1, we can use subu! #

	li $t8, 25	# $t8 = a
	li $t9, 64	# $t9 = b
	
START:	beq $t8, $t9, END	# if a == b, END
	bgt $t8, $t9, ABIG	# if a > b, ABIG
	subu $t9, $t9, $t8	# else: b = b - a
	j START
	
ABIG:	subu $t8, $t8, $t9	# a = a - b
	j START
	
END:	add $t0, $zero, $t8	# Let $t0 = a, b/c a = b
	
	li $v0, 10	# Get ready! We're exiting!
	syscall		# Exiting now #
