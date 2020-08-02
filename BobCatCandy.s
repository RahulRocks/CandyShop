.data 
str0:		.asciiz "Welcome to BobCat Candy, home to the famous BobCat Bars!\n"  
price:		.asciiz	"Please enter the price of a BobCat Bar: \n" 
wrappers:	.asciiz	"Please enter the number of wrappers needed to exchange for a new bar: \n"
money:		.asciiz	"How, how much do you have? \n"
working:	.asciiz	"Good! Let me run the number ...\n" 
buy:		.asciiz	"You first buy " # syscall 1
get:		.asciiz	"Then, you will get another " 
bars:		.asciiz	" bars.\n"  
first:		.asciiz	"With $" 
middle:		.asciiz	", you will receive a maximum of "  
last:		.asciiz	" BobCat Bars!\n"
# Declare any necessary data here



.text

main:
		#This is the main program.
		# display welcome statement
		li	$v0, 4
		la	$a0, str0
		syscall	
		
		#It first asks user to enter the price of each BobCat Bar.
		li	$v0, 4
		la	$a0, price
		syscall	
		# read user input
		li	$v0, 5 # get user input and put in $s0
		syscall
		move $s0, $v0
		
		#It then asks user to enter the number of bar wrappers needed to exchange for a new bar.
		li	$v0, 4
		la	$a0, wrappers
		syscall	
		# read user input
		li	$v0, 5 # get user input and put in $s1
		syscall
		move $s1, $v0
		
		#It then asks user to enter how much money he/she has.
		li	$v0, 4
		la	$a0, money
		syscall	
		# read user input
		li	$v0, 5 # get user input and put in $s2
		syscall
		move	$s2, $v0
		
		#It prints a message telling that it is calculating.
		li	$v0, 4
		la	$a0, working
		syscall	
		
		beqz	$s0, dontDivByZero
		beqz	$s2, dontDivByZero
		#If you cant buy any bars with the money you have then do not print how many you can buy
		blt 	$s2, $s0, calculateAdditionalBars
		
		#It then prints out a statement about how many bars have to be bought.
		li	$v0, 4
		la	$a0, buy
		syscall	
		
		div	$a0, $s2, $s0
		li	$v0, 1
		syscall	
		
		li	$v0, 4
		la	$a0, bars
		syscall	
		
		addi	$sp, $sp -4	# Feel free to change the increment if you need for space.
		sw	$ra, 0($sp)
		# Implement your main here

calculateAdditionalBars:
		#It then calls maxBars function to perform calculation of the maximum BobCat Bars the user will receive based on the information entered. 
		move	$a0, $s1
		move	$a1, $s0
		move	$a2, $s2
		jal	maxBars 	# Call maxBars to calculate the maximum number of BobCat Bars

		move	$s3, $v0   # save response in $s3
		
dontDivByZero:	# Print out final statement here
		#It then prints out a statement about the maximum BobCat Bars the user will receive.
		li	$v0, 4
		la	$a0, first
		syscall	
		
		addi	$a0, $s2, 0
		li	$v0, 1
		syscall	
		
		li	$v0, 4
		la	$a0, middle
		syscall	

		move	$a0, $s3
		li	$v0, 1
		syscall	
		
		li	$v0, 4
		la	$a0, last
		syscall	
		j end			# Jump to end of program


maxBars:
		# This function calculates the maximum number of BobCat Bars.
		# It takes in 3 arguments ($a0, $a1, $a2) as n, price, and money. It returns the maximum number of bars
		addi	$sp, $sp -4	# Feel free to change the increment if you need for space.
		sw	$ra, 0($sp)

		move	$a1, $a0
		div	$a0, $s2, $s0
		jal	newBars  # Call a helper function to keep track of the number of bars.

		lw	$ra, 0($sp) # retrievereturnaddress
		addi	$sp, $sp, 4	# Pop stack frame
		
		jr	$ra
		# End of maxBars

newBars:
		# This function calculates the number of BobCat Bars a user will receive based on n.
		# It takes in 2 arguments ($a0, $a1) as number of wrappers left so far and n.
		addi	$sp, $sp -4	# Feel free to change the increment if you need for space.
		sw	$ra, 0($sp)
		add	$s4, $s4, $a0
		blt	$a0, $a1, end_recursion
		beqz	$a1, end_recursion
		
		move	$t1, $a0
		
		li	$v0, 4
		la	$a0, get
		syscall	
		
		div	$a0, $t1, $a1
		li	$v0, 1
		syscall	
		
		li	$v0, 4
		la	$a0, bars
		syscall	
		
		div	$a0, $t1, $a1

		jal	newBars
		# End of newBars
		
end_recursion:
		lw	$ra, 0($sp) # retrievereturnaddress
		addi	$sp, $sp, 4	# Pop stack frame 
		move	$v0, $s4
		jr	$ra

end: 
		# Terminating the program
		lw	$ra, 0($sp)
		addi	$sp, $sp 4
		li	$v0, 10 
		syscall
