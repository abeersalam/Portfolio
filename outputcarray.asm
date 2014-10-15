;Author: Abeer Salam
;Email: abeerguy@gmail.com
;Course: CPSC240-MonWed
;Assignment number: 6
;Due date: Decemeber 16, 2013
;File name: outputcarray.asm
;Program name: subprograms
;Language: X86-64
;Syntax: Intel
;Page width maximum: 140 columns
;Comments begin at column: 61
;Statement of Purpose: Output contents of array
;
;Precondition:  
; - rdi holds pointer to the array
; - rsi holds total count of contents array
;Postcondition: 
; - output contents of the array
;
;Status: Completed
;
;===== Begin area for outputcarray program =================================================================================================

extern printf                                               ;call external subprograms
global outputcarray                                         ;program is callable by other programs

segment .data                                               ;initialized data are placed in this segment

align 16                                                    ;start new data on a 16-byte boundary

;===== Declare some messages and format====================================================================================================

floatinputformat db "%.18lf.", 10, 0

;===== Declare some constants in an array =================================================================================================

segment .bss                                                ;uninitialized data are declared in this segment

segment .text                                               ;instructions are placed in this segment
  
outputcarray:                                               ;execution of this program will begin here.

align 16                                                    ;start the next instruction on a 16-byte boundary

;===== Back up registers ===================================================================================================================

push rbp                                                    ;backup
push rdi                                                    ;backup
push rsi                                                    ;backup
push r12                                                    ;backup
push r13                                                    ;backup  
push r14                                                    ;backup
push r15                                                    ;backup
pushf                                                       ;backup flags
pushf														;backup flags

;===== Storing pointers ===================================================================================================================

mov qword r13, 0                                            ;create room on stack and initialize to zero for array index
mov       r14, rdi                                          ;set register to hold pointer to the array
mov qword r15, rsi                                          ;set register to hold the total count of array

;===== Print out array =====================================================================================================================

whilePrint:                                                 ;while loop
     cmp r13, r15                                           ;compare index to total count of array
     jnl end_whilePrint                                     ;if equal, jump to the end and exit
     movsd xmm0, [r14 + r13 * 8]                            ;move content of the array into xmm register
     mov qword rax, 1                                       ;rax receives 1 data from the xmm register for printing
     mov rdi, floatinputformat                              ;".lf"
     call printf                                            ;calls print function 
     inc r13                                                ;increment on each iteration
     jmp whilePrint                                         ;jump to top of loop   
end_whilePrint:                                             ;exit loop

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
