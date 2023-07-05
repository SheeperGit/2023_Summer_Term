# Name: Sean Shekhtman
# Utorid: 1008305371

.data
promptA: .asciiz "Enter an integer A: "
promptB: .asciiz "Enter an integer B: "
promptC: .asciiz "Enter an integer C: "

resaddABC: .asciiz "A + B + C = "

newline: .asciiz "\n"

.globl main
.text

main:
	# Ask for input A #
	li $v0, 4
	la $a0, promptA
	syscall
	
	# Write A to $t0 #	
	li $v0, 5
	syscall
	
	# Write A #	
	move $t0, $v0

		
	# Ask for input B #
	li $v0, 4
	la $a0, promptB
	syscall
	
	# Write B #	
	li $v0, 5
	syscall
	
	# Write B to $t1 #	
	move $t1, $v0
	
	
	# Read C #
	li $v0, 4
	la $a0, promptC
	syscall

	# Write C #	
	li $v0, 5
	syscall

	# Write C to $t2 #	
	move $t2, $v0
	
	
	#      Get A + B + C      #
	# (i.e., $t0 + $t1 + $t2) #
	add $t3, $t0, $t1 	# $t3 contains A + B #
	add $t4, $t3, $t2 	# $t3 contains (A + B) + C #
	
	# Show our wonderful output! #
	li $v0, 4
	la $a0, newline
	syscall 
	
	li $v0, 4
	la $a0, resaddABC
	syscall

	move $a0, $t4
	li $v0, 1
	syscall
	
	
	# Exit #
	li $v0, 10
	syscall
	
	