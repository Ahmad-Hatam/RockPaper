# vim:sw=2 syntax=asm
.data

.text
  .globl gen_byte, gen_bit


gen_byte:
# saving the return address
	la $s4 ($ra)
	
#t2 is the counter
	li $t2, 3
# t0 is the first bit and t1 is the second
	li $s5, 0
	li $s6, 0
	

start:
  
  sub $t2, $t2, 1
  
  #loop for the first bit
  beq $t2, 2, loop1
  
  #loop for the second bit
  beq $t2, 1, loop2
  
  add $t4, $s5, $s6
  # if the addition of the the two bits equals 2 (means 11 in binary)
  #it branches to new which resets the changed registers and starts over
  
  beq $t4, 2, new

  # the Concatenation
  sll $s5 $s5 1
  add $s5, $s5, $s6
  
  # moves the answer to v0 for return
  move $v0, $s5
  
  # moves the return address from s4 and returns
  la $ra ($s4)
  jr $ra

loop1:
	add $sp $sp -4
	sb $t2 ($sp)
	
	jal gen_bit
	
	lb $t2 ($sp)
	add $sp $sp 4
	
	move $s5, $v0
	j start
loop2:
	add $sp $sp -4
	sb $t2 ($sp)
	
	jal gen_bit
	
	lb $t2 ($sp)
	add $sp $sp 4

	move $s6, $v0
	j start
new:

  move $ra, $s4
  j gen_byte






gen_bit:
# if eca equals to zero it jumps to eca_zero to generate random bits
  lw $t0 0($a0)
  beqz $t0 eca_zero
  
  add $sp $sp -12
  sw $ra ($sp)
  sw $s1 4($sp)
  sw $a0 8($sp)
  lb $s1 10($a0)
  
# it is the loop for the skips needed
skip_loop:
   
  jal simulate_automaton
  sub $s1 $s1 1
  
  bnez $s1  skip_loop
  
  lb $t1 11($a0)
  lb $t8 8($a0)
  sub $t1 $t8 $t1
  sub $t1 $t1 1
  lw $v0 4($a0)
 
# getting and saving the column 
inner_loop:
  srl $v0 $v0 1
  sub $t1 $t1 1 
  bgtz $t1 inner_loop
  andi $v0 $v0 1
  lw $a0 8($sp)
  lw $s1 4($sp)
  lw $ra ($sp)
  add $sp $sp 12
  jr $ra
  
  
eca_zero:

  sub $sp $sp 4
  sw $a0 ($sp)
  
  
  li	$v0, 40
  lw 	$a1, 4($a0)
  syscall
  
  li $v0,41
  li $a0, 0
  syscall
  
  andi $v0, $a0, 1
  
  lw $a0 ($sp)
  add $sp $sp 4
  
  jr $ra
  
