#Aaron Gaskin
#9930-5710
#CDA3101 - Computer Organization
#10/16/18

#format necessary memory =================================================
.data
prompt: .asciz "Input a string\n"
stringType: .asciz "%s"
outType: .asciz "%c"
tempType: .asciz "%s \n"
numType: .asciz "%d \n"
flush: .asciz "\n"   
input: .space 256
length: .space 256
revBuffer: .space 256
true: .asciz "True"
false: .asciz "False"

#start text for machine to read ==========================================
.text
.global main

#compile with gcc pa1.s -o pa1 -gcc
#run with gdb pa1
	#'r' to run, 'b "method" ' to create a breakpoint, 'i r' to see register values
	#'info break' to list breaks and 'del "num" ' to remove breaks

#start main ==============================================================
main:

	#read input string
		#load in string type
		ldr x0, =stringType
		#output prompt/introduction
		ldr x1, =prompt
		bl printf

		#load in string type
		ldr x0, =stringType
		#assign input as location to save to
		ldr x1, =input
		bl scanf
		
	#compute length of string
		
		#store input into x9
		ldr x9, =input
		#starting index value
		mov x10, #0
		bl compute_length
		
		mov x13, x10
		
	#output the length of the string
		
		#load in output type
		ldr x0, =numType
		bl printf
		
	#determine if the string is a palindrome
	
		#Get length read in
		mov x0, x13
		
		#Change length to length-1
		sub x0, x0, #1 
		
		#Move string address to x1
        ldr x1, =input
		
		#Starting index for reverse
        mov x2, #0
		
		#set x13 to starting index
		mov x13, #0
        bl reverse
		
		#since we are back in main, string is a palindrome so call method
		b isPalin
		
		
#copied from reverse sample code =========================================
#start to reverse the string
reverse:    #In reverse we want to maintain
            #x0 is length-1
            #x1 is memory location where string is
            #x2 is index

            subs x3, x2, x0
			

            #If we haven't reached the last index, recurse
            b.lt recurse
	
	
#copied from reverse example code ========================================
#base case		
base:		#We need to keep x1 around because that's the string address!
            #Also bl will overwrite return address, so store that too
            stp x30, x1, [sp, #-16]!
            ldrb w1, [x1, x2]
		
			#grab first value of input and compare with last
			ldr x14, =input
			ldrb w14, [x14,x13]
			#increment counter (x13) for input
			add x13,x13,#1
			sub x21,x14,x1
			#if not zero, not palindrome so break to method then end program
			cbnz x21, notPalin
			
			
            ldp x30, x1, [sp], #16

            #Go back and start executing at the return
            #address that we stored 
            br x30
			

#copied from reverse example code ========================================
#manipulate stack to make a recursive call
recurse:    #First we store the frame pointer(x29) and 
            #link register(x30)
            sub sp, sp, #16
            str x29, [sp, #0]
            str x30, [sp, #8]

            #Move our frame pointer
            add x29, sp, #8

            #Make room for the index on the stack
            sub sp, sp, #16

            #Store it with respect to the frame pointer
            str x2, [x29, #-16]

            add x2, x2, #1 

            #Branch and link to original function. 
            bl reverse
			

#copied from reverse example code ========================================
#look in stack and print word when done with recursion         
end_rec:    #Back from other recursion, so load in our index
			ldr x2, [x29, #-16]

            #Find the char
            stp x30, x1, [sp, #-16]!
            ldrb w1, [x1, x2]
			
			#grab first value of input and compare with last
			ldr x14, =input
			ldrb w14, [x14,x13]
			#increment counter (x13) for input
			add x13,x13,#1
			sub x21,x14,x1
			#if not zero, not palindrome so break to method then end program
			cbnz x21, notPalin
			
            ldp x30, x1, [sp], #16

            #Clear off stack space used to hold index
            add sp, sp, #16

            #Load in fp and lr
            ldr x29, [sp, #0]
            ldr x30, [sp, #8]
            
            #Clear off the stack space used to hold fp and lr
            add sp, sp, #16

            #Return to correct location in execution
            br x30
			

#code provided by TA during discussion section ===========================
#computes the length of a string recursively
compute_length:

		#calculate the length of the string
		
		#x10 is the counter, x9 is our input, w11 is char of input at x10
		ldrb w11, [x10,x9]
		#check if value of x9 at x10 is zero/null and go to done if so
		cbz w11, done
		#increment x10 by 1
		add x10,x10,#1
		#loop again if w11 is not null
		b compute_length
		
		
#return to main after calculating length =================================
done:
		#move length value (x10) into x1
		mov x1, x10
		
		#go back to main
		br x30

		
#the input IS a palindrome so output TRUE ===================================
isPalin:
		#load in string type
		ldr x0, =tempType
		#output prompt/introduction
		ldr x1, =true
		bl printf
		
		#exit the program
		b exit
	
#the input is NOT a palindrome so output FALSE ==============================
notPalin:
		#load in string type
		ldr x0, =tempType
		#output prompt/introduction
		ldr x1, =false
		bl printf
	
		#exit the program
		b exit
	
	
#end the program =========================================================
exit:		
		#exit the program
		mov x8, #93
		mov x0, #42
		svc #0
		