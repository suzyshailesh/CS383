/*
 * hello_world.s
 *
 *  Created on: Oct 7, 2019
 *      Author: suzys
 */

 .text
 .global main
 .extern printf

 main:
 	ldr x15, = array //store address of array
 	mov x14, #14 //size of array

 arraysum:
	mov x9, #0  //i = 0, array counter
	mov w10, #0  // j = 0, sum
	loop:
	lsl x11, x9, #2 //x11 = i * 4
	add x12, x15, x11 //x12 = address of array[i]
	ldr w13, [x12, x11] //x13 = array[i]
	add w10, w10, w13 //x10 = x10 + array[i]
	add x9, x9, #1 //increment i
	cmp x9, x14 //compare i to size
	b.lt loop //if (i<size) go to loop

 testodd:
 	and w9, w10, #1 //w9 = w10 & 1
	cmp w9, #1 //compares w9 and 1, should be equal if sum is odd
	beq printodd //branches if w9 and 1 are equal
	ldr x0, =even //store address of "The sum is even." string
	bl printf //branches to print
	br x30 //exit

 printodd:
	ldr x0, =odd //store address of "The sum is even." string
	bl printf //branches to print
	br x30 //exit

 	.data

 array:
 	//stores array of values
 	.long 1025, 3, 1234567, 8, 128, 127, 126, 125, 54321, 1, 99, 100, 10439272
 	.align 8

 even:
 	//stores "The sum is even." string
 	.ascii "The sum is even.\n\0"

 odd:
 	//stores "The sum is odd." sting
 	.ascii "The sum is odd.\n\0"

	.bss
 	.end
