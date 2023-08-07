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
# 1. Platforms change color with every jump! (Randomly, based on colors in a fixed array, RAND_COLOR)	[Gimmick : +2pts]
# 2. Player score (Increases with time and heavily increases with amt of coins earned)			[Score : +2pts]
# 3. Arcade-Style UI											[Menu : +3pts]
# 4. Moving Platforms											[Moving plats: +2pts]
# 5. Moving Spikes (Spikes aren't directly tied to platforms)						[Moving Objects: +2pts]
# 6. Spikes or falling too low lead to a Game Over screen						[Fail Condition : +1pt]
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
.eqv	DEATH_PLANE	0X10008F80	
.eqv	WAIT_TIME	40		# Refresh Rate (Increase/Decrease when debugging)

.eqv	BODY_COLOR	0x00ff00	# Yellow. Changeable (Maybe from UI)
.eqv	FACE_COLOR	0xff0000	# Red. Changeable (Maybe from UI)
.eqv	PLAT_COLOR	0xffffff	# White. Changeable. (Maybe on every jump? That'd be pretty cool!)
.eqv	COIN_COLOR	0xffff00	# Yellow. Static.
.eqv	SPIK_COLOR	0xc0c0c0	# Silver. Static.
.eqv	BRp		0x10008e18	# Location of the bottom-right pixel of player character
.eqv 	SPIKEp		0x10008e28	# Spike pixel

.data	
RAND_COLOR_LEN:	.word	8		# Length of RAND_COLOR arr, increase w/ new color additions
			      #    Red	   Orange     Lime      Blue	  Cyan	  Magenta    Maroon    Purple   #
RAND_COLOR:	.word		0xff0000, 0xff8000, 0x00ff00, 0x0000ff, 0x00ffff, 0xff00ff, 0x800000, 0x800080

.text
.globl main

# Note to Self: $s0-$s7 && $t5-$t9 are RESERVED (Update this if needed) #

main:	# Alright, let's get this thing going! #
	li $s0, BASE_ADDRESS	# $s0 stores the base address for display
	li $s1, BRp		# $s1 stores the bottom-right pixel of player character
	li $s2, BODY_COLOR	# $s2 stores the BODY_COLOR
	li $s3, FACE_COLOR	# $s3 stores the FACE_COLOR
	li $s4, PLAT_COLOR	# $s4 stores the PLAT_COLOR
	li $s5, COIN_COLOR	# $s5 stores the COIN_COLOR
	li $s6, 0		# $s6 stores the initial player score (Increases w/ time and coins)
	li $t5, SPIK_COLOR	# $t5 stores the SPIK_COLOR
	li $t6, SPIKEp		# $t6 stores the spike pixel
	
	# Initial position of low platform #
	# Get a random number b/w 0 and 4 #
	li $v0, 42				
	li $a0, 0
	li $a1, 4
	syscall					# $a0 = rand(0, 4)
	
	# Get start addr of low platform (max_height = 32 - 26 = 6) #
	addi $a0, $a0, 26			# $a0 = rand(26, 30)	
	li $t1, 128				# $t1 = 128
	mult $t1, $a0				# Get 128 * rand(26, 30)
	mflo $t2				# $t2 = 128 * rand(26, 30)
	addi $t2, $t2, -4			# $t2 = [128 * rand(26, 30) - 4] (To start at right side of the screen)
	
	li $t7, BASE_ADDRESS			# $t7 stores the right side of the platform
	add $t7, $t7, $t2
	
	# Initial position of medium platform #
	# Get a random number b/w 0 and 4 #
	li $v0, 42				
	li $a0, 0
	li $a1, 4
	syscall					# $a0 = rand(0, 4)
	
	# Get start addr of platform (max_height = 32 - 21 = 9) #
	addi $a0, $a0, 21			# $a0 = rand(21, 25)	
	li $t1, 128				# $t1 = 128
	mult $t1, $a0				# Get 128 * rand(21, 25)
	mflo $t2				# $t2 = 128 * rand(21, 25)
	addi $t2, $t2, -4			# $t2 = [128 * rand(21, 25) - 4] (To start at right side of the screen)
	
	li $t8, BASE_ADDRESS			# $t8 stores the right side of the medium platform
	add $t8, $t8, $t2
	
	# Initial position of high platform #
	# Get a random number b/w 0 and 4 #
	li $v0, 42				
	li $a0, 0
	li $a1, 4
	syscall					# $a0 = rand(0, 4)
	
	# Get start addr of platform (max_height = 32 - 16 = 16) #
	addi $a0, $a0, 16			# $a0 = rand(16, 20)	
	li $t1, 128				# $t1 = 128
	mult $t1, $a0				# Get 128 * rand(16, 20)
	mflo $t2				# $t2 = 128 * rand(16, 20)
	addi $t2, $t2, -4			# $t2 = [128 * rand(16, 20) - 4] (To start at right side of the screen)
	
	li $t9, BASE_ADDRESS			# $t9 stores the right side of the medium platform
	add $t9, $t9, $t2
	
	# Get a random number b/w 0 and 4 #
	li $v0, 42				
	li $a0, 0
	li $a1, 4
	syscall					# $a0 = rand(0, 4)
	move $t4, $a0				# Store which platform has the spike in $t4
	
	beq $t4, 1, INIT_MED_SPIKE_CHOSEN
	beq $t4, 2, INIT_HIGH_SPIKE_CHOSEN
	
	# LOW_PLAT will receive the spike #
	addi $t6, $t7, -148
	sw $t5, 0($t6)
	sw $t5, -4($t6)
	sw $t5, 4($t6)
	sw $t5, -128($t6)
	j SPIK_CHOSEN
	
INIT_MED_SPIKE_CHOSEN:	
	# MED_PLAT will receive the spike #
	addi $t6, $t8, -148
	sw $t5, 0($t6)
	sw $t5, -4($t6)
	sw $t5, 4($t6)
	sw $t5, -128($t6)
	j SPIK_CHOSEN

INIT_HIGH_SPIKE_CHOSEN:	
	# HIGH_PLAT will receive the spike #
	addi $t6, $t9, -148
	sw $t5, 0($t6)
	sw $t5, -4($t6)
	sw $t5, 4($t6)
	sw $t5, -128($t6)
	
SPIK_CHOSEN:	# The platform w/ the spike has been decided! Let's move on! #
	
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
	li $t2, 0xffff0000 
	lw $t1, 0($t2)
	beq $t1, 1, keypress_happened
	
cont:	
	jal draw_plyr
	jal draw_init_plat
	jal draw_rand_plat
	jal draw_spike
	
	# Get rand(0, 2)
	li $v0, 42		# 0 => spike on low_plat
	li $a0, 0		# 1 => spike on med_plat
	li $a1, 2		# 2 => spike on high_plat
	syscall
	move $t4, $a0		# Store which plat will have the spike in $t4		

	li $v0, 32 				# Sleep for 0.05secs (Lower for harder difficulty)
	li $t0, 50				# Get delay rate
	li $a0, 50				# Base difficulty is at 0.05secs delay
	sub $a0, $a0, $t0
	syscall
	jal check_collision
	# jal clear_objs
	jal gravity_tick
	jal move_platform
	jal move_spike
	
SPIK_MV_FINISH:
	jal clear_plyr_top
	
	j key_loop
	
keypress_happened:
	li $t0, 0xffff0000	#
	lw $t1, 4($t0) 		# Load which key was pressed

	beq $t1, 0x77, respondW
	beq $t1, 0x61, respondA
	# beq $t1, 0x73, respondS
	beq $t1, 0x64, respondD
	beq $t1, 0x70, respondP
	
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
	
clear_plyr_top:
	# Deletes the line above the player (Experimental!) #	
	sw $zero, -896($s1)
	sw $zero, -900($s1)
	sw $zero, -904($s1)
	sw $zero, -908($s1)
	sw $zero, -912($s1)
	sw $zero, -916($s1)
	sw $zero, -920($s1)
	
	jr $ra
	
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
	# Draw small platform #
	sw $s4, 0($t7)
	sw $s4, -4($t7)
	sw $s4, -8($t7)
	sw $s4, -12($t7)
	sw $s4, -16($t7)
	sw $s4, -20($t7)
	sw $s4, -24($t7)
	sw $s4, -28($t7)
	sw $s4, -32($t7)
	sw $s4, -36($t7)
	sw $s4, -40($t7)
	
	# Draw medium platform #
	sw $s4, 0($t8)
	sw $s4, -4($t8)
	sw $s4, -8($t8)
	sw $s4, -12($t8)
	sw $s4, -16($t8)
	sw $s4, -20($t8)
	sw $s4, -24($t8)
	sw $s4, -28($t8)
	sw $s4, -32($t8)
	sw $s4, -36($t8)
	sw $s4, -40($t8)
	
	# Draw high platform #
	sw $s4, 0($t9)
	sw $s4, -4($t9)
	sw $s4, -8($t9)
	sw $s4, -12($t9)
	sw $s4, -16($t9)
	sw $s4, -20($t9)
	sw $s4, -24($t9)
	sw $s4, -28($t9)
	sw $s4, -32($t9)
	sw $s4, -36($t9)
	sw $s4, -40($t9)
	
	jr $ra
	
draw_spike:
	sw $t5, 0($t6)
	sw $t5, -4($t6)
	sw $t5, 4($t6)
	sw $t5, -128($t6)
	
	jr $ra
	
check_collision:
	# Check1: If player is touching the bottom of the screen, pause for a bit, then send to Game Over #
	# Check2: If player is touching a spike, pause for a bit, then send to Game Over #
	
	# Check1 #
	li $t0, DEATH_PLANE
	addi $t1, $s1, -24		# $t1 = BLp (Bottom-left pixel of player)
	bge $t1, $t0, GameOver		# If BLp >= DEATH_PLANE, then send to GameOver
	
	# Check2 #
	# Check bottom line of player for SPIK_COLOR #
	lw $t0, 0($s1)
	beq $t0, SPIK_COLOR, GameOver 
	lw $t0, -4($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -8($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -12($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -16($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -20($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -24($s1)
	beq $t0, SPIK_COLOR, GameOver
	
	# Check right line of player for SPIK_COLOR #
	lw $t0, -128($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -256($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -384($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -512($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -640($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -768($s1)
	beq $t0, SPIK_COLOR, GameOver
	
	# Check top line of player for SPIK_COLOR #
	lw $t0, -772($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -776($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -780($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -784($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -788($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -792($s1)
	beq $t0, SPIK_COLOR, GameOver
	
	# Check left line of player for SPIK_COLOR #
	lw $t0, -152($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -280($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -408($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -536($s1)
	beq $t0, SPIK_COLOR, GameOver
	lw $t0, -664($s1)
	beq $t0, SPIK_COLOR, GameOver
	
	jr $ra
	
move_platform:
	# Move platforms to the right #
	addi $t7, $t7, -4 
	addi $t8, $t8, -4
	addi $t9, $t9, -4
	
	# Check if platform is on same row #
	li $t0, 128			 # $t0 = sizeof(row)
	addi $t1, $t7, -40		 # $t1 = cur_pos (of left edge) (Was -24)
	div $t1, $t0			 # Get cur_pos / sizeof(row)
	mflo $t2			 # $t2 = cur_pos / sizeof(row)
	div $t7, $t0			 # Get next_pos / sizeof(row)
	mflo $t1			 # $t1 = next_pos / sizeof(row)
	
	# Clear right column of player (May delete other objs on other side of screen) #
	sw $zero, 4($t7)		# Delete trailing pixel
	beq $t2, $t1, mvMedPlat		# If platform still on same row, no need to revert!
	
	sw $zero, 0($t7)
	sw $zero, -4($t7)
	sw $zero, -8($t7)
	sw $zero, -12($t7)
	sw $zero, -16($t7)
	sw $zero, -20($t7)
	sw $zero, -24($t7)
	sw $zero, -28($t7)
	sw $zero, -32($t7)
	sw $zero, -36($t7)
	
	# If low platform is OoB, then get a new starting location for it #
	li $v0, 42				
	li $a0, 0
	li $a1, 4
	syscall					# $a0 = rand(0, 4)
	
	# Get start addr of low platform (max_height = 32 - 26 = 6) #
	addi $a0, $a0, 26			# $a0 = rand(26, 30)	
	li $t1, 128				# $t1 = 128
	mult $t1, $a0				# Get 128 * rand(26, 30)
	mflo $t2				# $t2 = 128 * rand(26, 30)
	addi $t2, $t2, -4			# $t2 = [128 * rand(26, 30) - 4] (To start at right side of the screen)
	
	li $t7, BASE_ADDRESS			# $t7 stores the right side of the platform
	add $t7, $t7, $t2
	
mvMedPlat:
	# Check if platform is on same row #
	li $t0, 128			 # $t0 = sizeof(row)
	addi $t1, $t8, -40		 # $t1 = cur_pos (of left edge) (Was -24)
	div $t1, $t0			 # Get cur_pos / sizeof(row)
	mflo $t2			 # $t2 = cur_pos / sizeof(row)
	div $t8, $t0			 # Get next_pos / sizeof(row)
	mflo $t1			 # $t1 = next_pos / sizeof(row)
	
	sw $zero, 4($t8)		# Delete trailing pixel
	beq $t2, $t1, mvHighPlat	# If platform still on same row, no need to revert!
	
	sw $zero, 0($t8)
	sw $zero, -4($t8)
	sw $zero, -8($t8)
	sw $zero, -12($t8)
	sw $zero, -16($t8)
	sw $zero, -20($t8)
	sw $zero, -24($t8)
	sw $zero, -28($t8)
	sw $zero, -32($t8)
	sw $zero, -36($t8)
	
	# If medium platform is OoB, then get a new starting location for it #
	li $v0, 42				
	li $a0, 0
	li $a1, 4
	syscall					# $a0 = rand(0, 4)
	
	# Get start addr of platform (max_height = 32 - 21 = 9) #
	addi $a0, $a0, 21			# $a0 = rand(21, 25)	
	li $t1, 128				# $t1 = 128
	mult $t1, $a0				# Get 128 * rand(21, 25)
	mflo $t2				# $t2 = 128 * rand(21, 25)
	addi $t2, $t2, -4			# $t2 = [128 * rand(21, 25) - 4] (To start at right side of the screen)
	
	li $t8, BASE_ADDRESS			# $t8 stores the right side of the medium platform
	add $t8, $t8, $t2
	
mvHighPlat:
	# Check if platform is on same row #
	li $t0, 128			 # $t0 = sizeof(row)
	addi $t1, $t9, -40		 # $t1 = cur_pos (of left edge) (Was -24)
	div $t1, $t0			 # Get cur_pos / sizeof(row)
	mflo $t2			 # $t2 = cur_pos / sizeof(row)
	div $t9, $t0			 # Get next_pos / sizeof(row)
	mflo $t1			 # $t1 = next_pos / sizeof(row)
	
	sw $zero, 4($t9)		# Delete trailing pixel
	beq $t2, $t1, mvPlatEnd		# If platform still on same row, no need to revert!
	
	sw $zero, 0($t9)
	sw $zero, -4($t9)
	sw $zero, -8($t9)
	sw $zero, -12($t9)
	sw $zero, -16($t9)
	sw $zero, -20($t9)
	sw $zero, -24($t9)
	sw $zero, -28($t9)
	sw $zero, -32($t9)
	sw $zero, -36($t9)
	
	li $v0, 42				
	li $a0, 0
	li $a1, 4
	syscall					# $a0 = rand(0, 4)
	
	# Get start addr of platform (max_height = 32 - 16 = 16) #
	addi $a0, $a0, 16			# $a0 = rand(16, 20)	
	li $t1, 128				# $t1 = 128
	mult $t1, $a0				# Get 128 * rand(16, 20)
	mflo $t2				# $t2 = 128 * rand(16, 20)
	addi $t2, $t2, -4			# $t2 = [128 * rand(16, 20) - 4] (To start at right side of the screen)
	
	li $t9, BASE_ADDRESS			# $t9 stores the right side of the medium platform
	add $t9, $t9, $t2
	
mvPlatEnd:
	jr $ra		# Done updating platforms!
	
move_spike:
	addi $t6, $t6, -4
	
	# Check if platform is on same row #
	li $t0, 128			# $t0 = sizeof(row)
	addi $t1, $t6, -20		# $t1 = cur_pos (of left edge) (Was -40)
	div $t1, $t0			# Get cur_pos / sizeof(row)
	mflo $t2			# $t2 = cur_pos / sizeof(row)
	div $t6, $t0			# Get next_pos / sizeof(row)
	mflo $t1			# $t1 = next_pos / sizeof(row)
	
	sw $zero, -124($t6)		# Rm traling pixel
	sw $zero, 8($t6)		# Rm traling pixel
	
	beq $t2, $t1, SPIK_MV_FINISH
	
	# Erase spike #
	sw $zero, 0($t6)
	sw $zero, -4($t6)
	sw $zero, 4($t6)
	sw $zero, -128($t6)
	
	# Get new position for spike #
	# Get a random number b/w 0 and 4 #
	li $v0, 42				
	li $a0, 0
	li $a1, 4
	syscall					# $a0 = rand(0, 4)
	move $t4, $a0				# Store which platform has the spike in $t4
	
	beq $t4, 1, MED_SPIKE_CHOSEN
	beq $t4, 2, HIGH_SPIKE_CHOSEN
	
	# LOW_PLAT will receive the spike #
	addi $t6, $t7, -148
	sw $t5, 0($t6)
	sw $t5, -4($t6)
	sw $t5, 4($t6)
	sw $t5, -128($t6)
	j SPIKE_CHOSEN
	
MED_SPIKE_CHOSEN:	
	# MED_PLAT will receive the spike #
	addi $t6, $t8, -148
	sw $t5, 0($t6)
	sw $t5, -4($t6)
	sw $t5, 4($t6)
	sw $t5, -128($t6)
	j SPIK_CHOSEN

HIGH_SPIKE_CHOSEN:	
	# HIGH_PLAT will receive the spike #
	addi $t6, $t9, -148
	sw $t5, 0($t6)
	sw $t5, -4($t6)
	sw $t5, 4($t6)
	sw $t5, -128($t6)
	
SPIKE_CHOSEN:	# The platform w/ the spike has been decided! Let's move on! #
	jr $ra

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
	# If at least one player_pixel is standing on platform_color, it's a legal jump! #
	# O/w, don't let player jump and go back to cont #
	lw $t0, 128($s1)
	beq $t0, $s4, legal_jump
	lw $t0, 124($s1)
	beq $t0, $s4, legal_jump
	lw $t0, 120($s1)
	beq $t0, $s4, legal_jump
	lw $t0, 116($s1)
	beq $t0, $s4, legal_jump
	lw $t0, 112($s1)
	beq $t0, $s4, legal_jump
	lw $t0, 108($s1)
	beq $t0, $s4, legal_jump
	lw $t0, 104($s1)
	beq $t0, $s4, legal_jump
	
	j cont
	
legal_jump:

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
	li $t0, 128			 # $t0 = sizeof(row)
	addi $t1, $s1, -24		 # $t1 = cur_pos (of left edge)
	div $t1, $t0			 # Get cur_pos / sizeof(row)
	mflo $t2			 # $t2 = cur_pos / sizeof(row)
	div $s1, $t0			 # Get next_pos / sizeof(row)
	mflo $t1			 # $t1 = next_pos / sizeof(row)
	
	# Clear right column of player (May delete other objs on other side of screen) #
	sw $zero, 4($s1)
	sw $zero, -124($s1)
	sw $zero, -252($s1)
	sw $zero, -380($s1)
	sw $zero, -508($s1)
	sw $zero, -636($s1)
	sw $zero, -764($s1)
	
	beq $t2, $t1, cont		 # If plyr still on same row, no need to revert!
	addi $s1, $s1, 4		 # Revert movement
	j cont


respondS:	# Slam down? (Still not sure about this one) #

respondD:	# Move Right #
	addi $s1, $s1, 4
	
	# Check if player is on same row #
	li $t0, 128			 # $t0 = sizeof(row)
	addi $t1, $s1, -4		 # $t1 = cur_pos (of right edge)
	div $t1, $t0			 # Get cur_pos / sizeof(row)
	mflo $t2			 # $t2 = cur_pos / sizeof(row)
	div $s1, $t0			 # Get next_pos / sizeof(row)
	mflo $t1			 # $t1 = next_pos / sizeof(row)
	
	# Clear left column of player (May delete other objs on other side of screen) #
	sw $zero, -28($s1)
	sw $zero, -156($s1)
	sw $zero, -284($s1)
	sw $zero, -412($s1)
	sw $zero, -540($s1)
	sw $zero, -668($s1)
	sw $zero, -796($s1)
	
	beq $t2, $t1, cont		# If plyr still on same row, no need to revert!
	addi $s1, $s1, -4		# Revert movement
	j cont

respondP:	# Restart Game #
	jal clear_screen
	j main
	
GameOver:
	jal clear_screen
	li $t0, BASE_ADDRESS
	sw $zero, 0($t0)
	
	li $t1, 0xff0000			# store the red color code in $t1
	
	sw $t1, 272($t0)			# paint the letter G
	sw $t1, 400($t0)
	sw $t1, 528($t0)
	sw $t1, 656($t0)
	sw $t1, 784($t0)
	sw $t1, 912($t0)
	sw $t1, 1040($t0)
	sw $t1, 1168($t0)
	
	sw $t1, 1172($t0)
	sw $t1, 1176($t0)
	sw $t1, 1180($t0)
	sw $t1, 1184($t0)
	
	sw $t1, 1056($t0)
	sw $t1, 928($t0)
	sw $t1, 800($t0)
	sw $t1, 672($t0)
	
	sw $t1, 668($t0)
	sw $t1, 664($t0)
	
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	
	sw $t1, 300($t0)			# paint the letter A
	sw $t1, 304($t0)
	sw $t1, 308($t0)
	
	sw $t1, 812($t0)
	sw $t1, 816($t0)
	sw $t1, 820($t0)
	
	sw $t1, 424($t0)
	sw $t1, 552($t0)
	sw $t1, 680($t0)
	sw $t1, 808($t0)
	sw $t1, 936($t0)
	sw $t1, 1064($t0)
	sw $t1, 1192($t0)
	
	sw $t1, 440($t0)
	sw $t1, 568($t0)
	sw $t1, 696($t0)
	sw $t1, 824($t0)
	sw $t1, 952($t0)
	sw $t1, 1080($t0)
	sw $t1, 1208($t0)
	
	
	
	sw $t1, 320($t0)			# paint the letter M
	sw $t1, 448($t0)
	sw $t1, 576($t0)
	sw $t1, 704($t0)
	sw $t1, 832($t0)
	sw $t1, 960($t0)
	sw $t1, 1088($t0)
	sw $t1, 1216($t0)
	
	sw $t1, 336($t0)
	sw $t1, 464($t0)
	sw $t1, 592($t0)
	sw $t1, 720($t0)
	sw $t1, 848($t0)
	sw $t1, 976($t0)
	sw $t1, 1104($t0)
	sw $t1, 1232($t0)
	
	sw $t1, 452($t0)
	sw $t1, 460($t0)
	
	sw $t1, 584($t0)
	sw $t1, 712($t0)
	
	
	sw $t1, 344($t0)			# paint the letter E
	sw $t1, 472($t0)
	sw $t1, 600($t0)
	sw $t1, 728($t0)
	sw $t1, 856($t0)
	sw $t1, 984($t0)
	sw $t1, 1112($t0)
	sw $t1, 1240($t0)
	
	sw $t1, 348($t0)
	sw $t1, 352($t0)
	sw $t1, 356($t0)
	sw $t1, 360($t0)
	
	sw $t1, 732($t0)
	sw $t1, 736($t0)
	sw $t1, 740($t0)
	
	sw $t1, 1244($t0)
	sw $t1, 1248($t0)
	sw $t1, 1252($t0)
	sw $t1, 1256($t0)
	
	
	sw $t1, 1928($t0)			# paint the letter O
	sw $t1, 2056($t0)
	sw $t1, 2184($t0)
	sw $t1, 2312($t0)
	sw $t1, 2440($t0)
	sw $t1, 2568($t0)
	sw $t1, 2696($t0)
	sw $t1, 2824($t0)
	sw $t1, 2952($t0)
	
	sw $t1, 1932($t0)
	sw $t1, 1936($t0)
	sw $t1, 1940($t0)
	sw $t1, 1944($t0)
	
	sw $t1, 1948($t0)
	sw $t1, 2076($t0)
	sw $t1, 2204($t0)
	sw $t1, 2332($t0)
	sw $t1, 2460($t0)
	sw $t1, 2588($t0)
	sw $t1, 2716($t0)
	sw $t1, 2844($t0)
	sw $t1, 2972($t0)
	
	sw $t1, 2956($t0)
	sw $t1, 2960($t0)
	sw $t1, 2964($t0)
	sw $t1, 2968($t0)
	
	
	
	sw $t1, 1956($t0)			# paint the letter V
	sw $t1, 2084($t0)
	sw $t1, 2212($t0)
	sw $t1, 2340($t0)
	sw $t1, 2468($t0)
	
	sw $t1, 1976($t0)
	sw $t1, 2104($t0)
	sw $t1, 2232($t0)
	sw $t1, 2360($t0)
	sw $t1, 2488($t0)
	
	sw $t1, 2600($t0)
	sw $t1, 2728($t0)
	
	sw $t1, 2612($t0)
	sw $t1, 2740($t0)
	
	sw $t1, 2860($t0)
	sw $t1, 2864($t0)
	sw $t1, 2988($t0)
	sw $t1, 2992($t0)
	
	

	sw $t1, 1984($t0)			# paint the letter E
	sw $t1, 2112($t0)
	sw $t1, 2240($t0)
	sw $t1, 2368($t0)
	sw $t1, 2496($t0)
	sw $t1, 2624($t0)
	sw $t1, 2752($t0)
	sw $t1, 2880($t0)
	sw $t1, 3008($t0)
	
	sw $t1, 1988($t0)
	sw $t1, 1992($t0)
	sw $t1, 1996($t0)
	sw $t1, 2000($t0)
	sw $t1, 2004($t0)
	
	sw $t1, 2500($t0)
	sw $t1, 2504($t0)
	sw $t1, 2508($t0)
	
	sw $t1, 3012($t0)
	sw $t1, 3016($t0)
	sw $t1, 3020($t0)
	sw $t1, 3024($t0)
	sw $t1, 3028($t0)
	
	
	sw $t1, 2012($t0)			# paint the letter R
	sw $t1, 2140($t0)
	sw $t1, 2268($t0)
	sw $t1, 2396($t0)
	sw $t1, 2524($t0)
	sw $t1, 2652($t0)
	sw $t1, 2780($t0)
	sw $t1, 2908($t0)
	sw $t1, 3036($t0)
	
	sw $t1, 2016($t0)
	sw $t1, 2020($t0)
	sw $t1, 2024($t0)
	sw $t1, 2028($t0)

	sw $t1, 2528($t0)
	sw $t1, 2532($t0)
	sw $t1, 2536($t0)
	sw $t1, 2540($t0)
	
	sw $t1, 2160($t0)
	sw $t1, 2288($t0)
	sw $t1, 2416($t0)
	
	sw $t1, 2672($t0)
	sw $t1, 2800($t0)
	sw $t1, 2928($t0)
	sw $t1, 3056($t0)
	
end_loop:
	add $t8, $zero, $zero			# Reset user input register
	# takes in user input
	li $t9, 0xffff0000 
	lw $t8, 0($t9)
	beq $t8, 0, no_reset
	lw $t8, 4($t9) 
	beq $t8, 0x70, respondP			
no_reset:
	li $v0, 32 				# sleep for 100ms
	li $a0, 100
	syscall
	j end_loop

EXIT:	# The player has selected to exit the game! Show their final score! #
	li $v0, 10
	syscall
