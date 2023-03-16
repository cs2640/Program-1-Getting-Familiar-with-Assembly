.data               #data section 
	str: .asciiz "Please enter two int values:\n"  
	number: .asciiz "\nThe two int values are: "
	corr: .asciiz " and "

 
.text                 #code section 
main: 
	#print the "Please enter two int values: "
	li $v0, 4                
	la $a0, str              
	syscall  
       	
       	#let user enter first int 
       	li $v0, 5 
	syscall 
	
	#store it to $s0
	move $s0, $v0
	
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
