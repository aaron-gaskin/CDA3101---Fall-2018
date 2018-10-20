

.global _start
.section .text

_start:

/* syscall write(int fd, const void *buf, size_t count) */
/* the three arguments will be put in registers x0, x1, x2*/
/*syscall number is put in register x8.  It tells system what function to call*/

/* syscall read(int fd, const void *buf, size_t count) */
/* the three arguments will be put in registers x0, x1, x2*/
/* the item read will be in the register x1*/
/* the return value is the number of bytes read */
/*syscall number is put in register x8.  It tells system what function to call*/


mov x0, #0
ldr x1, =readformat;
mov x2, #4  //read four characters
mov x8, #63 //decimal 63 for read
svc #0 //do it!

//now x1 should have what was read
//write it out
mov x8, #64
mov x0, #1
mov x2, #4	//output four chars

//what is written should be what was read



svc #0


//exit the program
mov x8, #93
mov x0, #42
svc #0

ret

.section .data


readformat:
    .asciz "%c"
