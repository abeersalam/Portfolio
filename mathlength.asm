;Author: Abeer Salam
;Email: abeerguy@gmail.com
;Course: CPSC240-MonWed
;Assignment number: 6
;Due date: December 16, 2013
;File name: mathlength.asm
;Program name: subprograms
;Language: X86-64
;Syntax: Intel
;Page width maximum: 140 columns
;Comments begin at column: 61
;Statement of Purpose: Reads in array from main, computes the geometric length for the array and returns the value back to main
;
;Status: Completed
;
;Precondition:  
; - rdi holds pointer to start of array
; - rsi holds count of items in the array
;Postcondition: 
; - rax holds geometric sum

;===== Begin area for mathlength program ====================================================================================================

extern printf                                               ;call external subprograms
global mathlength                                      		;program is callable by other programs

segment .data                                               ;initialized data are placed in this segment

align 16                                                    ;start new data on a 16-byte boundary

;===== Declare some constants in an array =================================================================================================

segment .bss                                                ;uninitialized data are declared in this segment

segment .text                                               ;instructions are placed in this segment

mathlength:                                                  ;program starts here

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

;===== Storing pointers ====================================================================================================================

mov qword r13, 0                                            ;create stack space and initialize to zero for array index
mov       r14, rdi                                          ;set register to hold pointer to array
mov       r15, rsi                                          ;set register to hold total count of the array

;===== Calculate geometric length ==========================================================================================================

whileLoop:                                                  ;While loop
     cmp r13, r15                                           ;compare index to total count of the array
     jnl end_whileGeo                                       ;if equal, jump to the end and exit
     movsd xmm1, [r14 + r13 * 8]                            ;move element into xmm register
     mulsd xmm1, xmm1                                       ;multiply elements and store in xmm1
     addsd xmm0, xmm1                                       ;Add the x-squared value to xmm1
     inc r13                                                ;increment on each iteration
     jmp whileLoop                                          ;Jump back to top
end_whileLoop:                                              ;exit loop

;===== Prepare the output to be returned ==================================================================================================

sqrtsd xmm0, xmm0                                           ;Square root the total value to achieve geometric length
push qword 0                                                ;create stack space
movsd [rsp], xmm0                                           ;move length into a register
pop rax                                                     ;ensures length will be outputted

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
