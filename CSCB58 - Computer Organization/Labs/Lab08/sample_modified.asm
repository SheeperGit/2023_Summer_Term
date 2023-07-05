# Name: Sean Shekhtman
# Utorid: 1008305371

.data 
# TODO: What are the following 5 lines doing?
promptA: .asciiz "Enter an int A: " 
promptB: .asciiz "Enter an int B: " 
resultAdd: .asciiz "A + 42 = "
resultSub: .asciiz "B - A = "
newline: .asciiz "\n"

.globl main
.text

main: 
    # TODO: Set a breakpoint here and step through. 
    # What does this block of 3 lines do?
	li $v0, 4		# $v0 stores 4, which is print str #      
	la $a0, promptA 	# Store the address of promptA in $a0 #
	syscall    		# Execute the system call specified by the val in $v0, print str #

    # TODO: Set a breakpoint here and step through. 
    # What does this block of 3 lines do?
	li $v0, 5		# $v0 stores 5, which is int read #
	syscall 		# Execute the system call specified by the val in $v0, read int from user #
	move $t0, $v0		# Set the contents of $t0 to the contents of $v0 #

    # TODO: What is the value of "promptB"? Hint: Check the
    # value of $a0 and see what it corresponds to.
	li $v0, 4		# $v0 stores 4, which is print str #
	la $a0, promptB		# Store the address of promptB in $a0 #
	syscall			# Execute the system call specified by the val in $v0, print str #

    # TODO: Explain what happens if a non-integer is entered
    # by the user.
    # ANS: syscall 5, invalid integer operand (it expects an int, after all)
	li $v0, 5		# $v0 stores 5, which is int read #
	syscall 		# Execute the system call specified by the val in $v0, read int from user #
	
    # TODO: t stands for "temp" -- why is the value from $v0 
    # being moved to $t1?
	move $t1, $v0		# test break #

	# TODO: What if I want to get A + 1 and B + 42 instead
	# ANS: Then you'd do: addi $t2, $t0, 1
	#		      addi $t2, $t1, 42
	#		      respectively.				
	addi $t2, $t0, 42	# Store ($t0 + 42) in $t2 # 
	sub $t3, $t1, $t0	# Store ($t1 - $t0) in t3 #

	li $v0, 4
	la $a0, resultAdd
	syscall

    # TODO: What is the difference between "li" and "move"?
    # ANS: li works w/ immediate vals, while move works w/ reg contents
	li $v0, 1
	move $a0, $t2	
	syscall 

    # TODO: Why is the next block of three lines needed? 
    # Remove them and explain what happens.
	li $v0, 4
	la $a0, newline
	syscall 

	li $v0, 4
	la $a0, resultSub
	syscall

	move $a0, $t3	
	li $v0, 1
	syscall 

	li $v0, 4
	la $a0, newline
	syscall 

	li $v0, 10
	syscall
