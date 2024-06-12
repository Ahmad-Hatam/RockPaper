# vim:sw=2 syntax=asm

.data

binary: .space 32
next_gen: .space 32
word: .space 32
dead: .asciiz "_"
alive: .asciiz "X"
line:.asciiz "\n"
.text
  .globl simulate_automaton, print_tape
  

# converts the tape and rule into binary and saves it
simulate_automaton:
	
	
	add $sp $sp -4	
	sw $ra ($sp)
	
	lb $t1, 8($a0)
	sub $t1 $t1 1
	
	#Tape value
	lw $t2, 4($a0)
	
	#Used for binary conversion
	li $t3 , 2
	
	#the address of the space; used to store the values 
	la $t5 , binary
	
	# saving the address of $a0 into $t6, since $a0 will be used for printing
	la $t6, ($a0)
	
	jal convert
	#settings for the conversion of the rule
	la $t5 word
	#la $t6, ($a0)
	li $t1 7
	li $t3 , 2
	lb $t2 9($a0) 
	jal convert

#all the initializations required for ECA
simulate:

	#counter
	li $t1, 0
	#main_counter
	li $t3,0
	#index to look for in the rule number
	li $t2, 0
	
	#contains the length of the tape
	lb $t8 8($a0)
	sub $t8 $t8 1
	
	#stores the next generation
	la $t7 next_gen
	# $t0: the address of the last number ; $t9 address of the first number 
	la $t0, binary($t8)
	la $t9 binary
	
comparison:
	# loop for 3; the number and its neighbors
	ble $t1 2 check
	#saves the number in next_gen
	lb $t1 word($t2)
	sb $t1 ($t6)
	
	# the initialization for the end
	li $t5 0
	la $t6 next_gen
	beq $t3 $t8 end
	
	#the main loop for the whole number
	add $t3 $t3 1
	#initializes the registers to be used in the next loop
	li $t1 0
	li $t2 0
	sub $t9 $t9 1
	sub $t7 $t7 1
	#to check if a circulation is needed
	la $t5 binary
	blt $t9 $t5 circulate_neg
	sub $t9 $t9 1
	sub $t7 $t7 1
	#to check if a circulation is needed
	blt $t9 $t5 circulate_neg2
	j comparison
	
check:
	#to check if circulation is needed
	bgt $t9 $t0 circulate
	beq $t1 1 index
	
counting:
	#checks to see if the value at the location is one
	lb $t5 ($t9)
	beq $t5 1 index_addition
	#else moves to the next location for the next number
	add $t9, $t9, 1
	add $t7 $t7 1
	add $t1 ,$t1, 1
	j comparison
	
index_addition:
	#updates the location and adds the corresponding value to the index, which is then to be looked into the rule
	add $t9, $t9, 1
	add $t7 $t7 1
	beq $t1, 0, power_of_zero
	mul $t4 $t1, 2
	add $t2, $t2, $t4
	add $t1 ,$t1, 1
	j comparison
#if the value of the right neighbor is 1
power_of_zero:
	add $t2, $t2, 1
	add $t1 ,$t1, 1
	j comparison

# to circulate back to the initial address of the the tape and next generatino because of overflow 
circulate:
	la $t9 binary
	la $t7 next_gen
	j check
	
#to circulate back to the address of the last number because of underflow
circulate_neg:
	la $t9 binary($t8)
	la $t7 next_gen($t8)
	sub $t9 $t9 1
	sub $t7 $t7 1
	j comparison
	
circulate_neg2:
	la $t9 binary($t8)
	la $t7 next_gen($t8)
	j comparison
	
	
index:
	# the calculated binary of the next generation will be stored at the location of $t6 
	la $t6 ($t7)
	j counting
	
end:
	#Decimal conversion of the binary stored in next_gen
	bltz $t8 return
	la $t6 next_gen($t8)
	sll $t5 $t5 1
	lb $t7 ($t6)
	add $t5 $t5 $t7
	sub $t8 $t8 1
	j end
# saves the next generation in the tape
return:
	sw $t5	4($a0)
	lw $ra ($sp)
	add $sp $sp 4
	jr $ra


	
to_binary:
	lb $t1, 8($a0)
	sub $t1 $t1 1
	
	#Tape value
	lw $t2, 4($a0)
	
	#Used for binary conversion
	li $t3 , 2
	
	#the address of the space; used to store the values 
	la $t5 , binary
	
	# saving the address of $a0 into $t6, since $a0 will be used for printing
	la $t6, ($a0)
convert:
	#conversion of the number for the length given
	bgez $t1 division
	
	lb $t1, 8($a0)
	sub $t5 $t5 1
	jr $ra
	
division:
	
	#changing the number into binary and saving it.
	div $t2 $t3
	mflo $t2
	mfhi $t4
	sb $t4 ($t5)
	sub $t1 $t1 1
	add $t5 $t5 1
	j convert

  
print_tape:
	add $sp $sp -4
	sw $ra ($sp)
	
	jal to_binary
	lw $ra ($sp)
	add $sp $sp 4

	
#since the numbers are stored in reverse in memory
#starting from the end to the beginning space
reverse_printing:
	bnez $t1 one
	#adding a new line
	li $v0 , 4
	la $a0 line
	syscall	
	#loads the original address of $a0
	la $a0 ($t6)	
	jr $ra
	
#to check: if one print X else _
one:
	lb $t7 ($t5)
	beqz $t7 zero
	lb $a0 alive
	li $v0 11
	syscall
	sub $t1 $t1 1
	sub $t5 $t5 1
	j reverse_printing
	
zero:
	lb $a0 dead
	li $v0 11
	syscall
	sub $t1 $t1 1
	sub $t5 $t5 1
	j reverse_printing
