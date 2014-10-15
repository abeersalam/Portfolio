;Author: Abeer Salam
;Email: abeerguy@gmail.com
;Course: CPSC240-MonWed
;Assignment number: 6
;Due date: December 16, 2013
;File name: sumarray.asm
;Program name: subprograms
;Language: X86-64
;Syntax: Intel
;Page width maximum: 140 columns
;Comments begin at column: 61
;Statement of Purpose: Take an array from main program and compute the total sum for the array, then return the sum back to main
;Status: Completed
;
;Precondition:  
; - rdi points to start of an array
; - rsi holds count of items in the array
;Postcondition: 
; - rax holds total sum

;===== Begin area for sumarray program ====================================================================================================

extern printf                                               ;call external subprograms
global sumarray                                             ;program is callable by other programs.

segment .data                                               ;initialized data are placed in this segment

align 16                                                    ;start new data on a 16-byte boundary

;===== Declare formats for output =========================================================================================================

floatinputformat db "%lf", 10, 0

segment .bss                                                ;uninitialized data are declared in this segment

segment .text                                               ;instructions are placed in this segment

sumarray:                                                   ;execution of this program will begin here.

align 16                                                    ;start the next instruction on a 16-byte boundary

;===== Back up the registers that are used in this program ================================================================================

push rbp                                                    ;backup base pointers
push rdi                                                    ;backup 
push rsi                                                    ;backup
push r12                                                    ;backup
push r13                                                    ;backup
push r14                                                    ;backup
push r15                                                    ;backup   
pushf                                                       ;backup flags
pushf                                                       ;backup flags

;===== Store pointers =====================================================================================================================

mov qword r13, 0                                            ;initialize space on stack to zero to use for array index
mov       r14, rdi                                          ;set a register to hold pointer to array
mov       r15, rsi                                          ;set a register to hold count of values in the array

;===== Array Sum ==========================================================================================================================
whileS:                                                   	;while loop
     cmp r13, r15                                           ;compare index to total count value
     jnl end_whileS                                       	;if greater, jump to the end and exit
     movsd xmm0, [r14 + r13 * 8]                            ;move current element into xmm to sum
     addsd xmm1, xmm0                                       ;add elements and store in xmm that holds the sum
     inc r13                                                ;increment at each iteration of loop until equal to total count
     jmp whileS                                           	;jump to top of the loop for next iteration  
end_whileS:                                               	;exits loop

;===== Prepare to return ==================================================================================================================

push qword 0                                                ;create space
movsd [rsp], xmm1                                           ;move the sum to return to the main program
pop rax                                                     ;ensure that sum will be outputted

;===== Restore registers ==================================================================================================================

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
