.data
string:.asciiz "this is a string.\n"
location:.asciiz "the memory location for this string is: "

.text 
main:
	#printing the string
	li $v0, 4
	la $a0, string
	syscall 
	
	#print memory location
	
	li $v0, 4
	la $a0, location
	syscall 
	
	#print the memory location and the number
	la $t0, string
	li $v0, 1
	move $a0, $t0
	syscall 
	
	#writing an integer 32 to memory
	li $t1, 32
	sw $t1, 128($t0)
	
	li $v0, 10
	syscall 