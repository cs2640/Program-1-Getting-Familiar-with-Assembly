#Name: CS 2640.01
#Team:Chenrui Zhang, Aaron lo,Brian Zeng
#Last Version:3/23/2023

#Task 1 Objectives:
#-take two int from user
#-store two int in $s0 and $s1, respectively
#display two int to user

##Task 2 Objectives: 
#-Using values stored in $s0 and $s1 from Task 1
# -add two values
# -subtract two values
# -multiply two values
# -divide two values
# -output the results


.data               
#task1 data section 
	num1: .asciiz "Please enter int values:\n"  
	num2: .asciiz "Please enter another int values:\n"  
	number: .asciiz "\nThe two int values are: "
	corr: .asciiz " and "

#task2 data section 
	add: .asciiz "\nAddition: "
	subtract: .asciiz "\nSubtraction: "
	multiply: .asciiz "\nMultiplication: "
	divide: .asciiz "\nDivision: "

#task3 data section


.text                  
main: 
#task 1 code section
	#print the "Please enter two int values: "
	li $v0, 4                
	la $a0, num1              
	syscall  
       	
       	#let user enter first int 
       	li $v0, 5 
	syscall 
	
	#store it to $s0
	move $s0, $v0

	#print the "Please enter two int values: "
	li $v0, 4                
	la $a0, num2              
	syscall  
	
	#let user enter second int 
	li $v0, 5 
	syscall 
	
	#store it to $s1
	move $s1, $v0
	
	#print the store $s0 int
	li $v0, 4                 
	la $a0, number              
	syscall  
	
	li $v0, 1                
	move $a0, $s0              
	syscall  
	
	#print "and"
	li $v0, 4                 
	la $a0, corr             
	syscall  
	
	#print the store $s1 int
	li $v0, 1                
	move $a0, $s1              
	syscall  


#task 1 code section
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

#task3 code section


exit:#finish the code section
	li $v0, 10
	syscall
