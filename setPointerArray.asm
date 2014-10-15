;Author: Abeer Salam
;Email: abeerguy@gmail.com
;Course: CPSC240-MonWed
;Assignment number: 6
;Due date: December 16, 2013
;File name: setpointerarray.asm
;Program name: subprograms
;Language: X86-64
;Syntax: Intel
;Page width maximum: 140 columns
;Comments begin at column: 61
;Statement of Purpose: Reads in array from main program and create an array of pointers pointing to the contents of the array
;Status: Completed
;
;Precondition:  
; - rdi holds pointer to start of array
; - rsi holds size of the array
; - rbp points to the array to receive pointers
;Postcondition: 
; - pointer array is created and points to contents of content array
;===== Begin area for setpointerarray program =============================================================================================

extern printf                                               ;call external subprograms
global setpointerarray                                      ;program is callable by other programs

segment .data                                               ;initialized data are placed in this segment

align 16                                                    ;start new data on a 16-byte boundary

;===== Declare some constants in an array =================================================================================================

segment .bss                                                ;uninitialized data are declared in this segment

segment .text                                               ;instructions are placed in this segment

setpointerarray:                                            ;program starts here

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

mov       r12, rbp                                          ;set register to hold the pointer to the pointer array
mov qword r13, 0                                            ;create room on stack and initialize to zero for array index
mov       r14, rdi                                          ;set register to hold the pointer to the array from rdi
mov       r15, rsi                                          ;set register to hold the total count in the array

;===== Set pointer array ==================================================================================================================

whileSet:                                                   ;while loop
     cmp r13, r15                                           ;compare index to total count in the array
     jnl end_whileSet                                       ;if equal, jump to the end and exit
     mov [r12 + r13 * 8], r14                               ;store pointer to the element in contents array in the pointer array
     add r14, 8                                             ;increment contents array index
     inc r13                                                ;increment pointer array index
     jmp whileSet                                           ;jump to top of loop  
end_whileSet:                                               ;exit loop

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
