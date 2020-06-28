/*
 * msort.s
 *
 *  Created on: Nov 17, 2019
 *      Author: Susmitha Shailesh
 */

.text
.equ ELEM, 12
.global main
.extern printf

main:
	ldr x0, =stack
	mov sp, x0					// stack held in stack pointer (sp)
	ldr x15, =vector			// x15 = first element in the array
	ldr x14, =scratch			// x14 = first element in the scratch array
	mov x0, #0 					// x0 = lo
	mov x1, #11					// x1 = hi
	bl sort						// do recursive mergesort
	bl print					// print array
	br x30 						// branch back to caller

.func sort
sort:
	sub x9, x1, x0
	lsr x9, x9, #1
	add x2, x9, x0				// mid = lo + (hi - lo) / 2

	stp x0, x1, [sp, #-16]!		// push lo and hi onto the stack
	stp x2, x30, [sp, #-16]!	// push mid and link register onto the stack

	cmp x0, x1
	bge sort_end				// base case: if lo >= hi, return

	mov x1, x2					// update new hi: hi = mid
	bl sort						// recursive call on left half of array

	ldp x2, x30, [sp], #16		// pop lo and hi
	ldp x0, x1, [sp], #16		// pop mid and link register

	sub sp, sp, #32				// move back stack head

	add x0, x2, #1				// update new lo: lo = mid + 1
	bl sort						// recursive call on right half of array

	ldp x2, x30, [sp], #16		// pop lo and hi
	ldp x0, x1, [sp], #16		// pop mid and link register

	sub sp, sp, #32				// move back stack head

merge:
	mov x12, x0					// L = lo
	add x13, x2, #1				// H = mid + 1

	mov x11, x0					// k = lo

loop:
	cmp x11, x1					// if k = hi
	bgt update_array				// exit loop

	cmp x12, x2					// if L > mid
	bgt else					// go to else

	cmp x13, x1					// if H > hi
	bgt then					// go to then

	lsl x9, x12, #3
	ldr x9, [x15, x9]
	lsl x10, x13, #3
	ldr x10, [x15, x10]
	cmp x9, x10					// if A[L] > A[H]
	bgt else					// go to else

then:
	lsl x9, x12, #3
	ldr x9, [x15, x9]
	lsl x10, x11, #3
	str x9, [x14, x10]			// scratch[k] = A[L]

	add x12, x12, #1 			// L = L + 1

	add x11, x11, #1			// increment k
	bl loop						// continue loop

else:
	lsl x9, x13, #3
	ldr x9, [x15, x9]
	lsl x10, x11, #3
	str x9, [x14, x10]			// scratch[k] = A[H]

	add x13, x13, #1 			// H = H + 1

	add x11, x11, #1			// increment k
	bl loop						// continue loop

update_array:
	mov x11, x0					// k = lo

update_array_loop:
	cmp x11, x1					// if k = hi
	bgt update_array_loop_end		// end loop

	lsl x10, x11, #3
	ldr x9, [x14, x10]
	str x9, [x15, x10] 			// A[k] = scratch[k]

	add x11, x11, #1			// increment k
	bl update_array_loop

update_array_loop_end:
	ldp x2, x30, [sp], #16		// pop lo and hi
	ldp x0, x1, [sp], #16		// pop mid and link register
	br x30

sort_end:

	ldp x2, x30, [sp], #16		// pop lo and hi
	ldp x0, x1, [sp], #16		// pop mid and link register
	br x30
	.endfunc

print:
	mov x21, #0					// k = 0
	bl print_loop				// for loop to iterate through and print array

print_loop:
	cmp x21, #ELEM				// if k > array size
	beq print_end				//exit loop

	lsl x29, x21, #3
	ldr x0, =string
	ldr x1, [x15, x29]
	bl printf					//prints kth element in array

	add x21, x21, #1			// increment k
	bl print_loop				//continue loop

print_end:
	br x30

.data
vector:
	.quad 987652, 975312, 12342, -23452, -72, 22, 42, 1234567892, 02, 5552, 232, 762 // Unsorted array

scratch:
	.quad -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 //temp array used for merging

string:
	.asciz "%d\n"

	.bss
	.align 8
out:
	.space 8
	.align 16
	.space 65536
stack:
	.space 16
	.end

//final code
