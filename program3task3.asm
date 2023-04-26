#Name: CS 2640.01
#Team:Chenrui Zhang, Aaron lo,Brian Zeng
#Last Version:4/25/2023


#Task 3 Objectives:
#takes practiceFile.txt file and appends to it
#-Store the file descriptor in $s0
#-Write user input to the file

.data
fileName: .asciiz "practiceFile.txt"
buffer:   .space 128
question:   .asciiz "What have you enjoyed most about the class so far?\n"

.text 
main:
    # Open the file in append mode
    li $v0, 13
    la $a0, fileName
    li $a1, 1
    li $a2, 0
    syscall

    # Store the file $s0
    move $s0, $v0

    # Print the answer prompt
    li $v0, 4
    la $a0, question
    syscall

    # Read the string 
    li $v0, 8
    la $a0, buffer
    li $a1, 128
    syscall

    # Write input to the file
    li $v0, 15
    move $a0, $s0
    la $a1, buffer
    li $a2, 128
    syscall

    # Close the file
    li $v0, 16
    move $a0, $s0
    syscall

    # End the program
    li $v0, 10
    syscall
