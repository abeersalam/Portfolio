;Author: Abeer Salam
;Email: abeerguy@gmail.com
;Course: CPSC240-MonWed
;Assignment number: 6
;Due date: Decemeber 16, 2013
;File name: copyarray.asm
;Program name: subprograms
;Language: X86-64
;Syntax: Intel
;Page width maximum: 140 columns
;Comments begin at column: 61
;Statement of Purpose: Takes in the user input and store it into the passed array from the main program. 
;					   Returns the size of the array back 
;
;Status: Completed
;
;Precondition:  
; - rdi must hold pointer to start of the original array
; - rsi must hold the total element count of the original array
; - rbp must hold pointer to start of the reciporcal array
;Postcondition: 
; - reciprocal array will be filled with the contents of the original array

;===== Begin area for copyarray program ====================================================================================================

extern printf                                               ;call external subprograms
global copyarray                                            ;program is callable by other programs

segment .data                                               ;initialized data are placed in this segment

align 16                                                    ;start new data on a 16-byte boundary

;===== Declare some constants in an array =================================================================================================

segment .bss                                                ;uninitialized data are declared in this segment

segment .text                                               ;instructions are placed in this segment

copyarray:                                                  ;program starts here

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

mov       r12, rbp                                          ;set register to hold pointer to the reciprocal array
mov qword r13, 0                                            ;create space on stack and initialize to zero
mov       r14, rdi                                          ;set register to hold pointer to the contents array
mov       r15, rsi                                          ;set register to hold total count of array

;===== Copy contents array to reciprocal array ============================================================================================

while_copy:                                                 ;while loop
     cmp r13, r15                                           ;compare index value to total count of array
     jnl end_while_copy                                     ;If equal, jump to the end and exit
     mov rax, [r14 + r13 * 8]                               ;move element stored in the original array to rax
     mov [r12 + r13 * 8], rax                               ;move element stored in rax and copy to reciprocal array
     add r13,1                                              ;increment on each iteration
     jmp while_copy                                         ;jump to top of loop
end_while_copy:                                             ;exit loop

;===== Restore registers ==================================================================================================================

popf                                                        ;restore
popf                                                        ;restore
pop r15                                                     ;restore
pop r14                                                     ;restore
pop r13                                                     ;restore
pop r12                                                     ;restore
pop rsi                                                     ;restore
pop rdi                                                     ;restore
pop rbp                                                     ;restore

ret                                                        
;===== End of program =====================================================================================================================
