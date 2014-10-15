;Author: Abeer Salam
;Email: abeerguy@gmail.com
;Course: CPSC240-MonWed
;Assignment number: 6
;Due date: Decemeber 16, 2013
;File name: getarray.asm
;Program name: subprograms
;Language: X86-64
;Syntax: Intel
;Page width maximum: 140 columns
;Comments begin at column: 61
;Statement of Purpose: Reads in user input and stores into an array from the main program; return the size of the array 
;
;Status: Completed
;
;Precondition:  
; - rdi holds pointer to start of array
;Postcondition: 
; - rax returns the size of the array
; - array is filled with user inputs

;===== Begin area for getarray program ====================================================================================================

extern printf, getchar, scanf                               ;call external subprograms

global getarray                                             ;program is callable by other programs

segment .data                                               ;initialized data are placed in this segment

align 16                                                    ;start new data on a 16-byte boundary

;===== Declare messages====================================================================================================================

question db "Do you have more data for the array (Y or N)?: " ,0
enterInput db "Enter a quadword double: ", 0

;===== Declare formats ====================================================================================================================

floatinputformat db "%lf", 0
stringformat db "%s", 0
charformat db "%c",0  

;===== Declare some constants in an array =================================================================================================

segment .bss                                                ;uninitialized data are declared in this segment

segment .text                                               ;instructions are placed in this segment
  
getarray:                                                   ;program starts here.

align 16                                                    ;start the next instruction on a 16-byte boundary

;===== Back up the registers that are used in this program ================================================================================

push rbp                                                    ;backup
push rdi                                                    ;backup 
push rcx                                                    ;backup
push rdx                                                    ;backup
push rsi                                                    ;backup
push r12                                                    ;backup
push r13                                                    ;backup  
push r14                                                    ;backup
push r15                                                    ;backup
pushf                                                       ;backup flags
pushf														;backup flags

;===== Storing pointers ===================================================================================================================

mov qword r13, 0                                            ;create room on stack and initialize to zero for array index
mov       r15, rdi                                          ;set register to hold pointer to array

;===== Get input ==========================================================================================================================

loopStart:                                                  ;start of loop

  mov qword rax, 0                                          ;ensure that no xmm registers are read in
  mov rdi, stringformat                                     ;string format
  mov rsi, question                                       	;"Do you have more data..."
  call printf                                               ;call print function
  
  push qword 0                                              ;create space for incoming value
  mov rax, 0                                                ;ensure that no xmm registers are read in
  mov rdi, charformat                                  		;char format
  mov rsi, rsp                                              ;rsi is the 2nd (pass by ref) parameter

  call scanf                                                ;call scan function
  call getchar                                              ;call get char function
  pop r12                                                   ;store the user choice for later comparison
    
  cmp r12, 0x59                                             ;if yes
    je getNum                                            	;go into loop
    jne exitLoop                                            ;else exit the loop

getNum:                                                  	;gets number from user
  mov qword rax, 0                                          ;ensure that no xmm registers are read in
  mov rdi, stringformat                                     ;String format
  mov rsi, enterInput                                      	;"Please enter..."
  call printf                                               ;calls print function
  
  push qword 0                                              ;create space
  push qword 0                                              ;create  space
  mov qword rax, 0                                          ;ensure that no xmm registers are read in
  mov rdi, floatinputformat                                	;"%lf"
  mov rsi, rsp                                              ;rsi is the 2nd (pass by ref) parameter
  
  call scanf                                                ;call scan function        
  call getchar                                              ;removes whitespace      
  pop r14                                                   ;store number in register    
  pop rax                                                   ;clear stack
  mov [r15 + r13 * 8], r14                                  ;move input into the array
  add r13, 1                                                ;increment array count  
  jmp loopStart                                             ;jump to loopStart
   
exitLoop:                                                   ;exits loop

mov rax, r13                                                ;send array size back to main

;===== Restore registers =================================================================================================================

popf                                                        ;restore flags
popf                                                        ;restore flags
pop r15														;restore
pop r14														;restore
pop r13														;restore
pop r12														;restore
pop rdx														;restore
pop rcx														;restore
pop rsi														;restore
pop rdi														;restore
pop rbp														;restore

ret
;===== End of program =====================================================================================================================
