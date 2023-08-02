#####################################################################
#
# CSCB58 Summer 2023 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Sean Shekhtman, 1008305371, schekhtm, sean.shekhtman@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3 (choose the one the applies)
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes, and please share this project github link as well!
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
##################################################################### 
.eqv	BASE_ADDRESS	0x10008000	
.eqv	WAIT_TIME	40		# Refresh Rate (Increase/Decrease when debugging)

.eqv	BODY_COLOR	0x00ff00	# Yellow. Changeable (Maybe from UI)
.eqv	FACE_COLOR	0xff0000	# Red. Changeable (Maybe from UI)
.eqv	PLAT_COLOR	0xffffff	# White. Changeable. (Maybe on every jump? That'd be pretty cool!)
.eqv	COIN_COLOR	0xffff00	# Yellow. Static.
.eqv	BRp		0x10008e18	# Location of the bottom-right pixel of player character

.data	
RAND_COLOR_LEN:	.word	8		# Length of RAND_COLOR arr, increase w/ new color additions
			      #    Red	   Orange     Lime      Blue	  Cyan	  Magenta    Maroon    Purple   #
RAND_COLOR:	.word		0xff0000, 0xff8000, 0x00ff00, 0x0000ff, 0x00ffff, 0xff00ff, 0x800000, 0x800080

.text
.globl main

# Note to Self: $s0-$s7 && $t9 are RESERVED (Update this if needed) #

main:	# Alright, let's get this thing going! #
	li $s0, BASE_ADDRESS	# $s0 stores the base address for display
	li $s1, BRp		# $s1 stores the bottom-right pixel of player character
	li $s2, BODY_COLOR	# $s2 stores the BODY_COLOR
	li $s3, FACE_COLOR	# $s3 stores the FACE_COLOR
	li $s4, PLAT_COLOR	# $s4 stores the PLAT_COLOR
	li $s5, COIN_COLOR	# $s5 stores the COIN_COLOR
	li $s6, 0		# $s6 stores the initial player score (Increases w/ time and coins)
	
	# initial position of platform
	li $v0, 42				# Get a random number b/w 0 and 28
	li $a0, 0
	li $a1, 28
	syscall
	
	addi $a0, $a0, 3			# Get start addr of platform
	li $t1, 128
	mult $t1, $a0
	mflo $t2
	addi $t2, $t2, -48
	
	li $t9, BASE_ADDRESS			# $t9 stores the right side of the platform
	add $t9, $t9, $t2
	
	# Draw Title #
	
	# G #
	sw $s5, 392($s0)
	sw $s5, 396($s0)
	sw $s5, 400($s0)
	sw $s5, 404($s0)
	sw $s5, 520($s0)
	sw $s5, 648($s0)
	sw $s5, 776($s0)
	sw $s5, 904($s0)
	sw $s5, 908($s0)
	sw $s5, 912($s0)
	sw $s5, 916($s0)
	sw $s5, 788($s0)
	sw $s5, 656($s0)
	sw $s5, 660($s0)
	
	# E #
	sw $s2, 412($s0)
	sw $s2, 540($s0)
	sw $s2, 668($s0)
	sw $s2, 796($s0)
	sw $s2, 924($s0)
	sw $s2, 416($s0)
	sw $s2, 420($s0)
	sw $s2, 424($s0)
	sw $s2, 672($s0)
	sw $s2, 676($s0)
	sw $s2, 680($s0)
	sw $s2, 928($s0)
	sw $s2, 932($s0)
	sw $s2, 936($s0)
		
	# O #
	sw $s3, 432($s0)
	sw $s3, 436($s0)
	sw $s3, 440($s0)
	sw $s3, 444($s0)
	sw $s3, 560($s0)
	sw $s3, 572($s0)
	sw $s3, 688($s0)
	sw $s3, 816($s0)
	sw $s3, 944($s0)
	sw $s3, 948($s0)
	sw $s3, 952($s0)
	sw $s3, 956($s0)
	sw $s3, 828($s0)
	sw $s3, 700($s0)
	
	# D #
	sw $s4, 1196($s0)
	sw $s4, 1324($s0)
	sw $s4, 1452($s0)
	sw $s4, 1580($s0)
	sw $s4, 1708($s0)
	sw $s4, 1200($s0)
	sw $s4, 1332($s0)
	sw $s4, 1464($s0)
	sw $s4, 1712($s0)
	sw $s4, 1588($s0)
		
	# A #
	sw $s4, 1728($s0)
	sw $s4, 1600($s0)
	sw $s4, 1472($s0)
	sw $s4, 1344($s0)
	sw $s4, 1216($s0)
	sw $s4, 1220($s0)
	sw $s4, 1224($s0)
	sw $s4, 1228($s0)
	sw $s4, 1356($s0)
	sw $s4, 1484($s0)
	sw $s4, 1612($s0)
	sw $s4, 1740($s0)
	sw $s4, 1476($s0)
	sw $s4, 1480($s0)
	
	# S #
	sw $s4, 1236($s0)
	sw $s4, 1240($s0)
	sw $s4, 1244($s0)
	sw $s4, 1248($s0)
	sw $s4, 1492($s0)
	sw $s4, 1496($s0)
	sw $s4, 1500($s0)
	sw $s4, 1504($s0)
	sw $s4, 1748($s0)
	sw $s4, 1752($s0)
	sw $s4, 1756($s0)
	sw $s4, 1760($s0)
	sw $s4, 1364($s0)
	sw $s4, 1632($s0)
	
	# H #
	sw $s4, 1256($s0)
	sw $s4, 1384($s0)
	sw $s4, 1512($s0)
	sw $s4, 1640($s0)
	sw $s4, 1768($s0)
	sw $s4, 1268($s0)
	sw $s4, 1396($s0)
	sw $s4, 1524($s0)
	sw $s4, 1652($s0)
	sw $s4, 1780($s0)
	sw $s4, 1516($s0)
	sw $s4, 1520($s0)
		
key_loop:	
	addi $s6, $s6, 1	# Adds +1 to player score
	# Take user input continually #
	li $t9, 0xffff0000 
	lw $t8, 0($t9)
	beq $t8, 1, keypress_happened
	
cont:	
	jal draw_plyr
	jal draw_init_plat
	# jal draw_rand_plat

	li $v0, 32 				# Sleep for 0.05secs (Lower for harder difficulty)
	li $t5, 50				# Get delay rate
	li $a0, 50				# Base difficulty is at 0.05secs delay
	sub $a0, $a0, $t5
	syscall
	# jal check_collision
	# jal clear_objs
	jal gravity_tick

	# Deletes the line above the player (Experimental!) #	
	sw $zero, -896($s1)
	sw $zero, -900($s1)
	sw $zero, -904($s1)
	sw $zero, -908($s1)
	sw $zero, -912($s1)
	sw $zero, -916($s1)
	sw $zero, -920($s1)
	
	j key_loop
	
keypress_happened:
	li $t9, 0xffff0000	#
	lw $t8, 4($t9) 		# Load which key was pressed

	beq $t8, 0x77, respondW
	beq $t8, 0x61, respondA
	# beq $t8, 0x73, respondS
	beq $t8, 0x64, respondD
	beq $t8, 0x70, respondP
	
clear_objs:	# Call each obj clear function (only use on GameOver) #
	move $s7, $ra
	jal clear_plyr
	#jal clear_sm
	#jal clear_md
	#jal clear_lg
	move $ra, $s7
	jr $ra
	
clear_screen:	# Clears screen by looping through all addresses #
	li $t0, BASE_ADDRESS
	li $t1, 1024
clear_loop:
	sw $zero, 0($t0)
	addi $t0, $t0, 4
	addi $t1, $t1, -1
	bgtz $t1, clear_loop
	jr $ra
	
clear_plyr:	# Clears all player pixels #
	# Rmv all player pixels #
	sw $zero, 0($s1)	#
	sw $zero, -4($s1)	#
	sw $zero, -8($s1)	#
	sw $zero, -12($s1)	#
	sw $zero, -16($s1)	#
	sw $zero, -20($s1)	#
	sw $zero, -24($s1)	#
	
	sw $zero, -128($s1)	#
	sw $zero, -132($s1)	#
	sw $zero, -136($s1)	#	
	sw $zero, -140($s1)	#
	sw $zero, -144($s1)	#
	sw $zero, -148($s1)	#
	sw $zero, -152($s1)	#
	
	sw $zero, -256($s1)	#
	sw $zero, -260($s1)	#
	sw $zero, -264($s1)	#
	sw $zero, -268($s1)	#
	sw $zero, -272($s1)	#
	sw $zero, -276($s1)	#
	sw $zero, -280($s1)	#
	
	sw $zero, -384($s1)	#
	sw $zero, -388($s1)	#
	sw $zero, -392($s1)	#
	sw $zero, -396($s1)	#
	sw $zero, -400($s1)	#
	sw $zero, -404($s1)	#
	sw $zero, -408($s1)	#
	
	sw $zero, -512($s1)	#
	sw $zero, -516($s1)	#
	sw $zero, -520($s1)	#
	sw $zero, -524($s1)	#
	sw $zero, -528($s1)	#
	sw $zero, -532($s1)	#
	sw $zero, -536($s1)	#
	
	sw $zero, -640($s1)	#
	sw $zero, -644($s1)	#
	sw $zero, -648($s1)	#
	sw $zero, -652($s1)	#
	sw $zero, -656($s1)	#
	sw $zero, -660($s1)	#
	sw $zero, -664($s1)	#
	
	sw $zero, -768($s1)	#
	sw $zero, -772($s1)	#
	sw $zero, -776($s1)	#
	sw $zero, -780($s1)	#
	sw $zero, -784($s1)	#
	sw $zero, -788($s1)	#
	sw $zero, -792($s1)	#
	
	jr $ra			#
	
draw_plyr:	
	# Draw player character #
	sw $s2, 0($s1)		#
	sw $s2, -4($s1)		#
	sw $s2, -8($s1)		#	
	sw $s2, -12($s1)	#
	sw $s2, -16($s1)	#
	sw $s2, -20($s1)	#
	sw $s2, -24($s1)	#
	
	sw $s2, -128($s1)	#
	sw $s3, -132($s1)	#
	sw $s3, -136($s1)	#	
	sw $s3, -140($s1)	#
	sw $s3, -144($s1)	#
	sw $s3, -148($s1)	#
	sw $s2, -152($s1)	#
	
	sw $s2, -256($s1)	#
	sw $s3, -260($s1)	#
	sw $s2, -264($s1)	#
	sw $s3, -268($s1)	#
	sw $s2, -272($s1)	#
	sw $s3, -276($s1)	#
	sw $s2, -280($s1)	#
	
	sw $s2, -384($s1)	#
	sw $s2, -388($s1)	#
	sw $s2, -392($s1)	#
	sw $s2, -396($s1)	#
	sw $s2, -400($s1)	#
	sw $s2, -404($s1)	#
	sw $s2, -408($s1)	#
	
	sw $s2, -512($s1)	#
	sw $s2, -516($s1)	#
	sw $s2, -520($s1)	#
	sw $s2, -524($s1)	#
	sw $s2, -528($s1)	#
	sw $s2, -532($s1)	#
	sw $s2, -536($s1)	#
	
	sw $s2, -640($s1)	#
	sw $s3, -644($s1)	#
	sw $s2, -648($s1)	#
	sw $s2, -652($s1)	#
	sw $s2, -656($s1)	#
	sw $s3, -660($s1)	#
	sw $s2, -664($s1)	#
	
	sw $s2, -768($s1)	#
	sw $s2, -772($s1)	#
	sw $s2, -776($s1)	#
	sw $s2, -780($s1)	#
	sw $s2, -784($s1)	#
	sw $s2, -788($s1)	#
	sw $s2, -792($s1)	#
	
	jr $ra
	
draw_init_plat:
	# Draw initial platform #
	sw $s4, 3712($s0)	#
	sw $s4, 3716($s0)	#
	sw $s4, 3720($s0)	#
	sw $s4, 3724($s0)	#
	sw $s4, 3728($s0)	#
	sw $s4, 3732($s0)	#
	sw $s4, 3736($s0)	#
	sw $s4, 3740($s0)	#
	sw $s4, 3744($s0)	#
	sw $s4, 3748($s0)	#
	sw $s4, 3752($s0)	#
	sw $s4, 3756($s0)	#
	sw $s4, 3760($s0)	#
	sw $s4, 3764($s0)	#
	sw $s4, 3768($s0)	#
	sw $s4, 3772($s0)	#
	sw $s4, 3776($s0)	#
	sw $s4, 3780($s0)	#
	
	jr $ra
	
draw_rand_plat:
	

gravity_tick: # Applies 1 "unit" of gravity to player, if not standing on platform #
	# If any of the pixels below the player are platforms, then ignore gravity #
	lw $t0, 128($s1)
	beq $t0, $s4, key_loop
	lw $t0, 124($s1)
	beq $t0, $s4, key_loop
	lw $t0, 120($s1)
	beq $t0, $s4, key_loop
	lw $t0, 116($s1)
	beq $t0, $s4, key_loop
	lw $t0, 112($s1)
	beq $t0, $s4, key_loop
	lw $t0, 108($s1)
	beq $t0, $s4, key_loop
	lw $t0, 104($s1)
	beq $t0, $s4, key_loop
	
	
	addi $s1, $s1, 128	# Going down!
	
	# Clear the top line of the player #
	sw $zero, -1020($s1)	#
	sw $zero, -1024($s1)	#
	sw $zero, -1028($s1)	#
	sw $zero, -1032($s1)	#
	sw $zero, -1036($s1)	#
	sw $zero, -1040($s1)	#
	sw $zero, -1044($s1)	#
	sw $zero, -1048($s1)	#
	sw $zero, -1052($s1)	#
	
	# Fall rate: 0.4secs #
	li $v0, 32
	li $a0, 400
	syscall
	
	jr $ra
		
respondW:	# Jump #
	# If player is not standing on the platform_color, go back to cont #
	lw $t0, 128($s1)
	bne $t0, $s4, cont
	lw $t0, 124($s1)
	bne $t0, $s4, cont
	lw $t0, 120($s1)
	bne $t0, $s4, cont
	lw $t0, 116($s1)
	bne $t0, $s4, cont
	lw $t0, 112($s1)
	bne $t0, $s4, cont
	lw $t0, 108($s1)
	bne $t0, $s4, cont
	lw $t0, 104($s1)
	bne $t0, $s4, cont

	# Go up by 5 units (incrementally w.r.t. jump rate, 0.4secs) #
	li $t0, 5		# $t0 = height of jump in pixels (Changeable)
	
	# Pick a random color to change the platforms! #
	li $v0, 42
	li $a0, 0
	la $a1, RAND_COLOR_LEN	# $a1 = &(RAND_COLOR_LEN)
	lw $a1, 0($a1)		# $a1 = RAND_COLOR_LEN
	syscall			# $a0 = rand(0, RAND_COLOR_LEN)
	
	li $t2, 4		# $t2 = sizeof(word)
	mult $a0, $t2		# Get rand(0, RAND_COLOR_LEN) * sizeof(word)
	mflo $t2		# $t2 now holds a random index in RAND_COLOR
	
	la $t1, RAND_COLOR	# $t1 = &(RANDO_COLOR)
	add $t2, $t1, $t2	# $t2 = &(RAND_COLOR + randIndex)
	lw $s4, 0($t2)		# Set PLAT_COLOR to new random color!
	
jump:	addi $t0, $t0, -1	# $t0--
	addi $s1, $s1, -128	# Going up!
	
	move $t3, $ra
	jal draw_plyr
	move $ra, $t3
	
	# Clear the bottom line of the player #
	sw $zero, 128($s1)	#
	sw $zero, 124($s1)	#
	sw $zero, 120($s1)	#
	sw $zero, 116($s1)	#
	sw $zero, 112($s1)	#
	sw $zero, 108($s1)	#
	sw $zero, 104($s1)	#
	
	# Jump rate: 0.12secs #
	li $v0, 32
	li $a0, 120
	syscall
	
	bgtz $t0, jump		# If you still got more jumps left...Jump some more units!
	j cont			# o/w,stop jumping!

respondA:	# Move Left #
	addi $s1, $s1, -4
	
	# Check if player is on same row #
	li $t5, 128			 # $t5 = sizeof(row)
	addi $t6, $s1, -24		 # $t6 = cur_pos (of left edge)
	div $t6, $t5			 # Get cur_pos / sizeof(row)
	mflo $t7			 # $t7 = cur_pos / sizeof(row)
	div $s1, $t5			 # Get next_pos / sizeof(row)
	mflo $t8			 # $t8 = next_pos / sizeof(row)
	
	# Clear right column of player (May delete other objs on other side of screen) #
	sw $zero, 4($s1)
	sw $zero, -124($s1)
	sw $zero, -252($s1)
	sw $zero, -380($s1)
	sw $zero, -508($s1)
	sw $zero, -636($s1)
	sw $zero, -764($s1)
	
	beq $t7, $t8, cont		 # If plyr still on same row, no need to revert!
	addi $s1, $s1, 4		 # Revert movement
	j cont


respondS:	# Slam down? (Still not sure about this one) #

respondD:	# Move Right #
	addi $s1, $s1, 4
	
	# Check if player is on same row #
	li $t5, 128			 # $t5 = sizeof(row)
	addi $t6, $s1, -4		 # $t6 = cur_pos (of right edge)
	div $t6, $t5			 # Get cur_pos / sizeof(row)
	mflo $t7			 # $t7 = cur_pos / sizeof(row)
	div $s1, $t5			 # Get next_pos / sizeof(row)
	mflo $t8			 # $t8 = next_pos / sizeof(row)
	
	# Clear left column of player (May delete other objs on other side of screen) #
	sw $zero, -28($s1)
	sw $zero, -156($s1)
	sw $zero, -284($s1)
	sw $zero, -412($s1)
	sw $zero, -540($s1)
	sw $zero, -668($s1)
	sw $zero, -796($s1)
	
	beq $t7, $t8, cont		# If plyr still on same row, no need to revert!
	addi $s1, $s1, -4		# Revert movement
	j cont

respondP:	# Restart Game #
	jal clear_screen
	j main
	

EXIT:	# The player has selected to exit the game! Show their final score! #
	li $v0, 10
	syscall
