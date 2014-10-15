;Author: Abeer Salam
;Email: abeerguy@gmail.com
;Course: CPSC240-MonWed
;Assignment number: 6
;Due date: December 16, 2013
;File name: assn6m.asm
;Program name: subprograms
;Language: X86-64
;Syntax: Intel
;Page width maximum: 140 columns
;Comments begin at column: 61
;Statement of Purpose: Calls subprograms to run various operations on an array
;
;Status: Completed
;
;Assemble: nasm -f elf64 -l assn6.lis -o assn6.o assn6.asm
;
;===== Begin area for source code =========================================================================================================

extern printf, scanf                                        ;call external subprograms
extern getarray, outputcarray                               ;call external subprograms
extern sumarray, mathlength                                 ;call external subprograms
extern setpointerarray, showarraybypointer                  ;call external subprograms
extern reciprocal, selectionsort, copyarray                 ;call external subprograms

global assn6m                                      			;program is callable by other programs

segment .data                                               ;initialized data are placed in this segment

align 16                                                    ;start new data on a 16-byte boundary

;===== Declare some messages ==============================================================================================================

welcome db "This program will demonstrate various array processing functions.", 10, 0
enterData db "Now enter data for the array." ,0
arrayData db 10, "The data of the array are: " ,0
arraySorted db "The sorted array is" ,0
arrayRSorted db 10, "The sorted reciprocal array is" ,0
arrayRecip db 10, "The reciprocal array is", 0
arraySort db 10, "The array will now be sorted by pointers" ,0 
arrayOrig db 10, "The original array of doubles was", 0
arrayROrig db "and the original array of reciprocal doubles was", 0
goodbye db 10, "The main assembly program will now return to the driver.", 10, 0
emptyline db "", 0

;===== Declare formats for output =========================================================================================================

stringformat db "%s", 10, 0
floatinputformat db "%lf", 10, 0

;===== Declare formats for output =========================================================================================================

arrayNum db "The array of numbers is", 0
arraySum db 10, "The sum of the array is %lf", 10, 0
arrayLength db "The geometric length of the array is %.18lf", 10, 0
arrayRSum db 10, "The sum of the reciprocal array is %lf", 10, 0
arrayRLength db "The geometric length of the reciprocal array is %.18lf", 10, 0


;===== Declare some constants in an array =================================================================================================
segment .bss                                                ;uninitialized data are declared in this segment

array1 resq 12                                          	;array of 12 qwords for the first input
array2 resq 12                                         		;array of 12 qwords for the second input
arrayR resq 12
pointerR resq 12

segment .text                                               ;instructions are placed in this segment

assignment6main:                                            ;program starts here

align 16                                                    ;start the next instruction on a 16-byte boundary

;===== Backup registers ===================================================================================================================

push rbp                                                    ;backup
push rdi                                                    ;backup 
push rsi                                                    ;backup
push r12                                                    ;backup
push r13                                                    ;backup
push r14                                                    ;backup
push r15                                                    ;backup   
pushf                                                       ;backup
pushf                                                       ;backup

;===== Output the welcome message =========================================================================================================

mov qword rdi, stringformat                                 ;Use format "%s"
mov qword rsi, welcome                                      ;"This program will..."
mov qword rax, 0                                            ;ensure no data is read in from xmm registers
call  printf                                                ;call print function

;===== Prompt for user input ==============================================================================================================

mov qword rdi, stringformat                                 ;Use format "%s"
mov qword rsi, enterData                                    ;"Now enter data..."
mov qword rax, 0                                            ;ensure no data is read in from xmm registers
call  printf                                                ;call print function

;===== Read input =========================================================================================================================

mov rdi, array1                                         	;rdi points to first element in array1
call getarray                                               ;function call to get array elements
mov r13, rax                                                ;r13 holds total count of array elements

;===== Duplicate original array to compute reciprocal array ===============================================================================

mov rdi, array1                                         	;rdi points to index in array1
mov rbp, arrayR                                         	;rbp points to index in reciprocal array
mov rsi, r13                                                ;move the total count into rsi
call copyArray                                              ;call function to copy original array

;===== Output message for data of the array ===============================================================================================

mov qword rdi, stringformat                                 ;Use format "%s"
mov qword rsi, arrayData                                  	;"The data of..."
mov qword rax, 0                                            ;ensure no data is read in from xmm registers
call  printf                                                ;call print function

;===== Output the array message ===========================================================================================================

mov qword rdi, stringformat                                 ;Use format "%s"
mov qword rsi, arrayNum                               		;"The array of..." 
mov qword rax, 0                                            ;ensure no data is read in from xmm registers
call  printf                                                ;call print function

;===== Output the original double array ===================================================================================================

mov rdi, array1                                             ;rdi points to index in array1
mov rsi, r13                                                ;move the total count into rsi
call outputcarray                                           ;call function to output array

;===== Compute sum ========================================================================================================================

mov rdi, array1                                         	;rdi points to index in array1
mov rsi, r13                                                ;rsi holds total count of array
call sumarray                                               ;external fuction sums the array
mov r15, rax                                                ;holds the sum
 
;===== Output sum =========================================================================================================================

push r15                                                    ;push sum to top of stack
movsd xmm0, [rsp]                                           ;move sum to xmm register
pop r15                                                     ;reverse previous push
mov qword rax, 1                                            ;rax receives 1 data from xmm registers
mov rdi, arraySum                                           ;"The sum of..."
call printf                                                 ;calls print function

;===== Compute geometric length ===========================================================================================================

mov rdi, array1                         	                ;rdi points to index in array1
mov rsi, r13                                                ;rsi holds total count of array
call mathlength                                             ;external function to compute geometric length of array
mov r15, rax                                                ;holds geometric length

;===== Output geometric length ============================================================================================================

push r15                                                    ;push sum to top of stack
movsd xmm0, [rsp]                                           ;move sum to xmm register
pop r15                                                     ;reverse previous push
mov qword rax, 1                                            ;rax receives 1 data from xmm registers
mov rdi, arrayLength                                        ;"The geometric length..."
call printf                                                 ;calls print function

;===== Output sort message ================================================================================================================

mov qword rdi, stringformat                                 ;use format "%s"
mov qword rsi, arraySort                                    ;"The array will now be sorted by pointers"
mov qword rax, 0                                            ;ensure no data is read in from xmm registers
call  printf                                                ;calls print function

;===== Attach pointer array to original array ================================================================================================

mov rdi, array1      	                                    ;rdi points to index in array1
mov rbp, array2         	                                ;rbp points to array2
mov rsi, r13                                                ;rsi holds total count of array
call setpointerarray                                        ;call function to fill pointer array with pointers

;===== Sort array ========================================================================================================================= 

mov rdi, array2                                        		;rdi points to index pointer in array2
mov rsi, r13                                                ;rsi holds total count of array
mov qword rax, 0                                            ;ensure no data is read in from xmm registers
call selectionsort                                          ;call function to sort pointers to array

;===== Output sorted array message ========================================================================================================

mov qword rdi, stringformat                                 ;use format "%s"
mov qword rsi, arraySorted                                  ;"The sorted array is..."
mov qword rax, 0                                            ;ensure no data is read in from xmm registers
call  printf                                                ;calls print function

;===== Output sorted array ================================================================================================================

mov rdi, array2                                        		;rdi points to index pointer in array2
mov rsi, r13                                                ;rsi holds total count of array
call showarraybypointer                                     ;call function to output array sorted by pointers

;===== Output reciprocal array message ====================================================================================================

mov qword rdi, stringformat                                 ;use format "%s"
mov qword rsi, arrayRecip                                   ;"The reciprocal array..."
mov qword rax, 0                                            ;ensure no data is read in from xmm registers
call  printf                                                ;calls print function

;===== Compute reciprocals ================================================================================================================

mov rdi, arrayR                                         	;rdi points to index in the arrayR (Copy of original array)
mov rsi, r13                                                ;rsi holds total count of array
call reciprocal                                      		;call function to compute reciprocal

;===== Output reciprocal array ============================================================================================================

mov rdi, arrayR                                         	;rdi points to index in the arrayR (reciporcal array)
mov rsi, r13                                                ;rsi holds total count of array
call outputcarray                                           ;call function to output contents of reciprocal array

;===== Compute reciprocal sum =============================================================================================================

mov rdi, arrayR                                         	;rdi points to index in arrayR
mov rsi, r13                                                ;rsi holds total count of array
call sumarray                                               ;call function to compute sum
mov r15, rax                                                ;holds the sum
 
;===== Output reciprocal sum ==============================================================================================================

push r15                                                    ;move reciprocal sum to top of stack
movsd xmm0, [rsp]                                           ;move reciprocal sum to the xmm register
pop r15                                                     ;reverse previous push
mov qword rax, 1                                            ;rax receives 1 data from xmm register
mov rdi, arrayRSum                                         	;"The sum of the reciprocal..."
call printf                                                 ;calls print function

;===== Compute geometric length of reciprocal array =======================================================================================

mov rdi, arrayR                                         	;rdi points to index in arrayR
mov rsi, r13                                                ;rsi holds total count of array
call mathlength                                             ;calls external function to compute geometric length
mov r15, rax                                                ;holds geometric length

;===== Output reciprocal geometric length =========================================================================================

push r15                                                    ;move sum to top of stack
movsd xmm0, [rsp]                                           ;move sum to xmm register
pop r15                                                     ;reverse previous push
mov qword rax, 1                                            ;rax receives 1 data from xmm register
mov rdi, arrayRLength                                       ;"The geometric length of..."
call printf                                                 ;calls print function

;===== Attach pointer array to reciprocal array =========================================================================================

mov rbp, pointerR                                      	 	;rbp points to index in pointerR (Array to hold recip pointers)
mov rdi, arrayR                                       	  	;rdi points to index in arrayR
mov rsi, r13                                                ;rsi holds total count of array
call setpointerarray                                        ;call function to create array of pointers to reciprocal array

;===== Sort pointers to reciprocal array =================================================================================================

mov rdi, pointerR                                       	;rdi points to index pointer in pointerR
mov rsi, r13                                                ;rsi holds total count of array
mov qword rax, 0                                            ;ensure no data is read in from xmm registers
call selectionsort                                          ;call function to sort pointers to array

;===== Output sorted array message ========================================================================================================

mov qword rdi, stringformat                                 ;use format "%s"
mov qword rsi, arrayRSorted                               	;"The sorted reciprocal..."
mov qword rax, 0                                            ;ensure no data is read in from xmm registers
call  printf                                                ;calls print function

;===== Output sorted reciprocal array =====================================================================================================

mov rdi, pointerR                                       	;rdi points to index pointer in pointerR
mov rsi, r13                                                ;rsi holds total count of array
call showarraybypointer                                     ;External function call to show the sorted array by pointers

;===== Output data of the original array message ==========================================================================================

mov qword rdi, stringformat                                 ;use format "%s"
mov qword rsi, arrayOrig                                    ;"The data of..."
mov qword rax, 0                                            ;ensure no data is read in from xmm registers
call  printf                                                ;calls print function

;===== Output original double array =======================================================================================================

mov rdi, array1                                         	;rdi points to index in array1
mov rsi, r13                                                ;move count into rsi
call outputcarray                                           ;call function to output original array

;===== Output original reciprocal array message ===========================================================================================

mov qword rdi, stringformat                                 ;use format "%s"
mov qword rsi, arrayROrig                                 	;"and the original array of..."
mov qword rax, 0                                            ;ensure no data is read in from xmm registers
call  printf                                                ;calls print function

;===== Output original reciprocal array ===================================================================================================

mov rdi, arrayR                                         	;rdi points to index in array1
mov rsi, r13                                                ;move count into rsi
call outputcarray                                           ;call function to output original reciprocal array
 
;===== Output goodbye message =============================================================================================================

mov qword rdi, stringformat                                 ;use format "%s"
mov qword rsi, goodbye                                      ;"The main assembly program will now..."
mov qword rax, 0                                            ;ensure no data is read in from xmm registers
call  printf                                                ;call print function

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

mov qword rax, arrayR                                   	;returns reciprocal array to driver
ret                                                         
;===== End of program  ====================================================================================================================
