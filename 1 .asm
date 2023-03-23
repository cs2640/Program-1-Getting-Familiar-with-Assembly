#Name: CS 2640 Section 1
#Date:
#Objective: Using values stored in $s0 and $s1
# -add two values
# -subtract two values
# -multiply two values
# -divide two values
# -output the results

.data
add: .asciiz "\nAddition: "
subtract: .asciiz "\nSubtraction: "
multiply: .asciiz "\nMultiplication: "
divide: .asciiz "\nDivision: "

.text
main:
	#add two values
	add $t0, $s0, $s1
	
	#print add
	li $v0, 4
	la $a0, add
	syscall 
	li $v0, 1
	la $a0, ($t0)
	syscall
	
	#sub two values
	sub $t0, $s0, $s1
	
	#print sub
	li $v0, 4
	la $a0, subtract
	syscall 
	li $v0, 1
	la $a0, ($t0)
	syscall
	
	#mult two values
	mul $t0, $s0, $s1
	
	#print mult
	li $v0, 4
	la $a0, multiply
	syscall 
	li $v0, 1
	la $a0, ($t0)
	syscall
	
	#div two values
	div $t0, $s0, $s1
	
	#print div
	li $v0, 4
	la $a0, divide
	syscall 
	li $v0, 1
	la $a0, ($t0)
	syscall
	
exit:
	li $v0, 10
	syscall

