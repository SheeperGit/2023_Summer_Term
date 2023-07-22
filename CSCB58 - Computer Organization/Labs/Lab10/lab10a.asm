# Name: Sean Shekhtman
# Utorid: 1008305371

.data
A:	.word	5, 8, -3, 4, -7, 2, 33, 1
B:	.word	0:8
LEN:	.word	8

.globl main
.text

main:	# B[i1 = A[i] * (10), if A[i1 is even #
	# B[i1 = A[i] * (5), if A[i1 is odd #
	
	li $t0, 0		# $t0 = 0 will be our looping variable
	la $t1, A		# $t1 = &(A)
	la $t2, B		# $t2 = &(B)
	la $t3, LEN		# $t3 = &(LEN)
	lw $t3, 0($t3)		# $t3 = LEN
	
	li $t9, 4		# $t9 = sizeof(word) = 4bytes
	
	mult $t9, $t3		# Multiply sizeof(word), LEN
	mflo $t3		# Store product back in $t3
	
LOOP:	beq $t0, $t3, END	# If i == LEN * sizeof(word) 
	add $t4, $t1, $t0	# $t4 = &(A) + i
	add $t5, $t2, $t0	# $t5 = &(B) + i
	
	lw $s1, 0($t4)		# $s1 = A[i]
	andi $t6, $s1, 1	# $t6 = $s1 % 2
	beq $t6, 1, ODD		# If $t6 % 2 == 1, then go to ODD case
	
	li $t6, 10		# O/w, go to EVEN case
	j EVEN
	
ODD:	li $t6, 5		# $t6 switches to holding the factor
EVEN:	mult $s1, $t6		# Multiply A[i], (5 or 10)
	mflo $t6		# Store product back in $t6
	
	sw $t6, 0($t5)		# B[i] = A[i] * (5 or 10)
	
	addi $t0, $t0, 4	# i++
	
	j LOOP
	
END:	li $v0, 10		# Exit Prog #
	syscall			#    Bye!   #
