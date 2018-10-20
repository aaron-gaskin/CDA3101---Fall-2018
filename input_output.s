EOFLENGTH = 12
RCVRCTL = 0xFFFF0000  #receiver control register address
RCVRDBR = 0xFFFF0004  #receiver data register address
XMITCTL = 0xFFFF0008  #transmitter control reg. address
XMITDBR = 0xFFFF000C  #transmitter data reg. address

	.text 0x400800
	.globl main
main:
	sw $ra, retadr  #save return address
cloop:	jal rdrec	#call read record routine
	beq $v0, $0, endfile	#done if no more records
	jal wrrec	#else write out the record
	j cloop
endfile: la $a0, eof	#output end of file message
	li $v0, EOFLENGTH #message length
	jal wrrec	#output the message
	lw $ra, retadr	#recover return address
	jr $ra
rdrec:
	la $t2, RCVRDBR	#data but reg. address
	la $t0, RCVRCTL	#control reg. address
	or $v0, $0, $0	#init record length
	lb $t3, eor	#end-of-record indicator
rpoll: 	lw $t1, 0($t0)	#read control reg.
	andi $t1, 1	#mask all but ready bit
	beq  $t1, $0, rpoll #recheck if not ready
	lw $t1, 0($t2)	#input the data
	sb $t1, buffer($v0) #store the next byte
	addi $v0, $v0, 1 #adjust buffer pointer/count
	bne $t1, $t3, rpoll #continue if not end-of-rec
	jr $ra		#else return
wrrec:	la $t2, XMITDBR #data but reg. address
	la $t0, XMITCTL #control reg. address
wpoll:	lw $t1, 0($t0) 	#read control reg.
	andi $t1, 1	#mask all but ready bit
	beq $t1, $0, wpoll #recheck if not ready
	lb $t1, 0($a0)	#get next byte
	sw $t1, 0($t2)	#send it to the output port
	addi $a0, $a0, 1 #point to next data byte
	addi $v0, $v0, -1 #decrement count
	bne $v0, $0, wpoll #continue if not end-of-ref
	jr $ra  	#else return
.data 0x1000C000
retadr:	.space 4
buffer:	.space 4096
bufend:	.space 4
eor:	.ascii "End of file\n"
	.end	
