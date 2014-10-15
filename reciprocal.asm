;Author: Abeer Salam
;Email: abeerguy@gmail.com
;Course: CPSC240-MonWed
;Assignment number: 6
;Due date: December 16, 2013
;File name: reciprocal.asm
;Program name: subprograms
;Language: X86-64
;Syntax: Intel
;Page width maximum: 140 columns
;Comments begin at column: 61
;Statement of Purpose: Reads in array from main and computes an array of its reciprocals
;
;Status: Completed
;
;Precondition:  
; - rdi holds pointer to start of contents array
; - rsi holds total count of array
;Postcondition: 
; - new array created holding reciprocal values of contents array

;===== Begin area for reciprocal code =====================================================================================================

extern printf                                               ;call external subprograms
global reciprocal                                    		;program is callable by other programs

segment .data                                               ;initialized data are placed in this segment

align 16                                                    ;start new data on a 16-byte boundary

intialNum   dd 1                                            ;constant one value

;===== Declare some constants in an array =================================================================================================

segment .bss                                                ;uninitialized data are declared in this segment

segment .text                                               ;instructions are placed in this segment

reciprocal:                                          		;program starts here

align 16                                                    ;start the next instruction on a 16-byte boundary

;===== Backup registers ===================================================================================================================

push rbp                                                    ;backup
push rdi                                                    ;backup 
push rsi                                                    ;backup
push r12                                                    ;backup
push r13                                                    ;backup
push r14                                                    ;backup
push r15                                                    ;backup   
pushf                                                       ;backup flags
pushf                                                       ;backup flags

;===== Storing pointers ===================================================================================================================

mov qword r13, 0                                            ;create stack space and initialize to zero
mov       r14, rdi                                          ;set register to hold pointer to array
mov       r15, rsi                                          ;set register to hold total count

;===== Computation ========================================================================================================================

whileRec:                                                   ;while loop
     cmp r13, r15                                           ;compare index value to total count of array
     jnl end_whileRec                                       ;if equal, jump to the end and exit
     cvtsi2sd xmm1,[intialNum]                              ;initialize xmm1 register to 1
     movsd xmm0, [r14 + r13 * 8]                            ;move array element into xmm0 register
	divsd xmm1, xmm0                                    	;divide 1 by element obtain reciprocal
	push qword 0                                        	;create stack space 
	movsd [rsp], xmm1                                   	;move reciprocal to r12         
	pop r12                                             	
	mov [r14 + r13 * 8], r12                            	;copy reciprocal into the array
     inc r13                                                ;increment on each iteration
     jmp whileRec                                           ;jump to top of loop  
end_whileRec:                                               ;exit loop

;===== Restoring all the values ===========================================================================================================

popf                                                        ;restore flags
popf                                                        ;restore flags
pop r15                                                     ;restore
pop r14                                                     ;restore
pop r13                                                     ;restore
pop r12                                                     ;restore
pop rsi                                                     ;restore
pop rdi                                                     ;restore
pop rbp                                                     ;restore

ret                                                         
;===== End of program =====================================================================================================================
