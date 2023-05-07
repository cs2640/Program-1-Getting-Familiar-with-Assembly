#Name: Chenrui Zhang, Aaron Lo, Brain Zhen
#Class: CS 2640.01 
#Date: May, 2023


.data
welcomePrompt: .asciiz "welcome to Vigenere Cipher, Yes to encryption No to decryption"
encryptionPrompt:.asciiz "This is encrypt, get ready for the key and message"
decryptionPrompt:.asciiz "This is decrypt, get ready for the key and message"
keyPrompt: .asciiz "Please enter your key "
messageEnteredPrompt: .asciiz "Please enter the messageEntered to be encrypted or decrypt: "
encryptedFinished: .asciiz "Encrypted complete, click to get your new message "
decryptedFinished: .asciiz "decrypted complete, click to get your new message "

alphabetTable: .word 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
key: .space 10000
messageEntered: .space 10000
newKey: .space 10000
newMessage: .space 10000


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
	la $a0, decryptionPrompt
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

# Vigenere Cipher:
#	Encryption:
#		Step 1: Take key and convert each character to 0-25 format.
#		Step 2: Take messageEntered and convert it to 0-25 format.
#		Step 3: Use the equation "C_i = E_K * M_i = (M_i + K_i) Mod 26" to encrypt the messageEntered.
#		Step 4:	Succesfully display the encrypted message to the user.
#	Decryption:
#		Step 1: Take key and convert it to 0-25 format.
#		Step 2: Take cipher and convert it to 0-25 format.
#		Step 3: Use the equation "M_i = D_K * C_i = (C_i - K_i) Mod 26" to decrypt the messageEntered.
#		Step 4: Succesfully display the encrypted message to the user.


encryption:
	#
	jal takeInputMessage
	# 
	jal takeInputKey	
	# 
	jal messageToArray
	# 
	jal convertKey	
	# 
	jal encryptText	
	# 
	jal displayEncryptedMessage
	# 
	j exit

decryption:
	# 
	jal takeInputMessage
	#
	jal takeInputKey
	# 
	jal messageToArray
	# 
	jal convertKey
	# 
	jal saveSpot
	#
	jal displayDecryptedMessage
	# Jump to the exit function.
	j exit
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
		
	j messageEnteredToUpper
	
	messageEnteredToUpper:
   		# Initialize the loop counter
    		li $t1, 0

		messageLoop:
    			# Load the first character into register t0
    			lb $t0, messageEntered($t1)

    			# If we reach the end, jump to the returnToMain function
    			beqz $t0, returnToMain

   			# Increment our character counter by 1 if we're not at the end
    			add $s0, $s0, 1

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
	j keyToUpper
		
	keyToUpper:
		# Initialize the loop counter
    		li $t1, 0

		keyLoop:
    			# Load the first character into register t0
   			lb $t0, key($t1)

    			# If we reach the end, jump to the returnToMain function
    			beqz $t0, returnToMain
	
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
# takes an input string (messageEntered) and converts it into a new string (newMessage) based on a given alphabetTable
#
#
#
#		
#
#
#
# 
#
#
#
#
#
#


messageToArray:
	# Load in the characters for the messageEntered and alphabetTable variables respectively.
	lb $t0, messageEntered($t1)
	lb $t2, alphabetTable($t3)

	# Check if we have reached the end of the messageEntered string.
	# If so, jump to endConversion.
	beqz $t0, endConversion

	# Check if the character in the messageEntered variable is a newline.
	beq $t0, '\n', handleNewline

	# Check if the character in the messageEntered variable is not a capital letter.
	blt $t0, 'A', handleNoConversion
	bgt $t0, 'Z', handleNoConversion

	handleConversion:
		# Check if the character for the messageEntered and alphabetTable variables are equal.
		beq $t0, $t2, storeToVariable

		# Increment register t3 by 4 to go to the next character in the alphabetTable array.
		add $t3, $t3, 4

		# Jump back to the messageToArray label for the next iteration.
		j messageToArray

	handleNewline:
		# Set register t4 to 28; our number that will represent newline.
		add $t4, $0, 28

		# Jump to saveCharacterAndIncrement to save the character and increment addresses.
		j saveCharacterAndIncrement

	handleNoConversion:
		# Move messageEntered's character to the newMessage variable as is.
		move $t4, $t0

		# Jump to saveCharacterAndIncrement to save the character and increment addresses.
		j saveCharacterAndIncrement

	storeToVariable:
		# Set that character to be the address of messageEntered's letter in the alphabetTable array.
		div $t4, $t3, 4

	saveCharacterAndIncrement:
		# Save the changes made to the newMessage variable.
		sb $t4, newMessage($t5)
	
		# Increment the addresses of messageEntered and newMessage by 1.
		add $t1, $t1, 1
		add $t5, $t5, 1

		# Reset the alphabetTable index register t3 to 0.
		move $t3, $0

		# Jump back to the top of the messageToArray label for the next iteration.
		j messageToArray
	
	endConversion:
		# Load into register t9 our number that will represent the end of a string.
		la $t9, 26

		# Load up the character in the newMessage variable.
		lb $t4, newMessage($t5)

		# Move 26 into the newMessage variable.
		move $t4, $t9

		# Save the changes made to the newMessage variable.
		sb $t4, newMessage($t5)

		# Jump to the returnToMain function.
		j returnToMain	
		
##############################################################################		
 
	 
	convertKey:
		# Load in the characters for the key and alphabetTable variables respectively.
		lb $t0, key($t1)
		lb $t2, alphabetTable($t3)
		
		# If we reach the end of the key string, jump to the endConversion1 function.
		beqz $t0, endConversion1
		
		# Depending on the character, apply the appropriate conversion.
		beq $t0, '\r', changeCarriage1
		beq $t0, '\n', changeNewline1
		beq $t0, '\t', changeTab1
		
		# If the character in the key variable is not a capital letter, jump to the noConversion1 function.
		blt $t0, 'A', noConversion1
		bgt $t0, 'Z', noConversion1
		
		# If the character for the key and alphabetTable variables are equal, jump to the storeToVariable1 function.
		beq $t0, $t2, storeToVariable1
		
		# Increment register t3 by 4 to go to the next character in the alphabetTable array.
		add $t3, $t3, 4
		
		# Jump to the convertKey function.
		j convertKey
		
	endConversion1:
		# Load into register t9 our number that will represent the end of a string.
		la $t9, 26
	
		# Load up the character in the newKey variable.
		lb $t4, newKey($t5)
		
		# Move 26 into the newKey variable.
		move $t4, $t9
		
		# Save the changes made to the newKey variable.
		sb $t4, newKey($t5)
		
		# Jump to the returnToMain function.
		j returnToMain	
	changeCarriage1:
		# Load up a character of the newKey variable.
		lb $t4, newKey($t5)
		
		# Set register t4 to 27; our number that will represent carriage return.
		add $t4, $0, 27
		
		# Save the changes made to the newKey variable.
		sb $t4, newKey($t5)
		
		# Increment the addresses of the key and the newKey variables.
		add $t1, $t1, 1
		add $t5, $t5, 1
		
		# Jump back to the top of the convertKey variable.
		j convertKey
	changeNewline1:
		# Load up a character of the newKey variable.
		lb $t4, newKey($t5)
		
		# Set register t4 to 28; our number that will represent newline.
		add $t4, $0, 28
		
		# Save the changes made to the newKey variable.
		sb $t4, newKey($t5)
		
		# Increment the addresses of the key and the newKey variables.
		add $t1, $t1, 1
		add $t5, $t5, 1
		
		# Jump back to the top of the convertKey variable.
		j convertKey	
	changeTab1:
		# Load up a character of the newKey variable.
		lb $t4, newKey($t5)
		
		# Set register t4 to 29; our number that will represent tab.
		add $t4, $0, 29
		
		# Save the changes made to the newKey variable.
		sb $t4, newKey($t5)
		
		# Increment the addresses of the key and the newKey variables.
		add $t1, $t1, 1
		add $t5, $t5, 1
		
		# Jump back to the top of the convertKey variable.
		j convertKey
				
	noConversion1:
		# Load up the character in the newKey variable.
		lb $t4, newKey($t5)
		
		# Move key's character to the newKey variable as is.
		move $t4, $t0
		
		# Save the changes made to the newKey variable.
		sb $t4, newKey($t5)
		
		# Increment the addresses of key and newKey by 1.
		add $t1, $t1, 1
		add $t5, $t5, 1
		
		# Jump to the top of the convertKey function.
		j convertKey
		
	storeToVariable1:
		# Load up the character in the newKey variable.
		lb $t4, newKey($t5)
		
		# Set that character to be the address of key's letter in the alphabetTable array.
		div $t4, $t3, 4
		
		# Save the changes made to the newKey variable.
		sb $t4, newKey($t5)
		
		# Clear register t3 of it's contents.
		move $t3, $0
		
		# Increment the addresses of key and newKey by 1.
		add $t1, $t1, 1
		add $t5, $t5, 1
		
		# Jump to the top of the convertKey function.
		j convertKey	
##############################################################################		
# takeInputMessage function prompts the user for input, reads it, and stores it in the 'messageEntered' variable. 
#
#
#
#
#
#							
	encryptText:
		# Load in a character from the newMessage and newKey variables respectively.
		lb $t0, newMessage($t1)
		lb $t2, newKey($t3)
		
		# Depending on which non-letter we encounter, apply the appropriate conversion.
		beq $t0, 26, finalConversion1
		beq $t0, 27, carriageConversion1
		beq $t0, 28, newlineConversion1
		beq $t0, 29, tabConversion1
		
		# If we reach the end of the newKey variable, jump to the clearKey variable.
		beq $t2, 26, clearKey1
		
		# If the newMessage or newKey variable's ASCII code is higher than 25 or lower than 0, 
		# it's not a converted letter, so jump to the noConversionM or noConversionK function.
		bgt $t0, 25, noConversionM
		bltz $t0, noConversionM
		bgt $t2, 25, noConversionK
		bltz $t2, noConversionK
		
		
		#	VIGENERE ENCRYPTION ALGORITHM:	C_i = E_K * M_i = (M_i + K_i) Mod 26	#
		
		# Get the sum of the messageEntered and key's letters while they are in 0-25 format and store it in register t0.
		add $t0, $t0, $t2
		
		# Set register t0 to the quotient of 26 and the previously found sum.
		div $t0, $t0, 26
		
		# Move the contents of HI to register t0. This achieves the same effect as modulus. 
		mfhi $t0
		
		
		
		# Multiply the previous number by 4 to get the address of the corresponding letter in the alphabetTable array.
		mul $t0, $t0, 4
		
		# Move that address into register t5.
		move $t5, $t0
		
		# Load up the character associated with that address.
		lb $t4, alphabetTable($t5)
		
		# Move that letter into the newMessage variable.
		move $t0, $t4
		
		# Save the changes we made to the newMessage variable.
		sb $t0, newMessage($t1)
		
		# Increment the addresses of newMessage and newKey by 1.
		add $t1, $t1, 1
		add $t3, $t3, 1
		
		# Jump back up to the top of the encryptText variable.
		j encryptText
		
		
	finalConversion1:
		# Change 26 back to the ASCII code for NULL in the newMessage variable.
		move $t0, $0
		
		# Save the changes made to the newMessage variable.
		sb $t0, newMessage($t1)
		
		# Jump to the returnToMain function.
		j returnToMain
	carriageConversion1:
		# Set register t0 to the carriage return character.
		add $t0, $0, '\r'
		
		# Save the changes made to the newMessage variable.
		sb $t0, newMessage($t1)
		
		# Increment the address of newMessage by 1 to go to the next character.
		add $t1, $t1, 1
		
		# Jump to the encryptText function.
		j encryptText
	newlineConversion1:
		# Set register t0 to the newline character.
		add $t0, $0, '\n'
		
		# Save the changes made to the newMessage variable.
		sb $t0, newMessage($t1)
		
		# Increment the address of newMessage by 1 to go to the next character.
		add $t1, $t1, 1
		
		# Jump to the encryptText function.
		j encryptText	
	tabConversion1:
		# Set register t0 to the horizontal tab character.
		add $t0, $0, '\t'
		
		# Save the changes made to the newMessage variable.
		sb $t0, newMessage($t1)
		
		# Increment the address of newMessage by 1 to go to the next character.
		add $t1, $t1, 1
		
		# Jump to the encryptText function.
		j encryptText
	clearKey1:
		# Clear the address of the newKey to start over from the beginning.
		move $t3, $0
		
		# Jump back up to the top of the encryptText variable.
		j encryptText		
	noConversionM:
		# Increment the address of the newMessage variable by 1.
		add $t1, $t1, 1
		
		# Jump back up to the top of the encryptText variable.
		j encryptText
		
	noConversionK:
		# Increment the address of the newKey variable by 1.
		add $t3, $t3, 1
		
		# Jump back up to the top of the encryptText variable.
		j encryptText
		
	decryptText:
		# Load an individual character from the decryptedCipher and newKey variable.
		lb $t0, newMessage($t1)
		lb $t2, newKey($t3)
		
		# If we reach the end the end of the cipher text, jump to the finalConversion2 function.
		beq $t0, 26, finalConversion2
		beq $t0, 27, carriageConversion2
		beq $t0, 28, newlineConversion2
		beq $t0, 29, tabConversion2
		
		# If we reach the end of the key, jump to the clearKey2 function.
		beq $t2, 26, clearKey2
		
		# If the ASCII code is higher than 26, jump to the noConversionC or no ConversionK1.
		bgt $t0, 26, noConversionC
		bltz $t0, noConversionC
		bgt $t2, 26, noConversionK1
		bltz $t2, noConversionK1
		
		
		#	VIGENERE DECRYPTION ALGORITHM: 	M_i = D_K * C_i = (C_i - K_i) Mod 26	#
		
		# Get the difference between the cipher text and key's character and store it in register t0.
		sub $t0, $t0, $t2
		
		# Divide that difference by 26 and store it in register t0.
		div $t0, $t0, 26
		
		# Get the modulus answer from HI and store it in register t0.
		mfhi $t0
		
		# If our answer is negative, jump to the getEndLetter function.
		bltzal $t0, getEndLetter
		
		
		
		# Multiply that number by 4 to get the address of the letter in the alphabetTable array and put it in register t0.
		mul $t5, $t0, 4
		
		# Load up the corresponding letter in the alphabetTable array.
		lb $t4, alphabetTable($t5)
		
		# Move that letter to the decryptedCipher variable.
		move $t0, $t4
		
		# Save the changes we made to the decryptedCipher variable.
		sb $t0, newMessage($t1)
		
		# Increment the addresses of the cipher text and the key by 1.
		add $t1, $t1, 1
		add $t3, $t3, 1
		
		# Jump to the decryptText function.
		j decryptText
	finalConversion2:
		# Change the character in decryptedCipher back to NULL.
		move $t0, $0
		
		# Save the changes we made to the decryptedCipher variable.
		sb $t0, newMessage($t1)
		
		# Get the old return address for the decryption function back.
		lw $ra, 0($sp)
		add $sp, $sp, 4
		
		# Jump to the returnToMain function.
		j returnToMain
	carriageConversion2:
		# Set register t0 to the carriage return character.
		add $t0, $0, '\r'
		
		# Save the changes made to the decryptedCipher variable.
		sb $t0, newMessage($t1)
		
		# Increment the address of decryptedCipher by 1 to go to the next character.
		add $t1, $t1, 1
		
		# Jump to the decryptText function.
		j decryptText
	newlineConversion2:
		# Set register t0 to the newline return character.
		add $t0, $0, '\n'
		
		# Save the changes made to the decryptedCipher variable.
		sb $t0, newMessage($t1)
		
		# Increment the address of decryptedCipher by 1 to go to the next character.
		add $t1, $t1, 1
		
		# Jump to the decryptText function.
		j decryptText
	tabConversion2:
		# Set register t0 to the horizontal tab character.
		add $t0, $0, '\t'
		
		# Save the changes made to the decryptedCipher variable.
		sb $t0, newMessage($t1)
		
		# Increment the address of decryptedCipher by 1 to go to the next character.
		add $t1, $t1, 1
		
		# Jump to the decryptText function.
		j decryptText
	clearKey2:
		# Clear register t3 to start the key back over from the beginning.
		move $t3, $0
		
		# Jump to the decryptText function.
		j decryptText
	noConversionC:
		# Add 1 to register t1 to go on to the next character.
		add $t1, $t1, 1
		
		# Jump to the decryptText function.
		j decryptText
	
	noConversionK1:
		# Increment the address of t3 by 1 to go to the next character.
		add $t3, $t3, 1
		
		# Jump to the decryptText function.
		j decryptText															
	getEndLetter:
		# Subtract 26 from the negative number we got to get the actual number.
		add $t0, $t0, 26
		
		# Jump back to where we were in the decryptText function.
		jr $ra
		
	returnToMain:
		# Clear all the odd registers to prevent errors when loading characters after this.
		move $t0, $zero
		move $t1, $zero
		move $t2, $zero
		move $t3, $zero
		move $t4, $zero
		move $t5, $zero
		# Return to whatever function we may be coming from.
		jr $ra																																								
																																							
	saveSpot:
		# Save the return address we just made.
		add $sp, $sp, -4
		sw $ra, 0($sp)
		
		# Jump to the decryptText function.
		j decryptText

#####################################################################################
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
	
		
	
	exit:
		# Exit the program.
		la $v0, 10
		syscall