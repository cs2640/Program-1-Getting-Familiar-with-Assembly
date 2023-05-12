#Name: Chenrui Zhang, Aaron Lo, Brain Zhen
#Class: CS 2640.01 
#Date: May 7, 2023

##############################################################################		
#
#
#
#
#
#
#
#
.data
welcomePrompt: .asciiz "welcome to Vigenere Cipher, Yes to encryption No to decryption"
encryptionPrompt:.asciiz "This is encrypt, get ready for the key and message"
decryptionPrompt:.asciiz "This is decrypt, get ready for the key and message"
keyPrompt: .asciiz "Please enter your key "
messageEnteredPrompt: .asciiz "Please enter the message: "
encryptedFinished: .asciiz "Encrypted complete, click to get your new message "
decryptedFinished: .asciiz "decrypted complete, click to get your new message "

alphabetTable: .word 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
key: .space 10000
messageEntered: .space 10000
newKey: .space 10000
newMessage: .space 10000
		
##############################################################################		
#
#
#
#
#
#
#
#

.text
main:	
	#welcome page
	la $a0, welcomePrompt
	la $a1, 1
	li $v0, 50
	syscall
	
	##show the menu 
	#yes to decryption, 
	beq $a0, 0, encryptionMenu
	#no to decryption
	beq $a0, 1, decryptionMenu
	#cancel to exit
	beq $a0, 2, exit	
		
encryptionMenu:

	# show the encrypt Prompt
	la $a0, encryptionPrompt
	la $a1, 1
	li $v0, 50
	syscall
		
	#show the menu 
	#yes to decryption, 
	beq $a0, 0, encryption
	#No to back to encryption, 
	beq $a0, 1, decryptionMenu
	#cancel to exit
	beq $a0, 2, exit
		
		
decryptionMenu:
	# show the decrypt Prompt
	la $a0,decryptionPrompt
	la $a1, 1
	li $v0, 50
	syscall
		
	#show the menu 
	#yes to decryption,
	beq $a0, 0, decryption
	#No to back to encryption,
	beq $a0, 1, encryptionMenu
	#cancel to exit
	beq $a0, 2, exit
		
##############################################################################		
#  take two input, message and key
#And change it to uppercase to fit in the Vigenère table
#and change the string to Array
#the last step is use the array to use calculate new message 
encryption:
	
	jal takeInputMessage
	 
	jal takeInputKey	
	 
	jal messageToArray
	 
	jal keyToArray	
	 
	jal encryptText	
	 
	jal displayEncryptedMessage
	 
	j main

decryption:
	 
	jal takeInputMessage
	
	jal takeInputKey
	 
	jal messageToArray
	 
	jal keyToArray
	 
	jal outputDecrypt
	
	jal displayDecryptedMessage
	
	j main
	
	
##############################################################################		
# takeInputMessage function prompts the user for input, reads it, and stores it in the 'messageEntered' variable. 
# use messageEnteredToUpper  iterates through the input message (messageEntered) and checks if a character is a lowercase letter (between 'a' and 'z')
#If it is, the function converts the lowercase letter to its uppercase equivalent and saves the change back to the messageEntered variable. 
#This process continues for each character in the input message until the end of the string is reached.
#
#takeInputKey use similar approach with takeInputMessage
takeInputMessage:
	# Prompt user for input, read it, and store it in 'messageEntered'
	la $a0, messageEnteredPrompt
    	la $a1, messageEntered
    	la $a2, 10000
    	#InputDialogString 
    	li $v0, 54
    	syscall
		
	j upperCaseMessage
	
	upperCaseMessage:
   		# Initialize the loop counter
    		li $t1, 0

		messageLoop:
    			# Load the first character into register t0
    			lb $t0, messageEntered($t1)

    			# If we reach the end, jump to the getBack function
    			beqz $t0, getBack

    			# Check if the character is between 'a' and 'z'
    			blt $t0, 'a', incrementMessagePointer
    			bgt $t0, 'z', incrementMessagePointer

    			# If it's a lowercase letter, subtract 32 from the t0 register to make it capital
    			sub $t0, $t0, 32

    			# Save the change to the character to the messageEntered variable
    			sb $t0, messageEntered($t1)

		incrementMessagePointer:
   			 # Increment the pointer
    			add $t1, $t1, 1
    			# Jump back to the start of the loop
    			j messageLoop
		
takeInputKey:
	# Ask the user input a key and save 
	la $a0, keyPrompt
	la $a1, key
	la $a2, 10000
	#InputDialogString
	li $v0, 54
	syscall
		
	# Jump to where we were in either the encryption or decryption functions.
	j upperCaseKey
		
	upperCaseKey:
		# Initialize the loop counter
    		li $t1, 0

		keyLoop:
    			# Load the first character into register t0
   			lb $t0, key($t1)

    			# If we reach the end, jump to the getBack function
    			beqz $t0, getBack
	
    			# Check if the character is between 'a' and 'z'
   			blt $t0, 'a', incrementKeyPointer
    			bgt $t0, 'z', incrementKeyPointer

    			# If it's a lowercase letter, subtract 32 from the t0 register to make it capital
    			sub $t0, $t0, 32

   			# Save the change to the character to the key variable
    			sb $t0, key($t1)

		incrementKeyPointer:
    			# Increment the pointer
    			add $t1, $t1, 1

    			# Jump back to the start of the loop
    			j keyLoop

		
##############################################################################		
#  takes an input string (messageEntered) and converts it into a new array (newMessage) 
#If the character is an uppercase letter (A-Z), it replaces the letter with its index in the alphabetTable array.
#If the character is a newline ('\n'), it replaces the newline with the number 28.
#For any other characters, they are moved to the newMessage array without any conversion.
#The code processes the input string one character at a time, jumping to different sections (labels) based on the character type. 
#After processing each character, it saves the result to the newMessage array, increments the array indices, and moves on to the next character until the end of the input string is reached.
# it appends the number 26 to the end of the newMessage array to indicate the end of the output and jumps to the getBack function.
#
#if I enter ABC 
#I will get 0, 1, 2, 26 for the array
#
#


messageToArray:
	# Load in the characters for the messageEntered and alphabetTable variables respectively.
	lb $t0, messageEntered($t1)

	# Check if we have reached the end of the messageEntered string.
	# If so, jump to finishArray.
	beqz $t0, finishArray

	# Check character type and branch accordingly
	blt $t0, 'A', Newline
	bgt $t0, 'Z', Newline
	j handleCapital

	Newline:
		# Check if the character in the messageEntered variable is a newline.
		beq $t0, '\n', handleNewline
		j handleNoConversion
	
	handleNewline:
    		# Set register t4 to 28; our number that will represent newline.
    		add $t4, $zero, 28
    		j saveCharacterAndIncrement

 			
	handleCapital:
    		# Initialize loop counter for alphabetTable
    		li $t3, 0

		alphabetTableLoop:
   			# Load the character from alphabetTable
    			lb $t2, alphabetTable($t3)

    			# Check if the character for the messageEntered and alphabetTable variables are equal.
    			beq $t0, $t2, storeToVariable

    			# Increment register t3 by 4 to go to the next character in the alphabetTable array.
    			add $t3, $t3, 4

    			# Continue the loop until all characters in the alphabetTable have been checked
    			blt $t3, 104, alphabetTableLoop
    			j handleNoConversion

	    		
    	handleNoConversion:
    		# Move messageEntered's character to the newMessage variable as is.
    		move $t4, $t0
    		j saveCharacterAndIncrement
    		
	storeToVariable:
    		# Set that character to be the index of messageEntered's letter in the alphabetTable array.
    		div $t4, $t3, 4

	saveCharacterAndIncrement:
    		# Save the changes made to the newMessage variable.
    		sb $t4, newMessage($t5)

    		# Increment the addresses of messageEntered and newMessage by 1.
    		add $t1, $t1, 1
    		add $t5, $t5, 1

    		# Jump back to the top of the messageToArray label for the next iteration.
    		j messageToArray

	finishArray:
    		# Load into register t9 our number that will represent the end of a string.
    		li $t6, 26

    		# Move 26 into the newMessage variable.
    		move $t4, $t6

    		# Save the changes made to the newMessage variable.
    		sb $t4, newMessage($t5)
		
    		# Jump to the getBack function.
    		j getBack
		
##############################################################################		
#this function use the same appraoch as messageToArray
 
# The keyToArray function converts the key characters into indices of the alphabetTable.
keyToArray:
	# Retrieve characters from the key and alphabetTable.
	lb $t0, key($t1)

	# If we reach the end of the key string, jump to endConversion1.
	beqz $t0, endConversion1

	# Branch to different handlers based on the type of character (capital or special).
	blt $t0, 'A', handleSpecialKey
	bgt $t0, 'Z', handleSpecialKey
	j handleCapitalKey

# Handle special characters and newline characters in the key.
	handleSpecialKey:
		# If the character is a newline, jump to changeNewline1.
		beq $t0, '\n', changeNewline1
		# For other non-capital letter characters, jump to noConversion1.
		j noConversion1

		# Handle capital letter characters in the key.
	handleCapitalKey:
		# Initialize the alphabetTable loop counter.
		li $t3, 0

		# Loop through the alphabetTable.
		alphabetTableLoopKey:
			# Load a character from the alphabetTable.
			lb $t2, alphabetTable($t3)

			# If the characters in the key and alphabetTable match, jump to storeToVariable1.
			beq $t0, $t2, storeToVariable1

			# Move to the next character in the alphabetTable.
			add $t3, $t3, 4

			# Continue looping until all characters in the alphabetTable are checked.
			blt $t3, 104, alphabetTableLoopKey
			# If no matching character is found, jump to noConversion1.
			j noConversion1

	# Replace newline characters with the value 28.
	changeNewline1:
		# Set t4 to 28 (representing newline).
		add $t4, $zero, 28
		j saveCharacterAndIncrement1

	# Handle characters without conversion.
	noConversion1:
		# Copy the current key character to the newKey variable without conversion.
		move $t4, $t0
		j saveCharacterAndIncrement1

	# Store the index of the key's letter in the alphabetTable array.
	storeToVariable1:
		# Calculate the index and store it in t4.
		div $t4, $t3, 4

	# Save the character/index and increment pointers.
	saveCharacterAndIncrement1:
		# Save the changes made to the newKey variable.
		sb $t4, newKey($t5)

		# Increment the addresses of key and newKey by 1.
		add $t1, $t1, 1
		add $t5, $t5, 1

		# Loop back to the beginning of keyToArray for the next iteration.
		j keyToArray

	# Handle the end of the key string.
	endConversion1:
		# Set t9 to 26 (representing the end of a string).
		li $t6, 26
	
		# Move 26 into the newKey variable to indicate the end of the string.
		move $t4, $t6

    		# Save the changes
    		sb $t4, newKey($t5)

   		 # Jump to the getBack function.
    		j getBack

#########################################################################	
# this function reading characters from two input arrays, one for the newMessage and one for the key named newKey
# During the encryption process, the code iterates through both the message and the key arrays, 
#fetching the characters one by one, performing calculations, and then updating the newMessage array with the encrypted characters.
#
#The core algorithm
#Ei = (Pi + Ki) mod 26
#		

												
encryptText:
	lb $t0, newMessage($t1)    # Load a num from the array
    	beq $t0, 26, finishMessageArray   # If character is 26, end of message, jump to finishMessageArray
    	beq $t0, 28, addNewline     # If character is 28 (newline), jump to addNewline
    	bgt $t0, 25, handleUniqueSymbol   # If character is greater than 25, jump to handleUniqueSymbol
    	bltz $t0, handleUniqueSymbol   # If character is less than 0, jump to handleUniqueSymbol
    
    	lb $t2, newKey($t3)         # Load a character from the key
    	beq $t2, 26, finishKeyArray # If character is 26, end of key, jump to finishKeyArray
    	bgt $t2, 25, handleUniqueSymbol1  # If character is greater than 25, jump to handleUniqueSymbol1
    	bltz $t2, handleUniqueSymbol1  # If character is less than 0, jump to handleUniqueSymbol1
		
		
		
	# Add the character values from the message and the key
	add $t0, $t0, $t2

	# If the sum is greater than 25, jump to morethan25
	bgt $t0, 25, morethan25
	
	# If the sum is less than or equal to 25, jump to continue
	ble $t0, 25, countinue

	# Subtract 26 from the sum to wrap around the alphabet
	morethan25:
		sub $t0, $t0, 26
		# Jump to continue
		j countinue

	# Multiply the sum by 4 to use it as an offset in alphabetTable
	countinue:
		mul $t0, $t0, 4

		# Move the sum to $t5
		move $t5, $t0

		# Load the corresponding character from alphabetTable using the offset
		lb $t4, alphabetTable($t5)

		# Move the character to $t0
		move $t0, $t4

		# Store the encrypted character in the newMessage array
		sb $t0, newMessage($t1)

		# Increment the message index
		add $t1, $t1, 1

		# Increment the key index
		add $t3, $t3, 1

		# Jump back to the beginning of encryptText
		j encryptText

	# Clear $t0
	finishMessageArray:
		move $t0, $zero

		# Store the null terminator at the end of the newMessage array
		sb $t0, newMessage($t1)

	# Jump to getBack
	j getBack

	# Load newline character into $t0
	addNewline:
		add $t0, $zero, '\n'

		# Store the newline character in the newMessage array
		sb $t0, newMessage($t1)

		# Increment the message index
		add $t1, $t1, 1

		# Jump back to the beginning of encryptText
		j encryptText

	# Clear $t3
	finishKeyArray:
		move $t3, $zero
		# Jump back to the beginning of encryptText
		j encryptText

	# Increment the message index
	handleUniqueSymbol:
		add $t1, $t1, 1
		# Jump back to the beginning of encryptText
		j encryptText

	# Increment the key index
	handleUniqueSymbol1:
		add $t3, $t3, 1
		# Jump back to the beginning of encryptText
		j encryptText
		
###########################################################################		
# The only diffence is this function has a temporary register to save all output
#
#
#The core algorithm
#Di = (Ei - Ki + 26) mod 26
#
#			
decryptText:
	lb $t0, newMessage($t1)    # Load a character from the encrypted message
	beq $t0, 26, finishMessageArray2   # If character is 26, end of message, jump to finishMessageArray2
	beq $t0, 28, addNewline2     # If character is 28 (newline), jump to addNewline2
	bgt $t0, 26, handleUniqueSymbol2   # If character is greater than 26, jump to handleUniqueSymbol2
	bltz $t0, handleUniqueSymbol2   # If character is less than 0, jump to handleUniqueSymbol2

	lb $t2, newKey($t3)         # Load a character from the key
	beq $t2, 26, finishKeyArray2 # If character is 26, end of key, jump to finishKeyArray2
	bgt $t2, 26, handleUniqueSymbol12  # If character is greater than 26, jump to handleUniqueSymbol12
	bltz $t2, handleUniqueSymbol12  # If character is less than 0, jump to handleUniqueSymbol12

	# sub the character values from the message and the key
	sub $t0, $t0, $t2 
	
	# If the sum is less than 1, jump to morethan25
	bgt $t0, -1, countinue1
	
	# If the sum is more than or equal to 0, jump to continue1
	bltzal $t0, lessThan0 
	
	# add 26 from the sum to wrap around the alphabet
	lessThan0:
		#use the mod 26 to get back the real index
		add $t0, $t0, 26
		# Jump to continue
		j countinue1
		
		countinue1:
			# Multiply that number by 4 to get the address of the letter in the alphabetTable array and put it in register t0
			mul $t5, $t0, 4
			# Load up the corresponding letter in the alphabetTable array
			lb $t4, alphabetTable($t5)
			# Move that letter to the decryptedCipher variable
			move $t0, $t4
			# Save the changes we made to the decryptedCipher variable
			sb $t0, newMessage($t1)

			# Increment the addresses of the encrypted message and the key by 1
			add $t1, $t1, 1
			add $t3, $t3, 1

			# Jump back to the beginning of decryptText
			j decryptText
		finishMessageArray2:
			# Change the character in decryptedCipher back to NULL
			move $t0, $zero
			# Save the changes we made to the decryptedCipher variable
			sb $t0, newMessage($t1)

			 # Restore the return address from the temporary register 
    			move $ra, $t8
			# Jump to the getBack function
			j getBack
			
		outputDecrypt:
    			# Save the return address in a temporary register
    			move $t8, $ra

    			# Jump to the decryptText function.
    			j decryptText
    		
    		
    		
	handleUniqueSymbol2:
		# Increment the address of the encrypted message by 1
		add $t1, $t1, 1
		# Jump back to the beginning of decryptText
		j decryptText

	handleUniqueSymbol12:
		# Increment the address of the key by 1
		add $t3, $t3, 1
		# Jump back to the beginning of decryptText
		j decryptText


	addNewline2:
		# Set register t0 to the newline return character
		add $t0, $zero, '\n'
		# Save the changes made to the decryptedCipher variable
		sb $t0, newMessage($t1)
		# Increment the address of decryptedCipher by 1 to go to the next character
		add $t1, $t1, 1
		# Jump back to the beginning of decryptText
		j decryptText

	finishKeyArray2:
		# Clear register t3 to start the key back over from the beginning
		move $t3, $zero
		# Jump back to the beginning of decryptText
		j decryptText
		
#####################################################################################		
#two helper function
#the first one can get back to where it break
#the second one can exit the program
getBack:
		#move all register to 0
		move $t0, $zero
		move $t1, $zero
		move $t2, $zero
		move $t3, $zero
		move $t4, $zero
		move $t5, $zero
		# Return to whatever function we may be coming from.
		jr $ra																																								
exit:
		# Exit the program.
		la $v0, 10
		syscall
																																							
	

#####################################################################################
#print the mips dialogo box and output the message

displayEncryptedMessage:
	# Inform the user that the encryption was completed.
	la $a0, encryptedFinished
	la $a1, 1
	li $v0, 55
	syscall
    	# Inform the user that the encryption was completed.
	la $a0, newMessage
	la $a1, 1
	li $v0, 55
	syscall
	jr $ra
    		
  displayDecryptedMessage:
	# Inform the user that the encryption was completed.
	la $a0, decryptedFinished
	la $a1, 1
	li $v0, 55
	syscall
    	# Inform the user that the encryption was completed.
	la $a0, newMessage
	la $a1, 1
	li $v0, 55
	syscall	
   		
    	# Return to where we were in the encryption function
    	jr $ra
	
		
	
	
