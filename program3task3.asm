#Name: CS 2640.01
#Team:Chenrui Zhang, Aaron lo,Brian Zeng
#Last Version:4/30/2023


#Task 3 Objectives:
#takes practiceFile.txt file and appends to it
#-Store the file descriptor in $s0
#-Write user input to the file

.data
fileName: .space 128
buffer:   .space 128
fileNameEnter: .asciiz "please enter the file you want to open: "
question:   .asciiz "What have you enjoyed most about the class so far?\n"


.text 
main:
    # let user enter filename
    li $v0, 4
    la $a0, fileNameEnter
    syscall

    # Read the file name from user input
    li $v0, 8
    la $a0, fileName
    li $a1, 128
    syscall

    # Remove extra characters from fileName
    jal theNameClean

    # Open the file in append mode
    li $v0, 13
    la $a0, fileName
    li $a1, 1
    li $a2, 0
    syscall


    # Store the file descriptor in $s0
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

    # End the program
    li $v0, 10
    syscall

theNameClean:
    lb $t1, 0($a0)         
    beq $t1, $zero, break   # if the character is null (0x00) break
    beq $t1, 0x0a, replace # if the character is newline (0x0a), replace it with null
    addi $a0, $a0, 1       #add pointer
    j theNameClean   

replace:
    sb $zero, 0($a0)       # store null character (0x00) in place of the newline
    j theNameClean   
break:
    jr $ra                 # return to  theNameClean 
