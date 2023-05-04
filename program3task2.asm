#CS2640.01
#Aaron Lo, Brian Zeng, Chenrui Zhang
#Due: May 7, 2023
#Task 2 Objective:
# - Open file
# - Print file contents

.data
fileName: .asciiz "practiceFile.txt"
inputBuffer: .space 512

.text
main:
	#Open file
	li $v0, 13
	la $a0, fileName
	la $a1, 0 #read file
	la $a2, 0 #ignored
	syscall
	
	#Read file
	move $a0, $v0
	li $v0, 14
	la $a1, inputBuffer
	la $a2, 512
	syscall
	
	#Print file contents
	move $a0, $a1
	li $v0, 4
	syscall
	
exit:
	li $v0, 10
	syscall
