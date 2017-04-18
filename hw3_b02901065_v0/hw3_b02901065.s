.data
	n:	
		.word	0	
	c:	
		.word	0
	comma:	
		.word	0
	output:	
		.word	0

# TODO : change the file path to access the files for testing your result(IN ABSOLUTE PATH)
#        but change back to input.txt and output.txt when you upload your homework
	file_in:
		.asciiz	"input.txt"
	file_out:
		.asciiz	"output.txt"
		
# the following data is only for sample demonstration		
	output_ascii:	
		.byte	'0', '0', '3', '6'

.text
	main:    #start of your program

#STEP1: open input file
# ($s0: fd_in)

	li	$v0, 13			# 13 = open file
	la	$a0, file_in		# $a2 <= filepath
	li	$a1, 0x4000		# $a1 <= flags = 0x4000 for Windows, 0x0000 for Linux
	li	$a2, 0			# $a2 <= mode = 0
	syscall				# $v0 <= $s0 = fd
	move	$s0, $v0		# store fd_in in $s0, fd_in is the file descriptor just returned by syscall

#STEP2: read inputs (chars) from file to registers
# ($s1: n, $s2: c)

#   2 bytes for n
	li	$v0, 14			# 14 = read from file
	move	$a0, $s0		# $a0 <= fd_in
	la	$a1, n			# $a1 <= n
	li	$a2, 2			# read 2 byte to the address given by n
	syscall
	
#   1 byte for the comma
	li	$v0, 14			# 14 = read from file
	move	$a0, $s0		# $a0 <= fd_in
	la	$a1, comma		# $a1 <= comma
	li	$a2, 1			# read 1 bytes to the address given by comma
	syscall
	
#   2 bytes for c
	li	$v0, 14			# 14 = read from file
	move	$a0, $s0		# $a0 <= fd_in
	la	$a1, c			# $a1 <= c
	li	$a2, 2			# read 2 byte to the address given by c
	syscall

#STEP3: turn the chars into integers
	la	$a0, n		
	bal	atoi			 
	move	$s1, $v0		# $s1 <= atoi(n)

	la	$a0, c		
	bal	atoi			 
	move	$s2, $v0		# $s2 <= atoi(c)

################################ write your code below ################################
# Inputs are ($s1: n, $s2: c)
# Output is $s3 (in integer)
	add $a0, $s1, $zero
	jal algo
	add $s3, $v0, $zero	
	j result

#STEP4: implement recursive function to solve the equation 
algo:
	li $v0, 0
	slti $v0 $a0, 2
	mul $v0, $s2, $v0
	beq $v0, $zero, L1
	jr $ra
	
L1:
	addi $sp, $sp -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	li $t0, 2
	div $a0 $t0
	mflo $a0
	jal algo
	lw $a0, 0($sp)
	li $t0 2
	mul $v0, $v0, $t0 
	mul $t1, $s2, $a0
	add $v0, $v0, $t1
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
#STEP5: turn the integer into printable char
    # transferred ASCII should be put into "output_ascii"(see definition in the beginning of the file)
result:
	sw	$s3, output	# output <= $s3	
	move	$a0, $s3
	bal	itoa		# itoa($s3)

	# TODO: store return array to output_ascii
	
	jr	ret

itoa:
	# Input: ($a0 = input integer)
	# Output: ( output_ascii )
	# TODO: (you should turn an integer into a pritable char with the right ASCII code to output_ascii)
	la	$t0, output_ascii
	li	$t1, 1000
	li	$t4, 10
	li	$t2, 4
Loop:
	beq $t2, $zero, Exit
	div $a0, $t1
	mflo $t3
	mfhi $a0
	addi $t3, $t3, 48
	sb $t3, 0($t0)
	addi $t0, $t0, 1
	addi $t2, $t2, -1
	div $t1, $t4
	mflo $t1
	j Loop
Exit:
	jr	$ra		# return

################################ write your code above ################################

ret:

#STEP6: write result (output_ascii) to file_out
# ($s4 = fd_out)
	
	li	$v0, 13			# 13 = open file
	la	$a0, file_out		# $a2 <= filepath
	li	$a1, 0x4301		# $a1 <= flags = 0x4301 for Windows, 0x41 for Linux
	li	$a2, 0644		# $a2 <= mode = 0
	syscall				# $v0 <= $s0 = fd_out
	move	$s4, $v0		# store fd_out in $s4
	
	li	$v0, 15			# 15 = write file
	move	$a0, $s4		# $a0 <= $s4 = fd_out
	la	$a1, output_ascii
	li	$a2, 4		
	syscall				# $v0 <= $s0 = fd
	
#STEP7: this is for you to debug your calculation on console
	li	$v0, 1			# 1 = print int
	lw	$a0, output		# $a0 <= $s1
	syscall				# print output


#STEP8: close file_in and file_out

	li	$v0, 16			# 16 = close file
	move	$a0, $s0		# $a0 <= $s0 = fd_in
	syscall				# close file

	li	$v0, 16			# 16 = close file
	move	$a0, $s4		# $a0 <= $s4 = fd_out
	syscall				# close file


# exit

	li	$v0, 10
	syscall



#######################################################################################
#
#  int atoi ( const char *str );
#
#  Parse the cstring str into an integral value
#
#  Author: http://stackoverflow.com/questions/9649761/mips-store-integer-data-into-array-from-file
atoi:
    	or      $v0, $zero, $zero   	# num = 0
   	or      $t1, $zero, $zero   	# isNegative = false
    	lb      $t0, 0($a0)
    	bne     $t0, '+', .isp      	# consume a positive symbol
    	addi    $a0, $a0, 1
.isp:
    	lb      $t0, 0($a0)
    	bne     $t0, '-', .num
    	addi    $t1, $zero, 1       	# isNegative = true
    	addi    $a0, $a0, 1
.num:
    	lb      $t0, 0($a0)
    	slti    $t2, $t0, 58        	# *str <= '9'
    	slti    $t3, $t0, '0'       	# *str < '0'
    	beq     $t2, $zero, .done
    	bne     $t3, $zero, .done
    	sll     $t2, $v0, 1
    	sll     $v0, $v0, 3
    	add     $v0, $v0, $t2       	# num *= 10, using: num = (num << 3) + (num << 1)
    	addi    $t0, $t0, -48
    	add     $v0, $v0, $t0       	# num += (*str - '0')
    	addi    $a0, $a0, 1         	# ++num
    	j   .num
.done:
    	beq     $t1, $zero, .out    	# if (isNegative) num = -num
    	sub     $v0, $zero, $v0		
.out:
    	jr      $ra         		# return

