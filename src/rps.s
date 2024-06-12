# vim:sw=2 syntax=asm
.data
win1: .asciiz "W"
lose1: .asciiz "L"
tied1: .asciiz "T"


.text
  .globl play_game_once

# plays the game for two players
play_game_once:
  move $s7, $ra 
  li	$t6, 0
  li	$t7, 0
  
  add $sp $sp -4
  sw $a0 ($sp)
  jal	gen_byte
  
  add $sp $sp -4
  sw $s3 4($sp)
  move	$s3, $v0
  
  
  jal	gen_byte
  move	$t7, $v0
  move	$t6 $s3
  lw $s3 4($sp)
  add $sp $sp 4
  
# check for the win, lose or tie
  beq	$t6, $t7, tied
  beq	$t6, 0, branch_1
  beq	$t6, 1, branch_2
  beq	$t6, 2, branch_3
  
   
   
  
  
branch_1:
	beq $t7 , 1 , lose
	j win
	
branch_2:
	beq $t7 , 2 , lose
	j win
	
branch_3:
	beq $t7 , 0 , lose
	j win
	
win:

  	la $a0, win1
	li $v0, 4
  	syscall
  	j End
lose:
	
  	la $a0, lose1
	li $v0, 4
  	syscall
  	j End
tied:

  	la $a0, tied1
	li $v0, 4
  	syscall
  	
End:
lw $a0 ($sp)
add $sp $sp 4

move $ra, $s7
jr $ra
