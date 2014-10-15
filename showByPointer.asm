;Author: Abeer Salam
;Email: abeerguy@gmail.com
;Course: CPSC240-MonWed
;Assignment number: 6
;Due date: Decemeber 16, 2013
;File name: showarraybypointer.asm
;Program name: subprograms
;Language: X86-64
;Syntax: Intel
;Page width maximum: 140 columns
;Comments begin at column: 61
;Statement of Purpose: Output the contents of array using pointers to the contents
;
;Precondition:  
; - rdi holds pointer to the pointer array
; - rsi holds total count of contents array
;Postcondition: 
; - output the contents of the array
;
;Status: Completed
;
;===== Begin area for showarraybypointer program ==========================================================================================

extern printf                                               ;call external subprograms
global showarraybypointer                                   ;program is callable by other programs

segment .data                                               ;initialized data are placed in this segment

align 16                                                    ;start new data on a 16-byte boundary

;===== Declare formats for output =========================================================================================================

floatinputformat db "%.18lf.", 10, 0

;===== Declare some constants in an array =================================================================================================

segment .bss                                                ;uninitialized data are declared in this segment

segment .text                                               ;instructions are placed in this segment

showarraybypointer:                                         ;program starts here

align 16                                                    ;start the next instruction on a 16-byte boundary

;===== Back up the registers ==============================================================================================================

push rbp                                                    ;backup base pointers
push rdi                                                    ;backup 
push rsi                                                    ;backup
push r10													;backup
push r11													;backup
push r12                                                    ;backup
push r13                                                    ;backup
push r14                                                    ;backup
push r15                                                    ;backup   
pushf                                                       ;backup flags
pushf                                                       ;backup flags

;===== Store pointers =====================================================================================================================

mov qword r13, 0                                            ;create space on stack and initialize to zero for array index
mov       r14, rdi                                          ;register to hold the pointer to pointer array
mov       r15, rsi                                          ;register to hold the total count in the array

;===== Output array =======================================================================================================================

whilePoi:                                                   ;while loop
     cmp r13, r15                                           ;compare index value to total count
     jnl end_whilePoi                                       ;If equal, jump to the end and exit
     mov rdi, floatinputformat                              ;".lf"
     mov r12, [r14 + r13 * 8]                               ;move pointer to register to deference it
     movsd xmm0, [r12]                                      ;move again to xmm register for output
     mov qword rax, 1                                       ;rax reads in 1 data from xmm register set
     call printf                                            ;calls print function  
     inc r13                                                ;increment for each loop iteration until total count is reached
     jmp whilePoi                                           ;jump to beginning of loop  
end_whilePoi:                                               ;exit loop

;===== Restore registers ====================================================================================================================

popf                                                        ;restore flags
popf                                                        ;restore
pop r15                                                     ;restore
pop r14                                                     ;restore
pop r13                                                     ;restore
pop r12                                                     ;restore
pop r11														;restore
pop r10														;restore
pop rsi                                                     ;restore
pop rdi                                                     ;restore
pop rbp                                                     ;restore

ret                                                         
;===== End of program =====================================================================================================================
